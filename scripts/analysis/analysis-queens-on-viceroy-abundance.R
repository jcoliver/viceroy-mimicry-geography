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
output.file <- "output/analysis-results/queens-on-viceroy-abundance.txt"

abundance.data$Year <- factor(format(as.Date(abundance.data$Observation.Date), "%Y"))

################################################################################
viceroy.model <- glmer(Number.Viceroy.Adults ~ Number.Queen.Adults + (1 | Site.Name) + (1|Year),
                       data = abundance.data, family = poisson(link = "log"))
viceroy.summary <- summary(viceroy.model)
viceroy.anova <- anova(viceroy.model)

sink(file = output.file)
print(viceroy.summary)
print(viceroy.anova)
sink()
