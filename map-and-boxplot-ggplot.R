# Map & boxplot approach with ggplot et al.
# Jeffrey C. Oliver
# jcoliver@email.arizona.edu
# 2017-04-12

rm(list = ls())

################################################################################
# See: https://www.r-bloggers.com/creating-inset-map-with-ggplot2/
# And, for IDW in ggplot: http://blog.silviaterra.com/2015/11/creating-your-own-volume-heatmaps.html

library("ggplot2")
library("rgdal")
source(file = "functions/mapping-functions.R")


# Read in shapefile for subsequent masking and pull out Florida
states.shp <- readOGR(dsn = "data/shapefiles", layer = "states")
florida.shp <- states.shp[states.shp@data$STATE_NAME == "Florida", ]

# Set the limit of IDW mapping, here it is approximately the peninsula of 
# Florida
long.limits <- c(-84, -80)
lat.limits <- c(24, 31)

data.file <- "data/chemistry-viceroy-data.txt"
variable.name <- "Total.Volatiles"
plot.data <- read.delim(file = data.file)

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

# Getting IDW into data frame...

# Getting florida shape rasterized
grid <- raster(ncol = 100, nrow = 100)
extent(grid) <- extent(florida.shp)

rp <- rasterize(florida.shp, grid, field = 1)
rastSPDF <- as(rp, "SpatialPixelsDataFrame")
rastDF <- as.data.frame(rastSPDF)

dataSPDF <- as(current.raster, "SpatialPixelsDataFrame")
dataDF <- as.data.frame(dataSPDF)
colnames(dataDF)[which(colnames(dataDF) == "var1.pred")] <- "z"

# Need to update map.point.bg with group membership
group.cols = c("white", "black")
groups <- list(North = c("Jena", "Gainesville", "Cedar Key", "Leesburg"),
               South = c("Cornwell", "Lake Istokpoga", "Lehigh Acres", "Corkscrew"))
color.by = "Site.Name"
map.point.bg <- rep(x = group.cols[1], times = nrow(x = plot.data))
for (one.group in 2:length(groups)) {
  map.point.bg[plot.data[, color.by] %in% groups[[one.group]]] <- group.cols[one.group]
}

map.plot <- ggplot(data = dataDF, aes(x = x, y = y)) +
  geom_tile(aes(fill = z)) + 
  scale_fill_gradient(low = "#F7FBFF", high = "#08306B", guide = "colorbar", name = variable.name) +
  coord_equal() +
  geom_point(data = plot.data[plot.data$Site.Name %in% groups$North, ],
             aes(x = Longitude, y = Latitude), 
             fill = "white", 
             color = "black", 
             shape = 21,
             size = 2) +
  geom_point(data = plot.data[plot.data$Site.Name %in% groups$South, ],
             aes(x = Longitude, y = Latitude), 
             fill = "black", 
             color = "black", 
             shape = 21,
             size = 2) +
  theme_void()

print(map.plot)

ggsave(filename = "output/test-ggplot-map.pdf")


## Raster example
ggplot(data = rastDF, aes(x = x, y = y)) + 
  geom_tile(aes(fill = totSawIDW)) + coord_equal() +
  geom_path(data = standBounds, aes(x = long, 
                                    y = lat)) +
  geom_point(data = plotCoordDF, aes(color = sawVolume__doyle)) + 
  scale_color_gradient(limits = c(0, maxSaw),
                       "Saw Volume (doyle bd ft) per acre") + 
  scale_fill_gradient(limits = c(0, maxSaw),
                      "Saw Volume (doyle bd ft) per acre") +
  theme_nothing(legend = TRUE) +
  ggtitle('Saw volume heatmap predictions from IDW Model')

