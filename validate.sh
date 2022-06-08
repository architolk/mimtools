#!/bin/bash
cd example-models
shopt -s nullglob
for FILE in *.ttl
do
  echo "====================================="
	echo "Validate model: ${FILE%.*}"
  java -jar ../target/mimtools-0.0.1-SNAPSHOT-jar-with-dependencies.jar "./$FILE" ../metamodel/mim.ttl ../metamodel/mim-shapes.ttl "../reports/$FILE"
done
