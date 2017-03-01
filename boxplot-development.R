# Development of bar charts for chemistry & palatability
# Jeff Oliver
# jcoliver@email.arizona.edu
# 2017-02-22

rm(list = ls())
source(file = "barcharts-globals.R")

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

north.values <- plot.data[plot.data$Site.Name %in% boxplot.globals$north.pops, plots$variables[1]]
south.values <- plot.data[plot.data$Site.Name %in% boxplot.globals$south.pops, plots$variables[1]]

boxplot.data <- data.frame(group = c(rep(x = "north", times = length(north.values)), rep(x = "south", times = length(south.values))),
                           values = c(north.values, south.values))

boxplot(barplot.data$values ~ barplot.data$group,
        border = c("#444444", "black"),
        col = c("black", "#444444"))

library("ggplot2")
pdf(file = "~/Desktop/total-phenolics-viceroys.pdf", useDingbats = FALSE)
box.plot <- ggplot(data = barplot.data, 
                   aes(x = group, y = values, fill = group)) +
  geom_boxplot() + 
  scale_fill_manual(values = c("white", "black")) +
  labs(y = plots$plot.titles[1]) + 
  theme(axis.title.x = element_blank(), # no title on x
        axis.ticks.x = element_blank(), # no label on x
        legend.position = "none") # no legend
box.plot
dev.off()
