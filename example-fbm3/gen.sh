java -jar ../../rdf2xml/target/rdf2xml.jar fbm.ttl fbm.graphml ../../rdf2xml/fbm2graphml.xsl add fbm-edited.graphml
java -jar ../../rdf2rdf/target/rdf2rdf.jar -i fbm.ttl -o mim.ttl -c ../fbm2mim.yaml
java -jar ../../rdf2xml/target/rdf2xml.jar mim.ttl mim.graphml ../mim2graphml.xsl add mim-edited.graphml
