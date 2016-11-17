# Graphing data for viceroy paper
# Jeffrey C. Oliver
# jcoliver@email.arizona.edu
# 2016-11-16

rm(list = ls())

# install.packages("gstat")
# install.packages("sp")
# install.packages("raster")
library("gstat")
library("sp")
library("raster")
all.data <- read.delim(file = "data/test-data.txt")

# Create a subset of the data with only three columns, which MUST be named x, y, z
viceroy.data <- data.frame(x = all.data$longitude, 
                           y = all.data$latitude, 
                           z = all.data$viceroy)

# Convert data to SpatialPointsDataFrame
coordinates(object = viceroy.data) <- ~x+y

num.pixels <- 500
map.grid <- expand.grid(x = seq(from = floor(min(coordinates(viceroy.data)[, 1])),
                                to = ceiling(max(coordinates(viceroy.data)[, 1])),
                                length.out = num.pixels),
                        y = seq(from = floor(min(coordinates(viceroy.data)[, 2])),
                                to = ceiling(max(coordinates(viceroy.data)[, 2])),
                                length.out = num.pixels))

grid.points <- SpatialPixels(SpatialPoints((map.grid)))
spatial.grid <- as(grid.points, "SpatialGrid")

viceroy.idw <- idw(formula = z ~ 1, 
                   locations = viceroy.data, 
                   newdata = spatial.grid, 
                   idp = 2)

spplot(viceroy.idw["var1.pred"])
plot(viceroy.idw)

viceroy.raster <- raster(x = viceroy.idw)
plot(viceroy.raster, 
     ylim = c(26, 30))

##### ##### ##### ##### #####
# IDW interpolation.

geog2.idw <- idw(z ~ 1, geog2, grd, idp=6)

spplot(geog2.idw["var1.pred"])



# See:
# https://mgimond.github.io/Spatial/interpolation-in-r.html
# https://en.wikipedia.org/wiki/Inverse_distance_weighting
# http://www.geo.ut.ee/aasa/LOOM02331/R_idw_interpolation.html
# http://people.oregonstate.edu/~knausb/R_group/maps_idw.r
# https://cran.r-project.org/web/packages/gstat/gstat.pdf

# For ubuntu 
# sudo apt-get install gfortran
# sudo apt-get install liblapack-dev liblapack3 libopenblas-base libopenblas-dev

# from http://people.oregonstate.edu/~knausb/R_group/maps_idw.r
# also need library("sp")

# Maps and Inverse Distance Weighted
# interpolation in R.
#
# Brian J. Knaus
# 6-2-2008
##### ##### ##### ##### #####
# Generate data.
set.seed(1)
x <- runif(40, -123, -110)
set.seed(2)
y <- runif(40, 40, 48)
set.seed(3)
z <- runif(40, 0, 1)
#
geog <- data.frame(x,y,z)

##### ##### ##### ##### #####
# Create a map.

library(maps)

map("state", lwd=1)
map("county", lty=3, lwd=0.5, add=T)
#
points(x, y)
#

##### ##### ##### ##### #####
# Zoom in.

par(mar=c(0,4,0,0))
#
map("state", lwd=1, xlim=c(-125, -105), ylim=c(38, 50))
map("county", lty=3, lwd=0.5, add=T)
#
points(x, y, pch=21, bg=c(1:4))
#
axis(side=1)
axis(side=2)

##### ##### ##### ##### #####
# Projected maps.
#
library(mapproj)

map("state", proj='albers', param=c(35,45), lwd=1,
    xlim=c(-125, -105), ylim=c(38, 50))
map("county", proj='albers', param=c(35,45), lty=3, lwd=0.5,
    xlim=c(-125, -105), ylim=c(38, 50), add=T)
#
points(mapproject(geog), pch=21, bg=c(1:4))

##### ##### ##### ##### #####
# Create spatial data.frame.

library(gstat)

# Create spatial data.frame.
geog2 <- data.frame(x,y,z)
# Just in case you didn't name your colums
# names(geog2)[1:2] <- c("x", "y")
#
# Assigning coordinates results in spdataframe.
coordinates(geog2) <- ~x+y
summary(geog2)

# Create a grid.
#
pixels <- 100
#
geog.grd <- expand.grid(x=seq(floor(min(coordinates(geog2)[,1])),
                              ceiling(max(coordinates(geog2)[,1])),
                              length.out=pixels),
                        y=seq(floor(min(coordinates(geog2)[,2])),
                              ceiling(max(coordinates(geog2)[,2])),
                              length.out=pixels))
#
grd.pts <- SpatialPixels(SpatialPoints((geog.grd)))
grd <- as(grd.pts, "SpatialGrid")

# Explore the data structure.
summary(grd)

spplot(geog2)

##### ##### ##### ##### #####
# IDW interpolation.

geog2.idw <- idw(z ~ 1, geog2, grd, idp=6)

spplot(geog2.idw["var1.pred"])

class(geog2.idw)

names(geog2.idw)

summary(geog2.idw)

##### ##### ##### ##### #####
# Image.

par(mar=c(2,2,1,1))
#
image(geog2.idw, xlim=c(-125, -110), ylim=c(40, 47))
#
contour(geog2.idw, add=T, lwd=0.5)
#
map("state", lwd=1, add=T)
map("county", lty=3, lwd=0.5, add=T)
#
points(x, y, pch=21, bg=c(1:4))
#
axis(side=1)
axis(side=2)