#
# ID1: Order-orderregel regulier
#
# Generate diagram for FBM model
#java -jar ../rdf2xml/target/rdf2xml.jar example-fbm/fbm-identificator1.ttl example-fbm/fbm-identificator1.graphml ../rdf2xml/fbm2graphml.xsl add example-fbm/fbm-identificator1-edited.graphml
# Convert FBM model to MIM model
#java -jar ../rdf2rdf/target/rdf2rdf.jar -i example-fbm/fbm-identificator1.ttl -o example-fbm/mim-identificator1.ttl -c fbm2mim.yaml
# Generate diagram for MIM model
#java -jar ../rdf2xml/target/rdf2xml.jar example-fbm/mim-identificator1.ttl example-fbm/mim-identificator1.graphml mim2graphml.xsl add example-fbm/mim-identificator1-edited.graphml

#
# ID2: Order-orderregel regulier
#
# Generate diagram for FBM model
java -jar ../rdf2xml/target/rdf2xml.jar example-fbm/fbm-identificator2.ttl example-fbm/fbm-identificator2.graphml ../rdf2xml/fbm2graphml.xsl add example-fbm/fbm-identificator2-edited.graphml
# Convert FBM model to MIM model
java -jar ../rdf2rdf/target/rdf2rdf.jar -i example-fbm/fbm-identificator2.ttl -o example-fbm/mim-identificator2.ttl -c fbm2mim.yaml
# Generate diagram for MIM model
java -jar ../rdf2xml/target/rdf2xml.jar example-fbm/mim-identificator2.ttl example-fbm/mim-identificator2.graphml mim2graphml.xsl add example-fbm/mim-identificator1-edited.graphml
