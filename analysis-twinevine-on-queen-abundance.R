# Analyzing twinevine abundance on Queen abundance
# Jeffrey C. Oliver
# jcoliver@email.arizona.edu
# 2017-06-16

rm(list = ls())

################################################################################
# SETUP
# Load dependencies
library("lmerTest")

# Read in data
abundance.data <- read.delim(file = "data/abundance-data.txt")

# Set destination for results
output.file <- "output/analysis-results/twinevine-on-queen-abundance.txt"

################################################################################
queen.model <- glmer(Number.Queen.Adults ~ Number.Twinevine.Plants + + (1|Site.Name) + (1|Observation.Date),
                       data = abundance.data, family = poisson)
queen.summary <- summary(queen.model)

sink(file = output.file)
print(queen.summary)
sink()
