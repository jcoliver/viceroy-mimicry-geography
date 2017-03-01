# Two-panel plot (map + boxplot)
# Jeffrey C. Oliver
# jcoliver@email.arizona.edu
# 2017-02-28

rm(list = ls())
source(file = "functions/mapping-functions.R")
source(file = "plotting-globals.R")

################################################################################
# SUMMARY
# Creates two plots, a map on the left and a boxplot on the right

data.file <- "data/abundance-data.txt"

# Read in data
# Read data with latitude, longitude, and whatever variable(s) to graph
plot.data <- read.delim(file = data.file)
output.file <- "output/Abundance-two-panel"
variable.name <- "Number.Viceroy.Adults"
variable.text <- "Viceroy Adults"
map.shade.colors <- plotting.globals$map.colors
map.point.colors <- "black"

par(mfrow = c(1, 2))
MakeFloridaMap(plot.data = plot.data,
               variable.name = variable.name,
               variable.text = variable.text,
               map.shade.colors = map.shade.colors)

north.values <- plot.data[plot.data$Site.Name %in% plotting.globals$north.pops, variable.name]
south.values <- plot.data[plot.data$Site.Name %in% plotting.globals$south.pops, variable.name]

boxplot.data <- data.frame(group = c(rep(x = "north", times = length(north.values)), rep(x = "south", times = length(south.values))),
                           values = c(north.values, south.values))

boxplot(boxplot.data$values ~ boxplot.data$group)

par(mfrow = c(1, 1))


################################################################################
# BELOW HERE LIES FAILED ATTEMPT AT COMBINING BASE GRAPHICS WITH GGPLOT
# IT DID NOT GO WELL

# Using the gridBase package
library("grid")
library("ggplot2")
library("gridBase")

# Setup
plot.new()
#grid.newpage()
pushViewport(viewport(layout = grid.layout(1, 2)))

# Map
pushViewport(viewport(layout.pos.col = 1))
#par(fig = gridFIG(), new = TRUE)
par(omi=gridOMI()) # not likely right
MakeFloridaMap(plot.data = plot.data,
               variable.name = variable.name,
               variable.text = variable.text,
               map.shade.colors = map.shade.colors)
popViewport()

# Boxplot
pushViewport(viewport(layout.pos.col = 2)) # ERRORS here
box.plot <- MakeBoxplot(boxplot.data = boxplot.data,
            y.axis.label = variable.text)
print(box.plot, newpage = FALSE)
popViewport()
