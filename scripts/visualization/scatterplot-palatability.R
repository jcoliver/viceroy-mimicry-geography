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
# Read in data
chem.data <- read.delim(file = "data/palatability-data.txt")
abundance.data <- read.delim(file = "data/abundance-data.txt")
colnames(abundance.data)[which(colnames(abundance.data) == "Observation.Date")] <- "Collection.Date"
all.data <- merge(x = chem.data, 
                  y = abundance.data)

output.file <- "output/visualization/Palatability-scatterplot"
vars <- data.frame(var.name <- c("Mantid.Learning",
                                 "Mantid.Memory.Retention"),
                   var.text <- c("Mantid Learning (# Trials)",
                                 "Mantid Memory Retention (# Trials)"),
                   stringsAsFactors = FALSE)

################################################################################
# SHOULD NOT NEED TO EDIT ANYTHING BELOW HERE
################################################################################

################################################################################
# PLOT
# Draw a simple X-Y scatterplot for each of the variables, with queen abundance
# on the X axis, and palatabilty measure on the Y axis

for (variable in 1:nrow(vars)) {
  outfile <- paste0(output.file, "-", vars$var.name[variable], ".pdf")
  
  # Loop over each variable to plot
  for (variable in 1:nrow(vars)) {
    variable.name <- vars$var.name[variable]
    variable.text <- vars$var.text[variable]
    
    pdf(file = outfile, useDingbats = FALSE)
    plot(x = all.data$Number.Queen.Adults,
         y = all.data[, variable.name],
         xlab = "# Queen adults",
         ylab = variable.text,
         pch = 21,
         bg = "#000000")
    dev.off()
  }
}
