bayesClassifier<-function(menQ, womenQ, quote, menP, womenP){
  #gets row count of men and women data frames
  wCount<-nrow(womenQ)
  mCount<-nrow(menQ)
  #adds frequency column to men and women data frames
  menQ<-as.data.frame(table(menQ))
  womenQ<-as.data.frame(table(womenQ))
  #finds intersection of quote data frame and the above data frames
  newM<-menQ[is.element(menQ$m, intersect(quote$`unlist(x)`, menQ$menQ)),]
  newW<-womenQ[is.element(womenQ$w, intersect(quote$`unlist(x)`, womenQ$womenQ)),]
  #finds chance of occurance of words in quote in each data frame (womenQ and MenQ)
  #working on accounting for population size here as well
  newM$Freq<-newM$Freq/mCount*(mCount/(mCount+wCount))
  newW$Freq<-newW$Freq/wCount*(wCount/(mCount+wCount))
  #sums the frequency columns to come up with the likelihoods
  likelihoodW<-sum(newW$Freq)
  likelihoodM<-sum(newM$Freq)
  #multiplies likelihoods by priors to get posteriors
  posteriorM<-menP*likelihoodM
  posteriorW<-womenP*likelihoodW
  #test for higher posterior
  if(posteriorW>posteriorM){
    return("Woman")
  }
  return("Man")
}

