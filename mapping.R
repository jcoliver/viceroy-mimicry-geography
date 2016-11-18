# Graphing data for viceroy paper
# Jeffrey C. Oliver
# jcoliver@email.arizona.edu
# 2016-11-16

rm(list = ls())

################################################################################
# SUMMARY
# Use latitude & longitude coordinates with some continuous variable to create 
# heatmap type image
# See also:
# https://mgimond.github.io/Spatial/interpolation-in-r.html
# https://en.wikipedia.org/wiki/Inverse_distance_weighting
# http://www.geo.ut.ee/aasa/LOOM02331/R_idw_interpolation.html
# http://people.oregonstate.edu/~knausb/R_group/maps_idw.r

################################################################################
# SETUP
# For ubuntu, a number of additional packages may need to be installed:
# sudo apt-get install gfortran
# sudo apt-get install liblapack-dev liblapack3
# sudo apt-get install libopenblas-base libopenblas-dev
# sudo apt-get install libgdal1-dev libproj-dev

# install.packages("gstat")
# install.packages("raster")
# install.packages("sp")
# install.packages("rgdal")
library("gstat") # For IDW
library("raster") # To convert IDW to raster format
library("sp") # To set spatial coordinates
library("rgdal") # For reading in shapefile of states

# Read data with latitude, longitude, and whatever variable(s) to graph
all.data <- read.delim(file = "data/test-data.txt")

# Create a subset of the data with only three columns, 
# which MUST be named x, y, z
viceroy.data <- data.frame(x = all.data$longitude, 
                           y = all.data$latitude, 
                           z = all.data$viceroy)

# Convert data to SpatialPointsDataFrame
coordinates(object = viceroy.data) <- ~x+y

# Resolution of heatmap
num.pixels <- 500

# Grid based roughly on the extent of Florida
# Florida shapefile extent:
# x -87.62571 -80.05091
# y  24.95638  31.00316

map.grid <- expand.grid(x = seq(from = -87, 
                                to = -80, 
                                length.out = num.pixels),
                        y = seq(from = 24, 
                                to = 31, 
                                length.out = num.pixels))

grid.points <- SpatialPixels(SpatialPoints((map.grid)))
spatial.grid <- as(grid.points, "SpatialGrid")

viceroy.idw <- idw(formula = z ~ 1, 
                   locations = viceroy.data, 
                   newdata = spatial.grid, 
                   idp = 2)


# states shapefile from:
# https://www.arcgis.com/home/item.html?id=f7f805eb65eb4ab787a0a3e1116ca7e5
# all contents unzipped & placed in data/shapefiles
states.shp <- readOGR(dsn = "data/shapefiles", layer = "states")
florida.shp <- states.shp[states.shp@data$STATE_NAME == "Florida", ]
viceroy.raster <- raster(x = viceroy.idw)

# Crop & mask the IDW to the shape of Florida
viceroy.cropped <- crop(viceroy.raster, extent(florida.shp))
viceroy.masked <- mask(viceroy.cropped, florida.shp)

# Create the plot
plot(viceroy.masked, 
     col = rev(heat.colors(n = 50)), # reversing the color vector so red = high
     xaxt = "n",
     yaxt = "n", 
     bty = "n",
     main = "Viceroy relative abundance")
# Add sampling locations to plot
points(x = viceroy.data$x,
       y = viceroy.data$y,
       pch = 19,
       cex = 0.6)
