# Functions for boxplots
# Jeff Oliver
# jcoliver@email.arizona.edu
# 2017-03-03

################################################################################
BoxplotData <- function(plot.data,
                            group.name,
                            grouping.var,
                            variable.name,
                            groups) {
  
  boxplot.data <- plot.data[, c(grouping.var, variable.name)]
  boxplot.data$group <- NA
  for (one.group in 1:length(groups)) {
    this.group <- names(groups)[one.group]
    group.members <- boxplot.data[, grouping.var] %in% groups[[one.group]]
    boxplot.data[group.members, group.name] <- this.group
  }
  
  return(boxplot.data)
  
}

################################################################################
MakeBoxplot <- function(plot.data, 
                        variable.name,
                        variable.text,
                        col.middle.bar,
                        col.boxes,
                        xlabs,
                        groups,
                        grouping.var) { 

  group.name <- "group"

  boxplot.data <- BoxplotData (plot.data = plot.data,
                              group.name = group.name,
                              grouping.var = grouping.var,
                              variable.name = variable.name,
                              groups = groups)
    
  # Initial plotting area, so we can draw a grey background and overlay boxplot on top
  boxplot(boxplot.data[, variable.name] ~ boxplot.data[, group.name], 
          frame = FALSE,
          axes = FALSE)
  
  # Grey rectangle
  rect(par("usr")[1], par("usr")[3], par("usr")[2], par("usr")[4], col = 
         "#DDDDDD", border = NA)
  
  # Plot data for real
  boxplot(boxplot.data[, variable.name] ~ boxplot.data[, group.name], 
          add = TRUE,
          ylab = "",
          yaxt = "n",
          xaxt = "n",
          medcol = col.middle.bar, # Color of middle bar
          col = col.boxes, # Fill color of boxes
          frame = FALSE,
          las = 1)
  
  # x-axis labels, no tick-marks
  axis(side = 1, las = 1, lwd = 0, line = -0.5,
       at = seq(1:length(xlabs)), 
       labels = xlabs)
  
  # y-axis labels, with horizontal values
  axis(side = 2, las = 1)
  
  # y-axis title, setting line for better alignment
  title(ylab = variable.text, line = 2)
}