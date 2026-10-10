#
# EXT0: Dienstbetrekking als normale relatie
#
# Generate diagram for FBM model
#java -jar ../rdf2xml/target/rdf2xml.jar example-fbm/fbm-relatieobject-ext0.ttl example-fbm/fbm-relatieobject-ext0.graphml ../rdf2xml/fbm2graphml.xsl add example-fbm/fbm-relatieobject-ext1-edited.graphml
# Convert FBM model to MIM model
#java -jar ../rdf2rdf/target/rdf2rdf.jar -i example-fbm/fbm-relatieobject-ext0.ttl -o example-fbm/mim-relatieobject-ext0.ttl -c fbm2mim.yaml
# Generate diagram for MIM model
#java -jar ../rdf2xml/target/rdf2xml.jar example-fbm/mim-relatieobject-ext0.ttl example-fbm/mim-relatieobject-ext0.graphml mim2graphml.xsl add example-fbm/mim-relatieobject-ext1-edited.graphml

#
# EXT1: Dienstbetrekking met afhankelijk Arbeidscontract
#
# Generate diagram for FBM model
#java -jar ../rdf2xml/target/rdf2xml.jar example-fbm/fbm-relatieobject-ext1.ttl example-fbm/fbm-relatieobject-ext1.graphml ../rdf2xml/fbm2graphml.xsl add example-fbm/fbm-relatieobject-ext1-edited.graphml
# Convert FBM model to MIM model
#java -jar ../rdf2rdf/target/rdf2rdf.jar -i example-fbm/fbm-relatieobject-ext1.ttl -o example-fbm/mim-relatieobject-ext1.ttl -c fbm2mim.yaml
# Generate diagram for MIM model
#java -jar ../rdf2xml/target/rdf2xml.jar example-fbm/mim-relatieobject-ext1.ttl example-fbm/mim-relatieobject-ext1.graphml mim2graphml.xsl add example-fbm/mim-relatieobject-ext1-edited.graphml

#
# EXT2: Dienstbetrekking in relatie met Arbeidscontract
#
# Generate diagram for FBM model
java -jar ../rdf2xml/target/rdf2xml.jar example-fbm/fbm-relatieobject-ext2.ttl example-fbm/fbm-relatieobject-ext2.graphml ../rdf2xml/fbm2graphml.xsl add example-fbm/fbm-relatieobject-ext2-edited.graphml
# Convert FBM model to MIM model
java -jar ../rdf2rdf/target/rdf2rdf.jar -i example-fbm/fbm-relatieobject-ext2.ttl -o example-fbm/mim-relatieobject-ext2.ttl -c fbm2mim.yaml
# Generate diagram for MIM model
java -jar ../rdf2xml/target/rdf2xml.jar example-fbm/mim-relatieobject-ext2.ttl example-fbm/mim-relatieobject-ext2.graphml mim2graphml.xsl add example-fbm/mim-relatieobject-ext1-edited.graphml
