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

data.file <- "data/chemistry-viceroy-data.txt"

# Read in data
# Read data with latitude, longitude, and whatever variable(s) to graph
plot.data <- read.delim(file = data.file)
output.file <- "output/Abundance-two-panel"
variable.name <- "Total.Volatiles"
variable.text <- "Total Volatiles (units)"
map.point.colors <- "black"

par(mfrow = c(2, 2))
# map.data <- ddply(.data = plot.data,
#                   .variables = "Site.Name",
#                   .fun = function(x) mean(x[, variable.name]))


par(mar = c(0, 0, 0, 0))
point.fill <- rep(x = "black", times = nrow(x = plot.data))
point.fill[plot.data$Site.Name %in% plotting.globals$north.pops] <- "white"

MakeFloridaMap(plot.data = plot.data,
               variable.name = variable.name,
               variable.text = variable.text,
               map.shade.colors = plotting.globals$map.colors,
               map.point.colors = map.point.colors,
               map.point.bg = point.fill)

north.values <- plot.data[plot.data$Site.Name %in% plotting.globals$north.pops, variable.name]
south.values <- plot.data[plot.data$Site.Name %in% plotting.globals$south.pops, variable.name]

par(mar = c(1, 3, 1, 1))
boxplot.data <- data.frame(group = c(rep(x = "North", times = length(north.values)), rep(x = "South", times = length(south.values))),
                           values = c(north.values, south.values))

boxplot(boxplot.data$values ~ boxplot.data$group, 
        frame = FALSE,
        axes = FALSE)
rect(par("usr")[1], par("usr")[3], par("usr")[2], par("usr")[4], col = 
       "#DDDDDD", border = NA)
boxplot(boxplot.data$values ~ boxplot.data$group, 
        add = TRUE,
        ylab = "",
        yaxt = "n",
        xaxt = "n",
        bg = c("#666666"),
        medcol = c("black", "white"),
        col = c("white", "black"), 
        frame = FALSE,
        las = 1)
axis(side = 1, at = c(1, 2), labels = c("North", "South"), las = 1, lwd = 0, line = -0.5)
axis(side = 2, las = 1)
title(ylab = variable.text, line = 2)

par(mfrow = c(1, 1), mar = c(5, 4, 4, 2) + 0.1)


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
               map.shade.colors = plotting.globals$map.colors)
popViewport()

# Boxplot
pushViewport(viewport(layout.pos.col = 2)) # ERRORS here
box.plot <- MakeBoxplot(boxplot.data = boxplot.data,
            y.axis.label = variable.text)
print(box.plot, newpage = FALSE)
popViewport()
