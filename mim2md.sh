cd example-respec
java -jar ../../ea2rdf/target/ea2rdf.jar -ea -e ./model/model.eap > ./model/mim-ea.ttl
java -jar ../../rdf2rdf/target/rdf2rdf.jar ./model/mim-ea.ttl ./model/mim.ttl ../ea2mim.yaml
java -jar ../../rdf2xml/target/rdf2xml.jar ./model/mim.ttl ./media/mim.md ../mim2md-new.xsl
npx respec -s ./media/index.html -o ./dist/mim-respec.html --localhost
