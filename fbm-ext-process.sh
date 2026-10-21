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
# EXT1a: Dienstbetrekking met kenmerken
#
# Generate diagram for FBM model
#java -jar ../rdf2xml/target/rdf2xml.jar example-fbm/fbm-relatieobject-ext1a.ttl example-fbm/fbm-relatieobject-ext1a.graphml ../rdf2xml/fbm2graphml.xsl add example-fbm/fbm-relatieobject-ext1-edited.graphml
# Convert FBM model to MIM model
#java -jar ../rdf2rdf/target/rdf2rdf.jar -i example-fbm/fbm-relatieobject-ext1a.ttl -o example-fbm/mim-relatieobject-ext1a.ttl -c fbm2mim.yaml
# Generate diagram for MIM model
#java -jar ../rdf2xml/target/rdf2xml.jar example-fbm/mim-relatieobject-ext1a.ttl example-fbm/mim-relatieobject-ext1a.graphml mim2graphml.xsl add example-fbm/mim-relatieobject-ext1-edited.graphml

#
# EXT1b: Dienstbetrekking met kenmerken
#
# Generate diagram for FBM model
#java -jar ../rdf2xml/target/rdf2xml.jar example-fbm/fbm-relatieobject-ext1b.ttl example-fbm/fbm-relatieobject-ext1b.graphml ../rdf2xml/fbm2graphml.xsl add example-fbm/fbm-relatieobject-ext1-edited.graphml
# Convert FBM model to MIM model
#java -jar ../rdf2rdf/target/rdf2rdf.jar -i example-fbm/fbm-relatieobject-ext1b.ttl -o example-fbm/mim-relatieobject-ext1b.ttl -c fbm2mim.yaml
# Generate diagram for MIM model
#java -jar ../rdf2xml/target/rdf2xml.jar example-fbm/mim-relatieobject-ext1b.ttl example-fbm/mim-relatieobject-ext1b.graphml mim2graphml.xsl add example-fbm/mim-relatieobject-ext1-edited.graphml

#
# EXT1c: Dienstbetrekking met kenmerken, identificator inclusief startdatum
#
# Generate diagram for FBM model
#java -jar ../rdf2xml/target/rdf2xml.jar example-fbm/fbm-relatieobject-ext1c.ttl example-fbm/fbm-relatieobject-ext1c.graphml ../rdf2xml/fbm2graphml.xsl add example-fbm/fbm-relatieobject-ext1c-edited.graphml
# Convert FBM model to MIM model
#java -jar ../rdf2rdf/target/rdf2rdf.jar -i example-fbm/fbm-relatieobject-ext1c.ttl -o example-fbm/mim-relatieobject-ext1c.ttl -c fbm2mim.yaml
# Generate diagram for MIM model
#java -jar ../rdf2xml/target/rdf2xml.jar example-fbm/mim-relatieobject-ext1c.ttl example-fbm/mim-relatieobject-ext1c.graphml mim2graphml.xsl add example-fbm/mim-relatieobject-ext1-edited.graphml

#
# EXT1d: Dienstbetrekking met kenmerken, identificator = nummer
#
# Generate diagram for FBM model
java -jar ../rdf2xml/target/rdf2xml.jar example-fbm/fbm-relatieobject-ext1d.ttl example-fbm/fbm-relatieobject-ext1d.graphml ../rdf2xml/fbm2graphml.xsl add example-fbm/fbm-relatieobject-ext1d-edited.graphml
# Convert FBM model to MIM model
java -jar ../rdf2rdf/target/rdf2rdf.jar -i example-fbm/fbm-relatieobject-ext1d.ttl -o example-fbm/mim-relatieobject-ext1d.ttl -c fbm2mim.yaml
# Generate diagram for MIM model
java -jar ../rdf2xml/target/rdf2xml.jar example-fbm/mim-relatieobject-ext1d.ttl example-fbm/mim-relatieobject-ext1d.graphml mim2graphml.xsl add example-fbm/mim-relatieobject-ext1-edited.graphml

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
#java -jar ../rdf2xml/target/rdf2xml.jar example-fbm/fbm-relatieobject-ext2.ttl example-fbm/fbm-relatieobject-ext2.graphml ../rdf2xml/fbm2graphml.xsl add example-fbm/fbm-relatieobject-ext2-edited.graphml
# Convert FBM model to MIM model
#java -jar ../rdf2rdf/target/rdf2rdf.jar -i example-fbm/fbm-relatieobject-ext2.ttl -o example-fbm/mim-relatieobject-ext2.ttl -c fbm2mim.yaml
# Generate diagram for MIM model
#java -jar ../rdf2xml/target/rdf2xml.jar example-fbm/mim-relatieobject-ext2.ttl example-fbm/mim-relatieobject-ext2.graphml mim2graphml.xsl add example-fbm/mim-relatieobject-ext1-edited.graphml
