# Convert dates to ISO format
# Jeff Oliver
# jcoliver@email.arizona.edu
# 2018-10-04

rm(list = ls())

################################################################################
indata.path <- "data/original-data"
outdata.path <- "data/"
input.files <- list.files(path = indata.path, full.names = TRUE)

# Iterate over all files and change to ISO format
for (filepath in input.files){
  df <- read.delim(file = filepath)
  # Identify the column with date (all are suffixed with ".Date")
  date.col <- grep(pattern = ".Date", x = colnames(df))
  # Change the odd format, 1-Aug-03, to ISO, 2003-08-01
  df[, date.col] <- as.Date(df[, date.col], format = "%e-%b-%y")
  # Save it to the output directory
  filename <- paste0(outdata.path, basename(filepath))
  write.table(x = df, 
              file = filename, 
              row.names = FALSE, 
              quote = FALSE,
              sep = "\t")
}
