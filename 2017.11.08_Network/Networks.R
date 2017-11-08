##http://varianceexplained.org/r/love-actually-network/

library(dplyr)
library(stringr)
library(tidyr)

isAllUpper <- function(x) {ifelse(unlist(gregexpr("[a-z]", x))[1] == -1, TRUE, FALSE)}

raw <- readLines("C:/Users/DKF4F/Desktop/2017.10.02_Love_Actually/love_actually.txt")

lines <- data_frame(raw1 = raw) %>%
  filter(raw1 != "")

lines$is_scene <- sapply(lines$raw1, isAllUpper)

lines <- lines %>% mutate(scene = cumsum(is_scene)) %>%
  filter(!is_scene) 
lines <- lines %>%
  separate(raw1, c("speaker", "dialogue"), sep = ":", fill = "left") %>%
  group_by(scene, line = cumsum(!is.na(speaker))) %>%
  summarize(speaker = speaker[1], dialogue = str_c(dialogue, collapse = " "))


## The Cast
cast <- read.csv(url("http://varianceexplained.org/files/love_actually_cast.csv"))
cast$speaker <- toupper(cast$speaker)

lines <- lines %>%
  inner_join(cast) %>%
  mutate(character = paste0(speaker, " (", actor, ")"))

by_speaker_scene <- lines %>%
  count(scene, character)

by_speaker_scene

## Reshape It
library(reshape2)
speaker_scene_matrix <- by_speaker_scene %>%
  acast(character ~ scene, fun.aggregate = length)

dim(speaker_scene_matrix)

## Analysis
norm <- speaker_scene_matrix / rowSums(speaker_scene_matrix)

h <- hclust(dist(norm, method = "manhattan"))

plot(h)

## Ordering
ordering <- h$labels[h$order]
ordering

## Scenes
scenes <- by_speaker_scene %>%
  filter(n() > 1) %>%        # scenes with > 1 character
  ungroup() %>%
  mutate(scene = as.numeric(factor(scene)),
         character = factor(character, levels = ordering))

ggplot(scenes, aes(scene, character)) +
  geom_point() +
  geom_path(aes(group = scene))

## Heat Map
non_airport_scenes <- speaker_scene_matrix[, colSums(speaker_scene_matrix) < 10]

cooccur <- non_airport_scenes %*% t(non_airport_scenes)

heatmap(cooccur)

## Map
library(igraph)
g <- graph.adjacency(cooccur, weighted = TRUE, mode = "undirected", diag = FALSE)
plot(g, edge.width = E(g)$weight, vertex.label.color="black", vertex.label.dist=1.5, vertex.size = 4)
