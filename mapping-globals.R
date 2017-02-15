# Global settings for mapping scripts
# Jeff Oliver
# jcoliver@email.arizona.edu
# 2017-02-15

global.vars <- list()
global.vars$output.format <- "pdf" # "png"
global.vars$map.colors <- NULL
if (!require(package = "RColorBrewer")) {
  warning("Mapping globals requires RColorBrewer package; some colors may not display correctly")
} else {
  # Blues
  global.vars$map.colors <- colorRampPalette(colors = brewer.pal(n = 9, name = "Blues"))(50)
  # Greens
  # global.vars$map.colors <- colorRampPalette(colors = c("#FFFFFF", "#009900"))(50)
  # Red Yellow Blue
  # global.vars$map.colors <- rev(colorRampPalette(colors = brewer.pal(n = 11, name = "RdYlBu"))(50))
  # Purple/Blue
  # nine.colors <- brewer.pal(n = 9, name = "BuPu")
  # global.vars$map.colors <- colorRampPalette(colors = nine.colors[1:7])(50)
  # Orange/Blue
  # global.vars$map.colors <- colorRampPalette(colors = c("#FF4000", "#6600CC"))(50)
}

