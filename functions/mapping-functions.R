# Functions for heatmap maps with inverse distance weighting
# Jeff Oliver
# jcoliver@email.arizona.edu
# 2016-11-29

################################################################################
GeografyData <- function(xyzdata, xlim = numeric(2L), ylim = numeric(2L), 
                          num.pixels = 500, num.permutations = 2) {
  if (!require("sp")) {
    stop("GeografyData requires the sp package; processing stopped.")
  }
  
  if (!require("gstat")) {
    stop("GeografyData requires the gstat package; processing stopped.")
  }
  
  if (xlim[1] > xlim[2]) {
    stop("xlim (Latitude) limits out of order; xlim[1] < xlim[2] required.")
  }

  if (ylim[1] > ylim[2]) {
    stop("ylim (Longitude) limits out of order; ylim[1] < ylim[2] required.")
  }
  
  # Convert data to SpatialPointsDataFrame
  coordinates(object = xyzdata) <- ~x+y
  
  map.grid <- expand.grid(x = seq(from = xlim[1], 
                                  to = xlim[2], 
                                  length.out = num.pixels),
                          y = seq(from = ylim[1], 
                                  to = ylim[2], 
                                  length.out = num.pixels))
  
  grid.points <- SpatialPixels(SpatialPoints((map.grid)))
  spatial.grid <- as(grid.points, "SpatialGrid")
  
  idw.obj <- idw(formula = z ~ 1,
                 locations = xyzdata,
                 newdata = spatial.grid,
                 idp = num.permutations)
  
  return(idw.obj)
}

################################################################################
RasterAndReshape <- function(idw.data, shape) {
  if(!require("raster")) {
    stop("RasterAndReshape requires the raster package; processing stopped.")
  }
  
  raster.data <- raster(x = idw.data)
  
  cropped.data <- crop(x = raster.data, y = extent(shape))
  
  masked.data <- mask(x = cropped.data, mask = shape)
  
  return(masked.data)
}

################################################################################
PlotMap <- function(geo.data, point.data, main.title = "", legend.label = "",
                    legend.label.cex = 0.8,
                    col.palette = rev(heat.colors(n = 50)), point.pch = 21,
                    point.col = "black", point.cex = 0.9, point.bg = "black") {
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
  plot(geo.data,
       smallplot = c(0.18, 0.2, 0.2, .6),
       legend.only = TRUE,
       col = col.palette,
       bty = "n",
       box = FALSE,
       ylab = NULL,
       legend.args = list(text = legend.label, side = 2, cex = legend.label.cex))
  # Add points
  points(x = point.data$x,
         y = point.data$y,
         col = point.col,
         bg = point.bg,
         pch = point.pch,
         cex = point.cex)
}

################################################################################
MakeFloridaMap <- function(plot.data, variable.name, variable.text,
                           map.shade.colors, map.point.outline = "black",
                           map.point.bg = "black", map.point.cex = 0.8) {
  #' What is needed to draw a single map?
  #' + Input (data) file name
  #' + Variable to plot (column name)
  #' + Variable name & scale for axis
  #' + Colors
  #'   + Map shading
  #'   + Points
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
  
  # Draw the plot
  PlotMap(geo.data = current.raster, 
          point.data = current.xyz, 
          legend.label = variable.text,
          col.palette = map.shade.colors,
          point.col = map.point.outline,
          point.bg = map.point.bg,
          point.cex = map.point.cex)
  #  return(map.plot)
}
