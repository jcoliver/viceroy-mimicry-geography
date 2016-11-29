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
abundance.data <- read.delim(file = "data/abundance-data.txt")

# Create a subset of the data with only three columns, 
# which MUST be named x, y, z

coord.data <- data.frame(x = abundance.data$Longitude,
                         y = abundance.data$Latitude)


viceroy.data <- data.frame(coord.data,
                           z = abundance.data$Number.Viceroy.Adults / (abundance.data$Number.Queen.Adults + abundance.data$Number.Viceroy.Adults))

queen.data <- data.frame(coord.data, 
                         z = abundance.data$Number.Queen.Adults / (abundance.data$Number.Queen.Adults + abundance.data$Number.Viceroy.Adults))

max.twinevine <- max(abundance.data$Number.Twinevine.Plants)

twinevine.data <- data.frame(coord.data, 
                             z = abundance.data$Number.Twinevine.Plants/max.twinevine)

# Convert data to SpatialPointsDataFrame
coordinates(object = viceroy.data) <- ~x+y
coordinates(object = queen.data) <- ~x+y
coordinates(object = twinevine.data) <- ~x+y

# Resolution of heatmap
num.pixels <- 500

# Grid based roughly on the extent of Florida
# Florida shapefile extent:
# x -87.62571 -80.05091
# y  24.95638  31.00316
# Update: Don't need panhandle, so western extent is -84

map.grid <- expand.grid(x = seq(from = -84, 
                                to = -80, 
                                length.out = num.pixels),
                        y = seq(from = 24, 
                                to = 31, 
                                length.out = num.pixels))

grid.points <- SpatialPixels(SpatialPoints((map.grid)))
spatial.grid <- as(grid.points, "SpatialGrid")

num.permutations <- 2
viceroy.idw <- idw(formula = z ~ 1, 
                   locations = viceroy.data, 
                   newdata = spatial.grid, 
                   idp = num.permutations)

queen.idw <- idw(formula = z ~ 1,
                 locations = queen.data,
                 newdata = spatial.grid,
                 idp = num.permutations)

twinevine.idw <- idw(formula = z ~ 1,
                 locations = twinevine.data,
                 newdata = spatial.grid,
                 idp = num.permutations)

# states shapefile from:
# https://www.arcgis.com/home/item.html?id=f7f805eb65eb4ab787a0a3e1116ca7e5
# all contents unzipped & placed in data/shapefiles
states.shp <- readOGR(dsn = "data/shapefiles", layer = "states")
florida.shp <- states.shp[states.shp@data$STATE_NAME == "Florida", ]

viceroy.raster <- raster(x = viceroy.idw)
queen.raster <- raster(x = queen.idw)
twinevine.raster <- raster(x = twinevine.idw)

# Crop & mask the IDW to the shape of Florida
viceroy.cropped <- crop(x = viceroy.raster, y = extent(florida.shp))
viceroy.masked <- mask(x = viceroy.cropped, mask = florida.shp)

queen.cropped <- crop(x = queen.raster, y = extent(florida.shp))
queen.masked <- mask(x = queen.cropped, mask = florida.shp)

twinevine.cropped <- crop(x = twinevine.raster, y = extent(florida.shp))
twinevine.masked <- mask(x = twinevine.cropped, mask = florida.shp)

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

plot(queen.masked, 
     col = rev(heat.colors(n = 50)), # reversing the color vector so red = high
     xaxt = "n",
     yaxt = "n", 
     bty = "n",
     main = "Queen relative abundance")
# Add sampling locations to plot
points(x = queen.data$x,
       y = queen.data$y,
       pch = 19,
       cex = 0.6)

plot(twinevine.masked, 
     col = rev(heat.colors(n = 50)), # reversing the color vector so red = high
     xaxt = "n",
     yaxt = "n", 
     bty = "n",
     main = "Twinevine scaled abundance")
# Add sampling locations to plot
points(x = twinevine.data$x,
       y = twinevine.data$y,
       pch = 19,
       cex = 0.6)

