#!/bin/bash

PROCESS_FILE="${1:-mapping-genage.yarrr.yml}"

echo "Converting YARRRML mappings to RML"
yarrrml-parser -i $PROCESS_FILE -o data/mapping.rml.ttl

echo "Running RML mapper, output to data/ folder"
# rm data/bio2kg-$PROCESS_FILE.ttl
java -jar /opt/rmlmapper.jar -m data/mapping.rml.ttl -o data/bio2kg-genage.ttl -s turtle -f ../functions_ids.ttl 

# head -n 40 data/bio2kg-genage.ttl