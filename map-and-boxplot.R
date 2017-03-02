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
output.file <- "output/Volatiles-two-panel"
vars <- data.frame(var.name <- c("Total.Volatiles",
                                 "Salicylaldehyde",
                                 "Benzaldehyde"),
                   var.text <- c("Total Volatiles (units)",
                                 "Salicylaldehyde (units)",
                                 "Benzaldehyde (units)"),
                   stringsAsFactors = FALSE)

# Read in data
# Read data with latitude, longitude, and whatever variable(s) to graph
plot.data <- read.delim(file = data.file)

# Set color values for graphics
map.point.colors <- "black"
point.fill <- rep(x = "black", times = nrow(x = plot.data))
point.fill[plot.data$Site.Name %in% plotting.globals$north.pops] <- "white"

# Prep output file name
file.format <- plotting.globals$output.format
output.file <- paste0(output.file, ".", file.format)

# Send plot to appropriate formatter
if (file.format == "pdf") {
  pdf(file = output.file, useDingbats = FALSE)
} else if (file.format == "png") {
  png(filename = output.file, width = 1200, height = 1200, units = "px", res = 150)
}

par(mfrow = c(nrow(vars), 2))

for (variable in 1:nrow(vars)) {

  variable.name <- vars$var.name[variable]
  variable.text <- vars$var.text[variable]
  # Map
  par(mar = c(0, 0, 0, 0))
  
  MakeFloridaMap(plot.data = plot.data,
                 variable.name = variable.name,
                 variable.text = variable.text,
                 map.shade.colors = plotting.globals$map.colors,
                 map.point.colors = map.point.colors,
                 map.point.bg = point.fill)
  
  north.values <- plot.data[plot.data$Site.Name %in% plotting.globals$north.pops, variable.name]
  south.values <- plot.data[plot.data$Site.Name %in% plotting.globals$south.pops, variable.name]
  
  # Boxplot
  par(mar = c(1.5, 3, 1, 1))
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
  
}

par(mfrow = c(1, 1), mar = c(5, 4, 4, 2) + 0.1)

dev.off()

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
