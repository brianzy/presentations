-- Copy all flight data for Dec 2013 and 2014 from S3 bucket
copy ord_flights 
FROM 's3://leesa.east2.training/flightdata' 
IAM_ROLE '<put your IAM role here>'
csv IGNOREHEADER 1;
