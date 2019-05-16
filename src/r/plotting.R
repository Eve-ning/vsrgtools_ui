# This file is used to load in feathers and plot it because
# Python plotting is way too hard

library(ggplot2)
library(feather)

feather_path <- "../feather/"

df <- read_feather(cat(feather_path, "hypnotize.feather"))
