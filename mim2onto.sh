#!/bin/bash
cd example-models
shopt -s nullglob
for FILE in *.ttl
do
  echo "====================================="
	echo "Create ontology from MIM model: ${FILE%.*}"
  java -jar ../../rdf2rdf/target/rdf2rdf.jar "$FILE" "../ontologies/$FILE" ../mim2onto.yaml
done
