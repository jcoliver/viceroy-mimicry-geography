# Graphing data for viceroy paper
# Jeffrey C. Oliver
# jcoliver@email.arizona.edu
# 2016-11-16

rm(list = ls())

################################################################################
# SUMMARY
# Use latitude & longitude coordinates to create maps of abundances of viceroys, 
# willow, queens, and twinevine

################################################################################
# SETUP
# Load dependancies
# Read in data
# Prepare data

# Load dependancies
# install.packages("rgdal")
library("rgdal") # For reading in shapefile of states
source(file = "functions/mapping-functions.R")

# Read in data
# Read data with latitude, longitude, and whatever variable(s) to graph
abundance.data <- read.delim(file = "data/abundance-data.txt")

# Read in shapefile for subsequent masking and pull out Florida
states.shp <- readOGR(dsn = "data/shapefiles", layer = "states")
florida.shp <- states.shp[states.shp@data$STATE_NAME == "Florida", ]

# Prepare data
# Create a subset of the data with only three columns, which MUST be 
# named x, y, z

# First a data frame with latitude and longitude coordinates of sites, we can 
# re-use this for each variable we want to graph, as site coordinates are 
# constant
coord.data <- data.frame(x = abundance.data$Longitude,
                         y = abundance.data$Latitude)


# Now create a three-column data frame for each, with the z-column the value to 
# plot
viceroy.data <- data.frame(coord.data,
                           z = abundance.data$Number.Viceroy.Adults)

queen.data <- data.frame(coord.data, 
                         z = abundance.data$Number.Queen.Adults)

twinevine.data <- data.frame(coord.data, 
                             z = abundance.data$Number.Twinevine.Plants)

willow.data <- data.frame(coord.data,
                          z = abundance.data$Number.Carolina.Willow.Plants)

# Here we normalize so min = 0 and max = 1
# viceroy.data <- data.frame(coord.data,
#                            z = NormalizeData(x = abundance.data$Number.Viceroy.Adults))
# 
# queen.data <- data.frame(coord.data, 
#                          z = NormalizeData(x = abundance.data$Number.Queen.Adults))
# 
# twinevine.data <- data.frame(coord.data, 
#                              z = NormalizeData(x = abundance.data$Number.Twinevine.Plants))
# 
# willow.data <- data.frame(coord.data,
#                           z = NormalizeData(x = abundance.data$Number.Carolina.Willow.Plants))

# Set the limit of IDW mapping, here it is approximately the peninsula of 
# Florida
long.limits <- c(-84, -80)
lat.limits <- c(24, 31)

# Run inverse-distance weighting to get values for map; the coarseness and point 
# influence can be changed by using values other than defaults for num.pixels 
# and num.permutations parameters
viceroy.idw <- GeografyData(xyzdata = viceroy.data, xlim = long.limits, ylim = lat.limits)
queen.idw <- GeografyData(xyzdata = queen.data, xlim = long.limits, ylim = lat.limits)
willow.idw <- GeografyData(xyzdata = willow.data, xlim = long.limits, ylim = lat.limits)
twinevine.idw <- GeografyData(xyzdata = twinevine.data, xlim = long.limits, ylim = lat.limits)

# Convert the IDW data to raster format, and restrict to geographic boundaries 
# (i.e. the shoreline) of Florida
viceroy.raster <- RasterAndReshape(idw.data = viceroy.idw, shape = florida.shp)
queen.raster <- RasterAndReshape(idw.data = queen.idw, shape = florida.shp)
willow.raster <- RasterAndReshape(idw.data = willow.idw, shape = florida.shp)
twinevine.raster <- RasterAndReshape(idw.data = twinevine.idw, shape = florida.shp)

# Plot the maps in a 2 x 2 grid
pdf(file = "output/Abundance-maps.pdf", useDingbats = FALSE)
par(mfrow = c(2, 2))
PlotMap(geo.data = viceroy.raster, point.data = viceroy.data, main.title = "Viceroy Abundance")
PlotMap(geo.data = willow.raster, point.data = willow.data, main.title = "Willow Abundance")
PlotMap(geo.data = queen.raster, point.data = queen.data, main.title = "Queen Abundance")
PlotMap(geo.data = twinevine.raster, point.data = twinevine.data, main.title = "Twinevine Abundance")
par(mfrow = c(1, 1))
dev.off()
