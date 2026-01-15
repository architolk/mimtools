# Originele opzet (MIM)
#java -jar ../../rdf2rdf/target/rdf2rdf.jar -i fbm-mim.ttl -o mim-mim.ttl -c ../fbm2mim.yaml
#java -jar ../../rdf2xml/target/rdf2xml.jar mim-mim.ttl mim-mim.graphml ../mim2graphml.xsl add mim-mim-edited.graphml

# Tweede opzet (besproken met Ronald)
java -jar ../../rdf2rdf/target/rdf2rdf.jar -i fbm-mim2.ttl -o mim-mim2.ttl -c ../fbm2mim.yaml
java -jar ../../rdf2xml/target/rdf2xml.jar mim-mim2.ttl mim-mim2.graphml ../mim2graphml.xsl add mim-mim2-edited.graphml
