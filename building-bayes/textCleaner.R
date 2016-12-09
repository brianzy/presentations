corpusMaker<-function(x){
  x<-scan(file.choose(), what="", sep="\n")
  x<-gsub("--\\s.*", "", x)
  x<-gsub("([-'])|[[:punct:]]", "", x)
  x<-strsplit(x, "[[:space:]]+")
  x<-data.frame(unlist(x))
  return(x)
}
