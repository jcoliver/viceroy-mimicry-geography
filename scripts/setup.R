# Setup script for analyses included in this repository
# Jeff Oliver
# jcoliver@email.arizona.edu
# 2018-10-04

# Install dependencies (if necessary)
dependencies <- c("lmerTest", "plyr", "rgdal", "ggplot2", 
                  "gstat", "raster", "sp", "RColorBrewer")

# Iterate over all additonal packages, installing as necessary
for (package in dependencies) {
  if (!(package %in% rownames(installed.packages()))) {
    message(paste0("Package '", package, "' not installed, attemping installation...\n"))
    install.packages(pkgs = package)
  }
}

# Set up output directories (if not already there)
if (!dir.exists("output")) {
  message("Creating directory 'output'")
  dir.create("output")
}
if (!dir.exists("output/analysis-results")) {
  message("Creating directory 'output/analysis-results'")
  dir.create("output/analysis-results")
}
if (!dir.exists("output/visualization")) {
  message("Creating directory 'output/visualization'")
  dir.create("output/visualization")
}