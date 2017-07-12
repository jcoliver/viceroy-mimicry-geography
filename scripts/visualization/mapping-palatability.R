# Graphing palatability data for viceroy paper
# Jeff Oliver
# jcoliver@email.arizona.edu
# 2016-12-05

rm(list = ls())
source(file = "scripts/visualization/plotting-globals.R")

################################################################################
# SUMMARY
# Use latitude & longitude coordinates to create maps of palatability in 
# viceroys (aversion learning & memory retention)

# Mantid.Learning
# Mantid.Memory.Retention

################################################################################
# SPECIFICS
# Add information unique to this set of maps
data.file <- "data/palatability-data.txt"
output.file <- "output/visualization/Palatability-maps"
plots <- data.frame(
  variables = c("Mantid.Learning", 
                "Mantid.Memory.Retention"),
  plot.titles = c("Mantid Learning", 
                  "Mantid Memory Retention"),
  stringsAsFactors = FALSE)
plot.dims <- c(2, 2) # two rows, two columns

# Settings from plotting-globals.R
plot.colors <- plotting.globals$map.colors
file.format <- plotting.globals$output.format
output.file <- paste0(output.file, ".", file.format)

################################################################################
# SETUP
# Load dependancies
# Read in data
# Prepare data

# Load dependancies
# install.packages("rgdal")
library("rgdal") # For reading in shapefile of states
source(file = "functions/mapping-functions.R")

# Read in shapefile for subsequent masking and pull out Florida
states.shp <- readOGR(dsn = "data/shapefiles", layer = "states")
florida.shp <- states.shp[states.shp@data$STATE_NAME == "Florida", ]

# Set the limit of IDW mapping, here it is approximately the peninsula of 
# Florida
long.limits <- c(-84, -80)
lat.limits <- c(24, 31)

# Read in data
# Read data with latitude, longitude, and whatever variable(s) to graph
plot.data <- read.delim(file = data.file)

# Prepare data
# Will ultimately need a subset of the data with only three columns, which 
# MUST be named x, y, z

# First a data frame with latitude and longitude coordinates of sites, we can 
# re-use this for each variable we want to graph, as site coordinates are 
# constant
coord.data <- data.frame(x = plot.data$Longitude,
                         y = plot.data$Latitude)

################################################################################
# PLOT
# Loop over each data object, transforming as necessary and adding to multi-
# figure plot

# Send plot to appropriate formatter
if (file.format == "pdf") {
  pdf(file = output.file, useDingbats = FALSE)
} else if (file.format == "png") {
  png(filename = output.file, width = 1200, height = 1200, units = "px", res = 150)
}

# Setup desired dimensions
par(mfrow = plot.dims)

# Loop over data
for (d in 1:nrow(plots)) {
  # Create three-column data frame
  current.xyz <- data.frame(coord.data,
                            z = plot.data[, plots$variables[d]])
  # Run inverse-distance weighting to get values for map; the coarseness and point 
  # influence can be changed by using values other than defaults for num.pixels 
  # and num.permutations parameters
  current.idw <- GeografyData(xyzdata = current.xyz, xlim = long.limits, ylim = lat.limits)
  
  # Convert the IDW data to raster format, and restrict to geographic boundaries 
  # (i.e. the shoreline) of Florida
  current.raster <- RasterAndReshape(idw.data = current.idw, shape = florida.shp)
  
  # For learning (and learning only), we want to reverse the colors
  this.plot.colors <- plot.colors
  if (plots$variables[d] == "Mantid.Learning") {
    this.plot.colors <- rev(plot.colors)
  }
  
  # Draw the plot
  PlotMap(geo.data = current.raster, 
          point.data = current.xyz, 
          main.title = plots$plot.titles[d],
          col.palette = this.plot.colors)
}
par(mfrow = c(1, 1))
dev.off()
