# Analyzing Queen abundance on viceroy abundance
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
output.file <- "output/analysis/queens-on-viceroy-abundance.txt"

################################################################################
viceroy.model <- glmer(Number.Viceroy.Adults ~ Number.Queen.Adults + + (1|Site.Name) + (1|Observation.Date),
                       data = abundance.data, family = poisson)
viceroy.summary <- summary(viceroy.model)
viceroy.anova <- anova(viceroy.model)

sink(file = output.file)
print(viceroy.summary)
print(viceroy.anova)
sink()
