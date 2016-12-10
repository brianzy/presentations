bayesClassifier<-function(menQ, womenQ, quote, menP, womenP){
  #gets row count of men and women data frames
  wCount<-nrow(womenQ)
  mCount<-nrow(menQ)
  #adds frequency column to men and women data frames
  menQ<-as.data.frame(table(menQ))
  womenQ<-as.data.frame(table(womenQ))
  #finds intersection of quote data frame and the above data frames
  intersectM<-menQ[is.element(menQ$menQ, intersect(quote$`unlist(x)`, menQ$menQ)),]
  intersectW<-womenQ[is.element(womenQ$womenQ, intersect(quote$`unlist(x)`, womenQ$womenQ)),]
  #get row count of men and women intersects
  iCountM<-nrow(intersectM)
  iCountW<-nrow(intersectW)
  #find the likelihoods for each hypothesis only considering the words that match 
  likelihoodM<-iCountM/(iCountM+iCountW)
  likelihoodW<-iCountW/(iCountM+iCountW)
  #probability that each word will occur in the individual dataframes
  intersectM$Freq<-intersectM$Freq/mCount
  intersectW$Freq<-intersectW$Freq/wCount
  #likelihood that the word will occur in the words that match
  intersectM$Freq<-intersectM$Freq*likelihoodM
  intersectW$Freq<-intersectW$Freq*likelihoodW
  #sums the frequency column which contains the individual posteriors
  posteriorM<-sum(intersectM$Freq)
  posteriorW<-sum(intersectW$Freq)
  #test for higher posterior
  if(posteriorW>posteriorM){
    return("Woman")
  }
  return("Man")
}

