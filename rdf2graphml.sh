#!/bin/bash
cd ontologies
shopt -s nullglob
for FILE in *.ttl
do
  echo "====================================="
	echo "Generate diagram for ontology: ${FILE%.*}"
  if [ -f "${FILE%.*}-edited.graphml" ]; then
    java -jar ../../rdf2xml/target/rdf2xml.jar "$FILE" "${FILE%.*}.graphml" ../../rdf2xml/rdf2graphml.xsl add "${FILE%.*}-edited.graphml"
  else
    java -jar ../../rdf2xml/target/rdf2xml.jar "$FILE" "${FILE%.*}.graphml" ../../rdf2xml/rdf2graphml.xsl
  fi
done
