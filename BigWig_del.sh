#!/bin/bash
for f in *sam; do
    SAM2profilesGenomic.py -f $f -u del &
done

# Wait for all background jobs to finish
wait
