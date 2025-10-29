java -jar ../ea2rdf/target/ea2rdf.jar -ea -e example-uml/example.eap > example-uml/example.ttl
java -jar ../rdf2rdf/target/rdf2rdf.jar example-uml/example.ttl example-models/example.ttl ea2mim.yaml
