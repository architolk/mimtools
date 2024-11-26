#java -jar ../rdf2rdf/target/rdf2rdf.jar example-models/boormachine.ttl serialization/example-boormachine.ttl
#java -jar ../rdf2rdf/target/rdf2rdf.jar example-models/boormachine.ttl serialization/example-boormachine.xml
#java -jar ../rdf2rdf/target/rdf2rdf.jar example-models/boormachine.ttl serialization/example-boormachine.jsonld
#java -jar ../rdf2rdf/target/rdf2rdf.jar serialization/boormachine.jsonld serialization/boormachine.ttl serialize.yaml
java -jar ../rdf2xml/target/rdf2xml.jar serialization/boormachine.ttl serialization/boormachine.graphml mim2graphml.xsl
