# Four panel plot of insect and host plant abundances
# Jeffrey C. Oliver
# jcoliver@email.arizona.edu
# 2017-03-07

rm(list = ls())

################################################################################
# SUMMARY
# Creates abundance maps for insects (viceroys & queens) and their respective 
# host plants (willows & twinevine); insects as ~rows, plants as columns:
# | Viceroy | Willow    |
# | Queen   | Twinevine |
# Used svg graphics device, as pdf masking of maps was not working well when 
# translating pdf -> svg -> pdf

################################################################################
# SPECIFICS
# Add information unique to this set of figures
data.file <- "data/abundance-data.txt"
output.file <- "output/visualization/Abundance-map-only"
vars <- data.frame(var.name <- c("Number.Viceroy.Adults", 
                                 "Number.Carolina.Willow.Plants", 
                                 "Number.Queen.Adults", 
                                 "Number.Twinevine.Plants"),
                   var.text <- c("Viceroys (# inds.)", 
                                 "Willows (# inds.)", 
                                 "Queens (# inds.)", 
                                 "Twinevines (# inds.)"),
                   stringsAsFactors = FALSE)
separate.files <- FALSE
multi.panel.dims <- c(2,2)
file.format <- "svg"

################################################################################
# SHOULD NOT NEED TO EDIT ANYTHING BELOW HERE
################################################################################

################################################################################
# PLOT
source(file = "functions/mapping-functions.R")
source(file = "scripts/visualization/plotting-globals.R")
# If plotting to separate files:
#   Loop over each variable
#   Call MakeFloridaMap
# If all plots going to a single file:
#   Load source files
#   Read in data
#   Prepare data
#   Set file format
#   Setup multi-panel plot dimensions
#   Loop over each variable to plot
#     Draw map

plot.data <- read.table(file = data.file, header = TRUE, sep = "\t")

if (separate.files) {
  
  for (variable in 1:nrow(vars)) {
    outfile <- paste0(output.file, "-", vars$var.name[variable], ".", file.format)

    # Set file format
    if (file.format == "pdf") {
      pdf(file = outfile, useDingbats = FALSE)
    } else if (file.format == "png") {
      png(filename = outfile, width = 1200, height = 1200, units = "px", res = 150)
    } else if (file.format == "svg") {
      svg(filename = outfile)
    }

    MakeFloridaMap(plot.data = plot.data,
                   variable.name = vars$var.name[variable],
                   variable.text = vars$var.text[variable],
                   map.shade.colors = plotting.globals$map.colors,
                   map.point.outline = plotting.globals$map.point.outline,
                   map.point.cex = plotting.globals$map.point.cex,
                   groups = plotting.globals$groups,
                   group.cols = plotting.globals$group.cols)
    
    # Close pipe to graphics device
    dev.off()
  }
  
} else {
  # Load dependancies
  source(file = "scripts/visualization/plotting-globals.R")
  
  # Read data with latitude, longitude, and whatever variable(s) to graph
  plot.data <- read.delim(file = data.file)
  
  # Prep output file name
  output.file <- paste0(output.file, ".", file.format)
  
  # Set file format
  if (file.format == "pdf") {
    pdf(file = output.file, useDingbats = FALSE)
  } else if (file.format == "png") {
    png(filename = output.file, width = 1200, height = 1200, units = "px", res = 150)
  } else if (file.format == "svg") {
    svg(filename = output.file)
  }
  
  # Setup multi-panel plot dimensions
  par(mfrow = multi.panel.dims)
  
  # Loop over each variable to plot
  for (variable in 1:nrow(vars)) {
    variable.name <- vars$var.name[variable]
    variable.text <- vars$var.text[variable]
    
    # Map
    par(mar = c(0, 0, 0, 0))
    
    MakeFloridaMap(plot.data = plot.data,
                   variable.name = variable.name,
                   variable.text = variable.text,
                   map.shade.colors = plotting.globals$map.colors,
                   map.point.outline = plotting.globals$map.point.outline,
                   map.point.cex = plotting.globals$map.point.cex,
                   groups = plotting.globals$groups,
                   group.cols = plotting.globals$group.cols)

  }
  
  # Reset graphical parameters to default values
  par(mfrow = c(1, 1), mar = c(5, 4, 4, 2) + 0.1)
  # par(mfrow = c(1,1))
  
  # Close pipe to graphics device
  dev.off()
}
