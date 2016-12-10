textCleaner<-function(x){
  x<-scan(x, what="", sep="\n")
  #removes the author of the quote because I am only interested in male or female
  x<-gsub("--\\s.*", "", x)
  #removes punctiation
  x<-gsub("([-'])|[[:punct:]]", "", x)
  #splits on spaces
  x<-strsplit(x, "[[:space:]]+")
  #formats as data frame
  x<-as.data.frame(unlist(x))
  return(x)
}
