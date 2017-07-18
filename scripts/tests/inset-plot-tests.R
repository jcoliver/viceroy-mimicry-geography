# Inset plot test
# Jeff Oliver
# jcoliver@email.arizona.edu
# 2017-07-18

################################################################################

# DOES NOT WORK, two separate plots
plot(1:10, c(1:10)^2)
par(new = FALSE)
par(fig = c(0, 0.4, 0.5, 1.0))
hist(rnorm(n = 50), cex = 0.8)

# DOES NOT WORK, draws on previous plot, then new separate plot at end
par(fig = c(0, 1, 0, 1))
par(new = TRUE)
plot(1:10, c(1:10)^2)
par(new = FALSE)
par(fig = c(0, 0.4, 0.5, 1.0))
hist(rnorm(n = 50), cex = 0.8)

# This works
x <- rnorm(100)  
y <- rbinom(100, 1, 0.5)
par(fig = c(0,1,0,1))
hist(x)  
par(fig = c(0.07,0.5, 0.5, 1), new = T)  
boxplot(x ~ y)  

