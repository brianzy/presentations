from pyspark.ml.classification import LogisticRegression
from pyspark.ml.evaluation import MulticlassClassificationEvaluator
from pyspark.ml.linalg import Vectors
from pyspark.ml.feature import VectorAssembler
from pyspark.ml.feature import MinMaxScaler
from pyspark.ml import Pipeline
from pyspark.ml.feature import OneHotEncoder
from pyspark.sql.types import *
from pyspark.ml.feature import StringIndexer
from pyspark.ml.tuning import ParamGridBuilder, TrainValidationSplit, CrossValidator
from pyspark.ml.evaluation import BinaryClassificationEvaluator
from pyspark.sql.functions import udf
from pyspark.sql.types import FloatType
from pyspark.sql import SQLContext
from pyspark.sql.session import SparkSession

if __name__ == "__main__":

	spark = SparkSession.builder.appName('predictFlightCans').getOrCreate()

	#get data from s3
	df = spark.read.csv("s3n://leesa.east2.training/hive_enriched_data/*", mode="DROPMALFORMED", inferSchema = True)
	df = df.withColumnRenamed("_c0", "station") \
						.withColumnRenamed("_c1", "station_name") \
						.withColumnRenamed("_c2", "elevation") \
						.withColumnRenamed("_c3", "latitude") \
						.withColumnRenamed("_c4", "longitude") \
						.withColumnRenamed("_c5", "dt") \
						.withColumnRenamed("_c6", "prcp") \
						.withColumnRenamed("_c7", "snow") \
						.withColumnRenamed("_c8", "awnd") \
						.withColumnRenamed("_c9", "tmin") \
						.withColumnRenamed("_c10", "tmax") 
						
	df = df.withColumn("dt", df["dt"].cast(DateType())).withColumn("prcp", df["prcp"].cast(DoubleType())).withColumn("snow", df["snow"].cast(DoubleType())) \
		.withColumn("tmax", df["tmax"].cast(DoubleType())).withColumn("tmin", df["tmin"].cast(DoubleType())).withColumn("awnd", df["awnd"].cast(DoubleType()))

	weatherDF = df.withColumn('new_tmin', (df['tmin']-32)/1.8).withColumn('new_tmax', (df['tmax']-32)/1.8).drop("tmax").drop("tmin").withColumnRenamed("new_tmax","tmax").withColumnRenamed("new_tmin","tmin")       


	flightsDF = spark.read.csv("s3n://leesa.east2.training/enriched_flight_data/ORD_flights_000", mode="DROPMALFORMED", inferSchema = True)
	flightsDF = flightsDF.withColumnRenamed("_c0", "ID") \
						.withColumnRenamed("_c1", "DAY_OF_MONTH") \
						.withColumnRenamed("_c2", "DAY_OF_WEEK") \
						.withColumnRenamed("_c3", "FL_DATE") \
						.withColumnRenamed("_c4", "YEAR") \
						.withColumnRenamed("_c5", "MONTH") \
						.withColumnRenamed("_c6", "UNIQUE_CARRIER") \
						.withColumnRenamed("_c7", "FL_NUM") \
						.withColumnRenamed("_c8", "DEP_HOUR") \
						.withColumnRenamed("_c9", "DEP_DEL15") \
						.withColumnRenamed("_c10", "AIR_TIME") \
						.withColumnRenamed("_c11", "FLIGHTS") \
						.withColumnRenamed("_c12", "DISTANCE") \
						.withColumnRenamed("_c13", "CANCELLED")
						
	flightsDF = flightsDF.withColumn("FL_DATE", flightsDF["FL_DATE"].cast(DateType()))


	#join data & select relevant columns
	joinedDF = flightsDF.join(weatherDF, flightsDF["FL_DATE"] == weatherDF["dt"])
	joinedDF = joinedDF.select(['ID','CANCELLED','DAY_OF_WEEK','MONTH','AIR_TIME','UNIQUE_CARRIER','prcp','snow','awnd','tmin','tmax'])
	joinedDF = joinedDF.withColumn("label", joinedDF['CANCELLED'])

	#impute null values in air_time -- these cause problems later on for modeling
	inputed_value = joinedDF.dropna().groupBy().avg('AIR_TIME').head()[0]
	joinedDF = joinedDF.na.fill(inputed_value, subset=['AIR_TIME'])


	#one hot encoder can only deal with integers
	indexer = StringIndexer(inputCol="UNIQUE_CARRIER", outputCol="UNIQUE_CARRIER_INDEX")
	#indexed = indexer.fit(joinedDF).transform(joinedDF)

	encoder = OneHotEncoder(inputCol = "UNIQUE_CARRIER_INDEX", outputCol = "UNIQUE_CARRIER_VEC")
	#encoded = encoder.transform(indexed)


	#need to input vector
	assembler = VectorAssembler(inputCols=['DAY_OF_WEEK','MONTH','AIR_TIME','prcp','snow','awnd','tmin','tmax','UNIQUE_CARRIER_VEC'], outputCol="unscaled_features")
	#assembled = assembler.transform(encoded)
	#assembled.show()

	#adjust the scale of features -- which helps with equal variance
	scaler = MinMaxScaler(inputCol="unscaled_features", outputCol="features")

	#simple model
	lr = LogisticRegression(maxIter=10)

	#put in pipeline -- helps for predcitors that go through same pipeline
	pipeline = Pipeline(stages = [indexer, encoder, assembler, scaler, lr])

	#setup parameter grid to select best params for prediciton -- builds 6 logistic regression models
	paramGrid = ParamGridBuilder()\
		.addGrid(lr.regParam, [0.1, 0.01]) \
		.addGrid(lr.elasticNetParam, [0.0, 0.5, 1.0])\
		.build()

	#there is a class imbalance so use area Under PR
	evaluator = BinaryClassificationEvaluator().setMetricName("areaUnderPR")

	#puts together whole 
	crossval = CrossValidator(estimator=pipeline,
							   estimatorParamMaps=paramGrid,
							   evaluator=evaluator,
							   numFolds=3)



	# Split the data into train and test
	splits = joinedDF.randomSplit([0.8, 0.2], 1234)
	train = splits[0]
	test = splits[1]


	# Run cross-validation, and choose the best set of parameters.
	cvModel = crossval.fit(train)

	prediction = cvModel.transform(test)


	evaluator.evaluate(prediction)


	#need funciton to extract first element of vector of probability
	secondelement=udf(lambda v:float(v[1]),FloatType())

	selected = prediction.withColumn("prob_of_cancel", secondelement(prediction["probability"])).select("ID", "prob_of_cancel", "prediction",'label')


	selected.coalesce(1).write.csv(path = "s3n://leesa.east2.training/predictions/flight_cancellation_predictions.csv",mode='overwrite', header=True)