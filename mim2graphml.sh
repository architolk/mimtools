#!/bin/bash
cd example-models
shopt -s nullglob
for FILE in *.ttl
do
  echo "====================================="
	echo "Generate diagram for model: ${FILE%.*}"
  if [ -f "${FILE%.*}-edited.graphml" ]; then
    java -jar ../../rdf2xml/target/rdf2xml.jar "$FILE" "${FILE%.*}.graphml" ../mim2graphml.xsl add "${FILE%.*}-edited.graphml"
  else
    java -jar ../../rdf2xml/target/rdf2xml.jar "$FILE" "${FILE%.*}.graphml" ../mim2graphml.xsl
  fi
done
