# Analyzing willow chemical defense on viceroy non-volatile chemical defense
# Jeffrey C. Oliver
# jcoliver@email.arizona.edu
# 2017-06-16

rm(list = ls())

################################################################################
# SETUP
# Load dependencies
library("lmerTest")

# Read in data
willow.data <- read.delim(file = "data/chemistry-willow-data.txt")
viceroy.data <- read.delim(file = "data/chemistry-viceroy-data.txt")

# Set destination for results
output.file <- "output/analysis-results/willows-on-non-volatiles-viceroys.txt"

# Enumerate the compounds to analyze
compounds <- c("Total.Phenolics",
               "Salicin",
               "Salicortin",
               "Tremulacin")

# Get a reduced data frame for willows, because we had two per site, we'll just
# take the average values for a site/date combination and use that as a predictor

library("plyr")

# Loop over all compounds and get an average for each site/date combination
compounds.data <- list()
for (compound in compounds) {
  compound.data <- ddply(.data = willow.data,
                                      .variables = c("Site.Name", "Collection.Date"),
                                      .fun = function(x) {
                                        mean(x[, compound])
                                      })
  # Rename this last column to be the compound name
  colnames(compound.data)[ncol(compound.data)] <- compound
  compounds.data[[compound]] <- compound.data
}

# Setup willow data frame and extract compound specific data
willow.ave.data <- NULL
for (compound in compounds) {
  if (is.null(willow.ave.data)) {
    willow.ave.data <- compounds.data[[compound]]
  } else {
    willow.ave.data <- merge(x = willow.ave.data,
                             y = compounds.data[[compound]])
  }
}
colnames(willow.ave.data)[3:6] <- paste0("w.", colnames(willow.ave.data[3:6]))

viceroy.data <- viceroy.data[, c("Site.Name", "Collection.Date", compounds)]
colnames(viceroy.data)[3:6] <- paste0("v.",colnames(viceroy.data[3:6]))

all.data <- merge(x = willow.ave.data,
                  y = viceroy.data)

all.data$Year <- factor(format(as.Date(as.character(all.data$Collection.Date), format = "%d-%b-%y"), "%Y"))

################################################################################
# ANALYSES
# Run linear model, with Site.Name and Collection.Date as random effects

# Data frame to hold results
model.results <- data.frame(compound = compounds,
                            coeff = NA,
                            NumDF = NA,
                            DenDF = NA,
                            F.value = NA,
                            p = NA)

# Iterate over all response variables and run model
for (compound.index in 1:length(compounds)) {
  response <- paste0("v.", compounds[compound.index])
  predictor <- paste0("w.", compounds[compound.index])
  chem.model <- lmer(eval(as.name(response)) ~ eval(as.name(predictor)) + (1|Site.Name) + (1|Year),
                     data = all.data)
  chem.summary <- summary(chem.model)
  model.results$coeff[compound.index] <- chem.summary$coefficients[2, 1]
  chem.anova <- anova(chem.model)
  model.results$NumDF[compound.index] <- chem.anova$NumDF
  model.results$DenDF[compound.index] <- chem.anova$DenDF
  model.results$F.value[compound.index] <- chem.anova$F.value
  model.results$p[compound.index] <- chem.anova$`Pr(>F)`
}

write.table(x = model.results, 
            file = output.file, 
            row.names = FALSE, 
            quote = FALSE,
            sep = "\t")
