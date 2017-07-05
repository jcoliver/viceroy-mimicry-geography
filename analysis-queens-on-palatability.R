# Analyzing Queen abundance on viceroy palatability
# Jeffrey C. Oliver
# jcoliver@email.arizona.edu
# 2017-06-16

rm(list = ls())

################################################################################
# SETUP
# Load dependencies
library("lmerTest")

# Read in data
chem.data <- read.delim(file = "data/palatability-data.txt")
abundance.data <- read.delim(file = "data/abundance-data.txt")

# Set destination for results
output.file <- "output/analysis-results/queens-on-palatability.txt"

# Enumerate the response variables to analyze
responses <- c("Mantid.Learning",
               "Mantid.Memory.Retention")

# ----------------      SHOULD NOT NEED TO EDIT BELOW HERE      ----------------

# Replace column name in abundance data so we can easily merge the two data frames
colnames(abundance.data)[which(colnames(abundance.data) == "Observation.Date")] <- "Collection.Date"
all.data <- merge(x = chem.data, 
                  y = abundance.data)

################################################################################
# ANALYSES
# Run linear model, with Site.Name and Collection.Date as random effects

# Data frame to hold results
model.results <- data.frame(response = responses,
                            NumDF = NA,
                            DenDF = NA,
                            F.value = NA,
                            p = NA)

# Iterate over all response variables and run model
for (response.index in 1:length(responses)) {
  response <- responses[response.index]
  chem.model <- lmer(eval(as.name(response)) ~ Number.Queen.Adults + (1|Site.Name) + (1|Collection.Date),
                     data = all.data)
  chem.anova <- anova(chem.model)
  model.results$NumDF[response.index] <- chem.anova$NumDF
  model.results$DenDF[response.index] <- chem.anova$DenDF
  model.results$F.value[response.index] <- chem.anova$F.value
  model.results$p[response.index] <- chem.anova$`Pr(>F)`
}

write.table(x = model.results, 
            file = output.file, 
            row.names = FALSE, 
            quote = FALSE,
            sep = "\t")
