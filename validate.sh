#!/bin/bash
java -jar target/mimtools-0.0.1-SNAPSHOT-jar-with-dependencies.jar "example-models/*.ttl" metamodel/mim.ttl metamodel/mim-shapes.ttl report.ttl
