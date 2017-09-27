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
  DOI=$(echo $DOILINE | cut -d ' ' -f2)

  # Create URL to pass to curl

  # Run curl & send to file

done

readarray POSLINES < $ALLELEFREQS
LINES=0
for POSLINE in "${POSLINES[@]}";
do
  ((LINES++))
  if [ $LINES -ne 1 ];
  then
    # Pull out value in first column
    POS=$(echo $POSLINE | cut -d ' ' -f1)
    # Use that to grep the VCF file for the line we're interested in
    VCFLINE=$(grep -P 'un\t'${POS} $VCFFILE)
    # Drop everything after "PASS"
    KEEP=${VCFLINE%PASS*}
    # And kick out the last two characters (" .")
    KEEP2=${KEEP::-2}
    echo $KEEP2 >> $OUTFILE
  fi
done
