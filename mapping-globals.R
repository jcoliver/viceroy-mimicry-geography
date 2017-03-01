# Global settings for mapping scripts
# Jeff Oliver
# jcoliver@email.arizona.edu
# 2017-02-15

mapping.globals <- list()
mapping.globals$output.format <- "pdf" # "png"
mapping.globals$map.colors <- NULL
if (!require(package = "RColorBrewer")) {
  warning("Mapping globals requires RColorBrewer package; some colors may not display correctly")
} else {
  # Blues
  mapping.globals$map.colors <- colorRampPalette(colors = brewer.pal(n = 9, name = "Blues"))(50)
  # Greens
  # mapping.globals$map.colors <- colorRampPalette(colors = c("#FFFFFF", "#009900"))(50)
  # Red Yellow Blue
  # mapping.globals$map.colors <- rev(colorRampPalette(colors = brewer.pal(n = 11, name = "RdYlBu"))(50))
  # Purple/Blue
  # nine.colors <- brewer.pal(n = 9, name = "BuPu")
  # mapping.globals$map.colors <- colorRampPalette(colors = nine.colors[1:7])(50)
  # Orange/Blue
  # mapping.globals$map.colors <- colorRampPalette(colors = c("#FF4000", "#6600CC"))(50)
}

