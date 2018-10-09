# Clustering populations based on number of queens
# Jeffrey C. Oliver
# jcoliver@email.arizona.edu
# 2018-10-09

rm(list = ls())

################################################################################

abund <- read.delim(file = "data/abundance-data.txt")

# Test total of 8 clusters
k.max <- 8
# Calculate total within sum of squares for k = 1 through k = 8
wss <- sapply(X = 1:k.max, 
              FUN = function(k){
                clustering <- kmeans(x = abund$Number.Queen.Adults, 
                                     centers = k, 
                                     nstart = 10)
                return(clustering$tot.withinss)
                }
              )

# Plot k vs. within sum of squares for elbow method
pdf(file = "output/visualization/k-means-queens.pdf", useDingbats = FALSE)
plot(x = 1:k.max,
     y = wss,
     xlab = "K",
     ylab = "Within Sum of Squares",
     type = "b")
dev.off()

# K = 2 is elbow, so identify sites in each cluster
abund$cluster <- kmeans(x = abund$Number.Queen.Adults,
                   centers = 2,
                   nstart = 10)$cluster

# Pull out unique site/cluster combination
unique.clusters <- unique(abund[, c("Site.Name", "cluster")])
unique.clusters <- unique.clusters[order(unique.clusters$cluster, unique.clusters$Site.Name), ]

# Write cluster membership to file
write.table(x = unique.clusters,
            file = "output/analysis-results/k-means-queens.txt",
            row.names = FALSE,
            quote = FALSE,
            sep = "\t")
