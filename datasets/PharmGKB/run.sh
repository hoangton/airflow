#!/bin/bash

# Check if input file exist, download it if absent
if [ ! -f "data/pharmgkb.csv" ]; then
    echo "data/pharmgkb.csv does not exist, downloading."
    mkdir -p data
    cd data
    # https://www.pharmgkb.org/downloads
    # wget -N https://api.pharmgkb.org/v1/download/file/data/relationships.zip
    # wget -N https://api.pharmgkb.org/v1/download/file/data/genes.zip
    # wget -N https://api.pharmgkb.org/v1/download/file/data/drugs.zip
    # wget -N https://api.pharmgkb.org/v1/download/file/data/chemicals.zip
    # wget -N https://api.pharmgkb.org/v1/download/file/data/phenotypes.zip

    # wget -N https://api.pharmgkb.org/v1/download/file/data/pathways-biopax.zip
    # wget -N https://api.pharmgkb.org/v1/download/file/data/pathways-tsv.zip
    # wget -N 
    # wget -N 
    # wget -N 
    # wget -N 

    unzip -o "*.zip"
    # Convert TSV to CSV for RML Mapper
    # sed -e 's/"//g' -e 's/\t/","/g' -e 's/^/"/' -e 's/$/"/' -e 's/\r//' relationships.tsv > relationships.csv
    # find . -name "*.tsv" -exec gzip -d  sed -e 's/"//g' -e 's/\t/","/g' -e 's/^/"/' -e 's/$/"/' -e 's/\r//' {}.tsv > {}.csv

    find . -name "*.tsv"  | while read file 
    do
        sed -e 's/"//g' -e 's/\t/","/g' -e 's/^/"/' -e 's/$/"/' -e 's/\r//' $file > "$file.csv"
    done

    cd ..
fi

# echo "Converting YARRRML mappings to RML"
# yarrrml-parser -i pharmgkb-mapping.yarrr.yml -o data/mapping.rml.ttl
# # yarrrml-parser -i TMpharmgkb.yml -o data/TMpharmgkb.rml.ttl

# echo "Running RML mapper, output to data/ folder"
# rm data/bio2kg-pharmgkb.ttl
# java -jar /opt/rmlmapper.jar -m data/mapping.rml.ttl -o data/bio2kg-pharmgkb.ttl -s turtle -f ../functions_ids.ttl 
