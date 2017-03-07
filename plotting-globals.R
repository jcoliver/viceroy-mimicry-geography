# Global settings for plotting scripts
# Jeff Oliver
# jcoliver@email.arizona.edu
# 2017-02-15

plotting.globals <- list()
plotting.globals$output.format <- "pdf" # "png"
plotting.globals$map.colors <- NULL
if (!require(package = "RColorBrewer")) {
  warning("Mapping globals requires RColorBrewer package; some colors may not display correctly")
} else {
  # Blues
  plotting.globals$map.colors <- colorRampPalette(colors = brewer.pal(n = 9, name = "Blues"))(50)
  # Greens
  # plotting.globals$map.colors <- colorRampPalette(colors = c("#FFFFFF", "#009900"))(50)
  # Red Yellow Blue
  # plotting.globals$map.colors <- rev(colorRampPalette(colors = brewer.pal(n = 11, name = "RdYlBu"))(50))
  # Purple/Blue
  # nine.colors <- brewer.pal(n = 9, name = "BuPu")
  # plotting.globals$map.colors <- colorRampPalette(colors = nine.colors[1:7])(50)
  # Orange/Blue
  # plotting.globals$map.colors <- colorRampPalette(colors = c("#FF4000", "#6600CC"))(50)
}
plotting.globals$south.pops <- c("Cornwell", "Lake Istokpoga", "Lehigh Acres", "Corkscrew")
plotting.globals$north.pops <- c("Jena", "Gainesville", "Cedar Key", "Leesburg")
plotting.globals$groups <- list(North = c("Jena", "Gainesville", "Cedar Key", "Leesburg"),
                                South = c("Cornwell", "Lake Istokpoga", "Lehigh Acres", "Corkscrew"))