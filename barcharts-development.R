# Development of bar charts for chemistry & palatability
# Jeff Oliver
# jcoliver@email.arizona.edu
# 2017-02-22

rm(list = ls())

################################################################################
# SUMMARY
# Create bar plots showing north vs south chemistry, with SE error bars

################################################################################
# SPECIFICS
# Add information unique to this set of charts
data.file <- "data/chemistry-viceroy-data.txt"
output.file <- "output/Viceroy-non-volatile-chemistry-bars"
plots <- data.frame(
  variables = c("Total.Phenolics", 
                "Salicin", 
                "Salicortin", 
                "Tremulacin"),
  plot.titles = c("Total Phenolics", 
                  "Salicin", 
                  "Salicortin", 
                  "Tremulacin"),
  stringsAsFactors = FALSE)
plot.dims <- c(2, 2) # two rows, two columns

################################################################################
# SETUP
# Load dependancies
# Read in data
# Prepare data

plot.data <- read.delim(file = data.file)
