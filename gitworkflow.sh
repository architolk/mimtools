java -jar ../rdf2rdf/target/rdf2rdf.jar -i example-fbm/fbm.ttl -o example-fbm/mim.ttl -c fbm2mim.yaml
java -jar ../rdf2xml/target/rdf2xml.jar example-fbm/fbm.ttl example-fbm/fbm.graphml ../rdf2xml/fbm2graphml.xsl add example-fbm/fbm-edited.graphml
java -jar ../rdf2xml/target/rdf2xml.jar example-fbm/mim.ttl example-fbm/mim.graphml mim2graphml.xsl add example-fbm/mim-edited.graphml
java -jar ../rdf2xml/target/rdf2xml.jar example-fbm/mim.ttl example-fbm/mim.md mim2md.xsl
