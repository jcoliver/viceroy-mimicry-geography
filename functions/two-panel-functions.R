# Functions for making a two-panel plot, map on the left, boxplot on the right
# Jeff Oliver
# jcoliver@email.arizona.edu
# 2017-03-24

# Parameters needed:
# data.file
# output.file
# vars <- data.frame(var.name <- c("Total.Volatiles",
#                                  "Salicylaldehyde",
#                                  "Benzaldehyde"),
#                    var.text <- c("Total Volatiles (uL/mL)",
#                                  "Salicylaldehyde (uL/mL)",
#                                  "Benzaldehyde (uL/mL)"),
#                    stringsAsFactors = FALSE)
source(file = "functions/mapping-functions.R")
source(file = "functions/boxplot-functions.R")
source(file = "plotting-globals.R")

################################################################################
TwoPanelPlot <- function(datafile, outputfile, varname, vartext, delim = "\t") {
  # Load data
  plot.data <- read.table(file = datafile, header = TRUE, sep = delim)
  
  # Prep output file name
  file.format <- plotting.globals$output.format
  output.file <- paste0(outputfile, ".", file.format)
  
  # Open pipe to appropriate graphics device
  if (file.format == "pdf") {
    pdf(file = output.file, useDingbats = FALSE)
  } else if (file.format == "png") {
    png(filename = output.file, width = 1200, height = 1200, units = "px", res = 150)
  }
  
  par(mfrow = c(1, 2))

    
  variable.name <- varname
  variable.text <- vartext
  
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
  
  # Reset graphical parameters to default values
  par(mfrow = c(1, 1), mar = c(5, 4, 4, 2) + 0.1)
  
  # Close pipe to graphics device
  dev.off()
}