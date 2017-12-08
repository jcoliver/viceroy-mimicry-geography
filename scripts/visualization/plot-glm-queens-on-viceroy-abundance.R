# Plotting glm results of effect of queen abundance on viceroys
# Jeffrey C. Oliver
# jcoliver@email.arizona.edu
# 2017-07-12

rm(list = ls())

################################################################################
# SETUP
# Load dependencies
library("lmerTest")

# Read in data
abundance.data <- read.delim(file = "data/abundance-data.txt")

# Set destination for images


################################################################################
viceroy.model <- glmer(Number.Viceroy.Adults ~ Number.Queen.Adults + + (1|Site.Name) + (1|Observation.Date),
                       data = abundance.data, family = poisson)
viceroy.summary <- summary(viceroy.model)
viceroy.anova <- anova(viceroy.model)

# Create a data frame of values used to draw the plot
# fit is the full GLM model
predicts <- data.frame(fit = predict(viceroy.model))
# x is the number of queens
predicts$x <- abundance.data$Number.Queen.Adults
# y is the observed number of viceroys
predicts$y <- abundance.data$Number.Viceroy.Adults
predicts$site <- abundance.data$Site.Name
predicts <- predicts[!is.na(predicts$fit), ]
# the model (intercept and slope), which are accessible as the third and fourth,
# respectively, elements of the glmer model's optinfo$val vector
predicts$fit.simple <- viceroy.model@optinfo$val[3] + predicts$x * viceroy.model@optinfo$val[4]

####################
# Draw the plot(s)
library("ggplot2")
# Build the base plot, with constants like x & y axis and titles; 
# also plot points of observed data with geom_point
base.plot <- ggplot(predicts, aes(x = x, y = y)) +
  geom_point(aes(color = site, size = 1.25), alpha = 0.8) +
  scale_size(guide = 'none') + # to avoid a legend for size
  scale_color_manual(name = "Site", values = c("#0022AA", "#BB0000","#DD0000","#008888","#2F7A52","#EE0000","#0033CC","#AA0000")) +
  xlab(label = "# Queens") + 
  ylab(label = "# Viceroys") +
  theme_bw() +
  theme(plot.title = element_text(hjust = 0.5))
base.plot

# Plot the GLM results with a different line for each year
sites.plot <- base.plot +
  geom_line(aes(y = fit, col = site))
# Draw plot
sites.plot

# Plot the "simple" GLM results, where intercept is not affected by year
nosites.plot <- base.plot + 
  geom_line(aes(y = fit.simple))
# Draw plot
nosites.plot

# Plot both models, one where year is taken into account (colored solid lines) and one in which
# year does not affect intercept (black dashed line)
both.plot <- base.plot + 
  geom_line(aes(y = fit, col = site)) +
  geom_line(aes(y = fit.simple), linetype = 2)
# Draw plot
both.plot
