#java -jar ../rdf2rdf/target/rdf2rdf.jar -i example-fbm/mim-relatieobject-ext-mim20.ttl -o example-fbm/mim20onto.ttl -c ../rdf2rdf/rdf2sh.yaml
#java -jar ../rdf2xml/target/rdf2xml.jar example-fbm/mim20onto.ttl example-fbm/mim20onto.graphml ../rdf2xml/rdf2graphml.xsl add example-fbm/mim20onto-edited.graphml
java -jar ../rdf2xml/target/rdf2xml.jar example-fbm/mim-relatieobject-ext-mim20.ttl example-fbm/mim-relatieobject-ext-mim20.graphml ../rdf2xml/ld2graphml.xsl
