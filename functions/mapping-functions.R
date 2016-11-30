# Functions for heatmap maps with inverse distance weighting
# Jeff Oliver
# jcoliver@email.arizona.edu
# 2016-11-29

################################################################################
GeographyData <- function(xyzdata, xlim = numeric(2L), ylim = numeric(2L), 
                          num.pixels = 500, num.permutations = 2) {
  if (!require("sp")) {
    stop("GeographyData requires the sp package; processing stopped.")
  }
  
  if (xlim[1] > xlim[2]) {
    stop("xlim (Latitude) limits out of order; xlim[1] < xlim[2] required.")
  }

  if (ylim[1] > ylim[2]) {
    stop("ylim (Longitude) limits out of order; ylim[1] < ylim[2] required.")
  }
  
  # Convert data to SpatialPointsDataFrame
  coordinates(object = xyxdata) <- ~x+y
  
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
PlotMap <- function(geo.data, main.title = "", 
                    col.palette = rev(heat.colors(n = 50)), point.pch = 19,
                    point.col = "black", point.cex = 0.6) {
  plot(geo.data,
       col = col.palette,
       xaxt = "n",
       yaxt = "n",
       bty = "n",
       main = main.title)

  points(x = geo.data$x,
         y = geo.data$y,
         col = point.col,
         pch = point.pch,
         cex = point.cex)
}