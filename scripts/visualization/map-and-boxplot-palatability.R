# Two-panel plot (map + boxplot) of viceroy non-volatiles
# Jeffrey C. Oliver
# jcoliver@email.arizona.edu
# 2017-03-07

rm(list = ls())

################################################################################
# SUMMARY
# Creates two plots, a map on the left and a boxplot on the right

################################################################################
# SPECIFICS
# Add information unique to this set of figures
data.file <- "data/palatability-data.txt"
output.file <- "output/visualization/Palatability-two-panel"
vars <- list(var.name = c("Mantid.Learning",
                          "Mantid.Memory.Retention"),
             var.text = list(expression("Mantid Learning (# Trials)"),
                             expression("Mantid Memory Retention (# Trials)")
             )
)
separate.files <- TRUE

################################################################################
# SHOULD NOT NEED TO EDIT ANYTHING BELOW HERE
################################################################################

################################################################################
# PLOT
# If plotting to separate files:
#   Loop over each variable
#   Call TwoPanelPlot
# If all plots going to a single file:
#   Load source files
#   Read in data
#   Prepare data
#   Set file format
#   Setup multi-panel plot dimensions
#   Loop over each variable to plot
#     Draw map
#     Draw boxplot

source(file = "scripts/visualization/plotting-globals.R")

if (separate.files) {
  source(file = "functions/two-panel-functions.R")

  for (variable in 1:length(vars$var.name)) {
    outfile <- paste0(output.file, "-", vars$var.name[variable])
    
    TwoPanelPlot(datafile = data.file,
                 outputfile = outfile,
                 varname = vars$var.name[variable],
                 vartext = vars$var.text[variable])
  }
  
} else {
  # Load dependancies
  source(file = "functions/mapping-functions.R")
  source(file = "functions/boxplot-functions.R")

  # Read data with latitude, longitude, and whatever variable(s) to graph
  plot.data <- read.delim(file = data.file)
  
  # Prep output file name
  file.format <- plotting.globals$output.format
  output.file <- paste0(output.file, ".", file.format)
  
  # Set file format
  if (file.format == "pdf") {
    pdf(file = output.file, useDingbats = FALSE)
  } else if (file.format == "png") {
    png(filename = output.file, width = 1200, height = 1200, units = "px", res = 150)
  }
  
  # Setup multi-panel plot dimensions
  par(mfrow = c(length(vars$var.name), 2))
  
  # Loop over each variable to plot
  for (variable in 1:length(vars$var.name)) {
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
    
    # Boxplot
    par(mar = c(1.5, 3, 1, 1))
    
    group.by <- "Site.Name"
    
    MakeBoxplot(plot.data = plot.data,
                variable.name = variable.name,
                variable.text = variable.text,
                grouping.var = group.by,
                col.middle.bar = plotting.globals$group.alt.cols,
                col.boxes = plotting.globals$group.cols,
                xlabs = factor(x = names(plotting.globals$groups)),
                groups = plotting.globals$groups)
    
  }
  
  # Reset graphical parameters to default values
  par(mfrow = c(1, 1), mar = c(5, 4, 4, 2) + 0.1)
  
  # Close pipe to graphics device
  dev.off()
}
