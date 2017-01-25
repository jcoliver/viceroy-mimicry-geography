# INSERT CODE DESCRIPTION
# Jeff Oliver
# jcoliver@email.arizona.edu
# 2016-12-05

rm(list = ls())

################################################################################
# SUMMARY
# Use latitude & longitude coordinates to create maps of chemical defense in 
# willows (non-volatile phenolics)

# Total.Phenolics
# Salicin
# Salicortin
# Tremulacin

################################################################################
# SPECIFICS
# Add information unique to this set of maps
data.file <- "data/chemistry-willow-data.txt"
output.file <- "output/Willow-chemistry-maps.pdf"
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

# Open pipe to pdf
pdf(file = output.file, useDingbats = FALSE)

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
  
  # Draw the plot
  PlotMap(geo.data = current.raster, point.data = current.xyz, main.title = plots$plot.titles[d])
}
par(mfrow = c(1, 1))
dev.off()
