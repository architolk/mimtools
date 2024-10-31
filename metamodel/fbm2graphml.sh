java -jar ../../rdf2rdf/target/rdf2rdf.jar -i fbm.ttl -i2 fbm-shapes.ttl -o fbm-all.ttl
java -jar ../../rdf2xml/target/rdf2xml.jar fbm-all.ttl fbm.graphml ../../rdf2xml/rdf2graphml.xsl add fbm-edited.graphml
rm fbm-all.ttl
