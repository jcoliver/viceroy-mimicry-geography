# Two-panel plot (map + boxplot)
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
output.file <- "output/Volatiles-two-panel"
vars <- data.frame(var.name <- c("Total.Volatiles",
                                 "Salicylaldehyde",
                                 "Benzaldehyde"),
                   var.text <- c("Total Volatiles (units)",
                                 "Salicylaldehyde (units)",
                                 "Benzaldehyde (units)"),
                   stringsAsFactors = FALSE)

################################################################################
# SETUP
# Load source files
# Read in data
# Prepare data

source(file = "functions/mapping-functions.R")
source(file = "functions/boxplot-functions.R")
source(file = "plotting-globals.R")

# Read in data
# Read data with latitude, longitude, and whatever variable(s) to graph
plot.data <- read.delim(file = data.file)

# Set color values for graphics
map.point.outline <- "black"
map.point.cex <- 1.2 # May need to be adjusted depending on output format
group.cols <- c("black", "white")
group.alt.cols <- rev(group.cols)
group.fill <- rep(x = group.cols[1], times = nrow(x = plot.data))
group.fill[plot.data$Site.Name %in% plotting.globals$north.pops] <- group.cols[2]

# Prep output file name
file.format <- plotting.globals$output.format
output.file <- paste0(output.file, ".", file.format)

################################################################################
# PLOT
# Set file format
# Setup multi-panel plot dimensions
# Loop over each variable to plot
#   Draw map
#   Draw boxplot

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
                 map.point.outline = map.point.outline,
                 map.point.bg = group.fill,
                 map.point.cex = map.point.cex)
  
  # Boxplot
  par(mar = c(1.5, 3, 1, 1))

  group.by <- "Site.Name"
  group.name <- "group"
  boxplot.data <- plot.data[, c(group.by, variable.name)]
  boxplot.data$group <- NA
  for (one.group in 1:length(plotting.globals$groups)) {
    this.group <- names(plotting.globals$groups)[one.group]
    group.members <- boxplot.data[, group.by] %in% plotting.globals$groups[[one.group]]
    boxplot.data[group.members, group.name] <- this.group
  }

  MakeBoxplot(boxplot.data = boxplot.data,
              group.name = group.name,
              variable.name = variable.name,
              variable.text = variable.text,
              col.middle.bar = group.cols,
              col.boxes = group.alt.cols,
              xlabs = factor(x = names(plotting.globals$groups)))

}

# Reset graphical parameters to default values
par(mfrow = c(1, 1), mar = c(5, 4, 4, 2) + 0.1)

# Close pipe to graphics device
dev.off()
