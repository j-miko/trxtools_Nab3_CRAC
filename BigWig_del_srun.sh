#!/bin/bash


# Navigate to the directory containing your SAM files
cd $PWD/04a_BigWig_umitools

# Loop through each SAM file and run SAM2profilesGenomic.py
for f in *sam; do
    SAM2profilesGenomic.py -f $f -u del &
done

# Wait for all background jobs to finish
wait

