bayesClassifier<-function(menq, womenq, quote, prior){
  wCount<-nrow(womenq)
  mCount<-nrow(menq)
  menq<-as.data.frame(table(menq))
  womenq<-as.data.frame(table(womenq))
  newM<-menq[is.element(menq$m, intersect(menq$m, quote$`unlist(x)`)),]
  newW<-womenq[is.element(womenq$w, intersect(womenq$w, quote$`unlist(x)`)),]
  newM$Freq<-newM$Freq/mCount
  newW$Freq<-newW$Freq/wCount
  likelihoodW<-sum(newW$Freq)
  likelihoodM<-sum(newM$Freq)
  posteriorM<-prior*likelihoodM
  posteriorW<-prior*likelihoodW
  if(posteriorW>posteriorM){
    return("Woman")
  }
  return("Man")
}