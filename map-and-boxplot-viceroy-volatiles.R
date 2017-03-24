# Two-panel plot (map + boxplot) of viceroy volatiles
# Jeffrey C. Oliver
# jcoliver@email.arizona.edu
# 2017-02-28

rm(list = ls())

################################################################################
# SUMMARY
# Creates two plots, a map on the left and a boxplot on the right

################################################################################
# SPECIFICS
# Add information unique to this set of figures
data.file <- "data/chemistry-viceroy-data.txt"
output.file <- "output/Viceroy-volatile-two-panel"
vars <- data.frame(var.name <- c("Total.Volatiles",
                                 "Salicylaldehyde",
                                 "Benzaldehyde"),
                   var.text <- c("Total Volatiles (uL/mL)",
                                 "Salicylaldehyde (uL/mL)",
                                 "Benzaldehyde (uL/mL)"),
                   stringsAsFactors = FALSE)
separate.files <- TRUE

################################################################################
# SHOULD NOT NEED TO EDIT ANYTHING BELOW HERE
################################################################################

################################################################################
# SETUP
# Load source files
# Read in data
# Prepare data

source(file = "plotting-globals.R")

# Read in data
# Read data with latitude, longitude, and whatever variable(s) to graph
plot.data <- read.delim(file = data.file)

# Prep output file name
file.format <- plotting.globals$output.format
output.file <- paste0(output.file, ".", file.format)

################################################################################
# PLOT
# If plotting to separate files:
#   Loop over each variable
#   Call TwoPanelPlot
# If all plots going to a single file:
#   Set file format
#   Setup multi-panel plot dimensions
#   Loop over each variable to plot
#     Draw map
#     Draw boxplot

if (separate.files) {
  source(file = "functions/two-panel-functions.R")

  for (variable in 1:nrow(vars)) {
    outfile <- paste0(output.file, "-", vars$var.name[variable])

    TwoPanelPlot(datafile = data.file, 
                 outputfile = outfile, 
                 varname = vars$var.name[variable], 
                 vartext = vars$var.text[variable])
  }
  
} else {
  source(file = "functions/mapping-functions.R")
  source(file = "functions/boxplot-functions.R")
  # Set file format
  if (file.format == "pdf") {
    pdf(file = output.file, useDingbats = FALSE)
  } else if (file.format == "png") {
    png(filename = output.file, width = 1200, height = 1200, units = "px", res = 150)
  }
  
  # Setup multi-panel plot dimensions
  par(mfrow = c(nrow(vars), 2))
  
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
