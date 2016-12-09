textCleaner<-function(x){
  x<-scan(x, what="", sep="\n")
  x<-gsub("--\\s.*", "", x)
  x<-gsub("([-'])|[[:punct:]]", "", x)
  x<-strsplit(x, "[[:space:]]+")
  x<-as.data.frame(unlist(x))
  return(x)
}
