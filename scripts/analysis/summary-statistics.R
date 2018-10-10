# Summary statistics
# Jeffrey C. Oliver
# jcoliver@email.arizona.edu
# 2018-10-09

rm(list = ls())

################################################################################
# Load in the globals for north/south information
source(file = "scripts/visualization/plotting-globals.R")
library("dplyr")

pal.data <- read.delim(file = "data/palatability-data.txt")
abundance.data <- read.delim(file = "data/abundance-data.txt")

# Replace column name in abundance data so we can easily merge the two data frames
colnames(abundance.data)[which(colnames(abundance.data) == "Observation.Date")] <- "Collection.Date"
all.data <- merge(x = pal.data, 
                  y = abundance.data)

# Categorize sites by whether they are treated as north/south
all.data$group <- "North"
all.data$group[all.data$Site.Name %in% plotting.globals$groups$South] <- "South"

sum.stats <- all.data %>%
  group_by(group) %>%
  summarize(mean.num.queens = mean(Number.Queen.Adults),
            se.num.queens = sd(Number.Queen.Adults)/sqrt(n()),
            mean.num.viceroys = mean(Number.Viceroy.Adults),
            se.num.viceroys = sd(Number.Viceroy.Adults)/sqrt(n()),
            mean.num.twinevine = mean(Number.Twinevine.Plants),
            se.num.twinevine = sd(Number.Twinevine.Plants)/sqrt(n()),
            mean.num.willow = mean(Number.Carolina.Willow.Plants),
            se.num.willow = sd(Number.Carolina.Willow.Plants)/sqrt(n()),
            mean.retention = mean(Mantid.Memory.Retention),
            se.retention = sd(Mantid.Memory.Retention)/sqrt(n()),
            mean.learning = mean(Mantid.Learning),
            se.learning = sd(Mantid.Learning)/sqrt(n())
  )

# Write results to output file
write.table(x = sum.stats,
            file = "output/analysis-results/summary-stats.txt",
            row.names = FALSE,
            quote = FALSE,
            sep = "\t")