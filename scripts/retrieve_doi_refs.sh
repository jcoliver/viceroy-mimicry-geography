#!/bin/bash

# Retrieve reference info for dois in file
# Jeff Oliver
# jcoliver@email.arizona.edu
# 2017-09-27

# Path information
DOIFILE="../docs/doi-refs.txt"
OUTFILE="../docs/doi-refs.bib"

echo "" > $OUTFILE

# Read doi file line by line, retrieve info using
# curl -LH "Accept: application/x-bibtex" http://dx.doi.org/10.1038/469041a

readarray DOILINES < $DOIFILE
LINES=0
for DOILINE in "${DOILINES[@]}";
do
  # Pull out value in second column
  DOI=$(echo $DOILINE | rev | cut -d ' ' -f1 | rev)

  # Create URL to pass to curl
  URL=http://dx.doi.org/$DOI
  
  # Run curl & send to file
  curl -LH "Accept: application/x-bibtex" $URL >> $OUTFILE
  echo -e "\n" >> $OUTFILE

done
