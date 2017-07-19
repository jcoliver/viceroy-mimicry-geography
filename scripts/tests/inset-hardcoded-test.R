# Hard-coding map + inset boxplot
# Jeffrey C. Oliver
# jcoliver@email.arizona.edu
# 2017-07-19

rm(list = ls())
source(file = "scripts/visualization/plotting-globals.R")
source(file = "functions/mapping-functions.R")
source(file = "functions/boxplot-functions.R")

################################################################################
datafile <- "data/palatability-data.txt"
outputfile <- "output/visualization/Palatability-two-panel"
variable.name <- "Mantid.Learning"
variable.text <- "Mantid Learning (# Trials)"
delim <- "\t"

plot.data <- read.table(file = datafile, header = TRUE, sep = delim)

# Prep output file name
file.format <- "pdf" # plotting.globals$output.format
output.filename <- paste0(outputfile, ".", file.format)

# Open pipe to appropriate graphics device
if (file.format == "pdf") {
  pdf(file = output.filename, useDingbats = FALSE)
} else if (file.format == "png") {
  png(filename = output.filename, width = 1200, height = 1200, units = "px", res = 150)
}

par(fig = c(0, 1, 0, 1))
par(new = FALSE)
par(fig = c(0, 0.8, 0, 0.8), cex = 1)

################################################################################
# MakeFloridaMap starts here
map.shade.colors <- plotting.globals$map.colors
map.point.outline <- plotting.globals$map.point.outline
map.point.cex <- plotting.globals$map.point.cex
groups <- plotting.globals$groups
group.cols <- plotting.globals$group.cols
color.by <- "Site.Name"

if(!require("rgdal")) {
  stop("MakeFloridaMap requires the rgdal package; processing stopped.")
}

# Read in shapefile for subsequent masking and pull out Florida
states.shp <- readOGR(dsn = "data/shapefiles", layer = "states")
florida.shp <- states.shp[states.shp@data$STATE_NAME == "Florida", ]

# Set the limit of IDW mapping, here it is approximately the peninsula of 
# Florida
long.limits <- c(-84, -80)
lat.limits <- c(24, 31)

# First a data frame with latitude and longitude coordinates of sites
coord.data <- data.frame(x = plot.data$Longitude,
                         y = plot.data$Latitude)

# Create three-column data frame
current.xyz <- data.frame(coord.data,
                          z = plot.data[, variable.name])

# Run inverse-distance weighting to get values for map; the coarseness and point 
# influence can be changed by using values other than defaults for num.pixels 
# and num.permutations parameters
current.idw <- GeografyData(xyzdata = current.xyz, xlim = long.limits, ylim = lat.limits)

# Convert the IDW data to raster format, and restrict to geographic boundaries 
# (i.e. the shoreline) of Florida
current.raster <- RasterAndReshape(idw.data = current.idw, shape = florida.shp)

# Need to update map.point.bg with group membership
map.point.bg <- rep(x = group.cols[1], times = nrow(x = plot.data))
for (one.group in 2:length(groups)) {
  map.point.bg[plot.data[, color.by] %in% groups[[one.group]]] <- group.cols[one.group]
}

################################################################################
# PlotMap starts here
# Draw the plot
geo.data <- current.raster
point.data <- current.xyz
legend.label <- variable.text
col.palette <- map.shade.colors
point.col <- map.point.outline
point.bg <- map.point.bg
point.cex <- map.point.cex
# Defaults
main.title <- ""
legend.label <- ""
legend.label.cex <- 0.8
point.pch <- 21

# Plotting map ok, as long as we don't mess around with 
# par et al.

# Try making a map in the area 0, 0.8, 0, 0.8
# Then adding a dummy x,y to top right
# attempts to add par(add ...) or par(fig ...) to 
# points call fail (error in plot.xy)
# trying plot instead of points also fails

par(fig = c(0,1,0,1))
par(new = FALSE)
par(fig = c(0, 0.8, 0, 0.8))

# A new plot object, sans legend
plot(geo.data,
     col = col.palette,
     xaxt = "n",
     yaxt = "n",
     bty = "n",
     main = main.title,
     box = FALSE,
     legend = FALSE)
# Now just add legend
# plot(geo.data,
#      smallplot = c(0.18, 0.21, 0.2, .6),
#      legend.only = TRUE,
#      col = col.palette,
#      bty = "n",
#      box = FALSE,
#      ylab = NULL,
#      legend.args = list(text = legend.label, side = 2, cex = legend.label.cex))
# Add points
# points(x = point.data$x,
#        y = point.data$y,
#        col = point.col,
#        bg = point.bg,
#        pch = point.pch,
#        cex = point.cex)
par(new = TRUE)
# FAIL, just draws a completely separat x-y plot
plot(x = point.data$x,
     y = point.data$y,
     col = point.col,
     bg = point.bg,
     pch = point.pch,
     cex = point.cex)

# Dummy x ~ y
par(new = TRUE)
par(fig = c(0.5, 1.0, 0.4, 1.0), cex = 0.8)
plot(1:10, 1:10)


# PlotMap ends here
################################################################################

# MakeFloridaMap ends here
################################################################################

# Boxplot
par(new = TRUE)
par(fig = c(0.5, 1.0, 0.4, 1.0), cex = 0.8)

group.by <- "Site.Name"

################################################################################
# MakeBoxplot starts here
grouping.var = group.by
col.middle.bar = plotting.globals$group.alt.cols
col.boxes = plotting.globals$group.cols
xlabs = factor(x = names(plotting.globals$groups))
groups = plotting.globals$groups

group.name <- "group"

boxplot.data <- BoxplotData (plot.data = plot.data,
                             group.name = group.name,
                             grouping.var = grouping.var,
                             variable.name = variable.name,
                             groups = groups)

# Initial plotting area, so we can draw a grey background and overlay boxplot on top
boxplot(boxplot.data[, variable.name] ~ boxplot.data[, group.name],
        frame = FALSE,
        axes = FALSE)

# Grey rectangle
rect(par("usr")[1], par("usr")[3], par("usr")[2], par("usr")[4], col =
       "#DDDDDD", border = NA)

# Plot data for real
boxplot(boxplot.data[, variable.name] ~ boxplot.data[, group.name], 
        add = TRUE,
        ylab = "",
        yaxt = "n",
        xaxt = "n",
        medcol = col.middle.bar, # Color of middle bar
        col = col.boxes, # Fill color of boxes
        frame = FALSE,
        las = 1)

# x-axis labels, no tick-marks
axis(side = 1, las = 1, lwd = 0, line = -0.5,
     at = seq(1:length(xlabs)), 
     labels = xlabs)

# y-axis labels, with horizontal values
axis(side = 2, las = 1)

# y-axis title, setting line for better alignment
title(ylab = variable.text, line = 2)

# MakeBoxplot ends here
################################################################################

# Reset graphical parameters to default values
#  par(mfrow = c(1, 1), mar = c(5, 4, 4, 2) + 0.1, fig = c(0, 1, 0, 1))
par(fig = c(0, 1, 0, 1))
#  par(defaultpar)

# Close pipe to graphics device
dev.off()
