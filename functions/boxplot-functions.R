# Functions for boxplots
# Jeff Oliver
# jcoliver@email.arizona.edu
# 2017-03-03

################################################################################
#' Format data for a boxplot, specifically \code{MakeBoxplot}
#' 
#' @param plot.data a data frame a grouping column, \code{grouping.var}, and data column, \code{variable.name}
#' @param group.name character vector used to name column with group membership in output
#' @param grouping.var character vector name of column to categorize observations into x-axis grouping
#' @param variable.name character vector name of column in \code{plot.data} to plot on y-axis
#' @param groups list of groups, one named element per group, where each element has a single character vector of values found in \code{grouping.var}
#' @return data frame with \code{grouping.var}, \code{variable.name}, and \code{group.name}
BoxplotData <- function(plot.data,
                            group.name,
                            grouping.var,
                            variable.name,
                            groups) {
  
  boxplot.data <- plot.data[, c(grouping.var, variable.name)]
  boxplot.data$group <- NA # TODO: Is this used?
  for (one.group in 1:length(groups)) {
    this.group <- names(groups)[one.group]
    group.members <- boxplot.data[, grouping.var] %in% groups[[one.group]]
    boxplot.data[group.members, group.name] <- this.group
  }
  
  return(boxplot.data)
  
}

################################################################################
#' Create boxplot of data of interest
#' 
#' @param plot.data a data frame a grouping column, \code{grouping.var}, and data column, \code{variable.name}
#' @param variable.name character vector name of column in \code{plot.data} to plot on y-axis
#' @param variable.text character vector to use for y-axis title
#' @param grouping.var character vector name of column to categorize observations into x-axis grouping
#' @param col.middle.bar vector of colors to use for middle bar of boxplot
#' @param col.boxes vector of colors to use for boxes
#' @param xlabs character vector of x-axis labels
#' @param groups list of groups, one named element per group, where each element has a single character vector of values found in \code{grouping.var}
#' @examples \notrun{
#' MakeBoxplot(plot.data = plot.data,
#'             variable.name = "Salicin",
#'             variable.text = "Salicin (mg/g)",
#'             grouping.var = "Site.Name",
#'             col.middle.bar = c("black", "white"),
#'             col.boxes = c("white", "black"),
#'             xlabs = factor(c("North", "South")),
#'             groups = list(North = c("Jena", "Gainesville", "Cedar Key", "Leesburg"),
#'                           South = c("Cornwell", "Lake Istokpoga", "Lehigh Acres", "Corkscrew"))
#' }
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