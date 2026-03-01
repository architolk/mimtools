cd example-respec
# Basics
java -jar ../../ea2rdf/target/ea2rdf.jar -ea -e ./model/model.eap > ./model/mim-ea.ttl
java -jar ../../rdf2rdf/target/rdf2rdf.jar ./model/mim-ea.ttl ./model/mim.ttl ../ea2mim.yaml
java -jar ../../rdf2xml/target/rdf2xml.jar ./model/mim.ttl ./media/mim.md ../mim2md-new.xsl

# All diagrams
java -jar ../../rdf2xml/target/rdf2xml.jar ./model/mim.ttl ./media/diagrams.txt ../mim2dias.xsl diagrams
while read -r LINE
do
  if [ "${LINE:0:9}" == "urn:uuid:" ]
  then
    java -jar ../../rdf2xml/target/rdf2xml.jar ./model/mim.ttl ./media/mim-edited.graphml ../mim2dia.xsl ${LINE:0:45}
    java -jar ../../rdf2xml/target/rdf2xml.jar ./model/mim.ttl ./media/${LINE:9:36}.graphml ../mim2graphml.xsl add ./media/mim-edited.graphml
  fi
done < ./media/diagrams.txt

# Creating respec single html
npx respec -s ./media/index.html -o ./dist/mim-respec.html --localhost

# Starting webserver for checking (local svg's won't be visible!)
#npx http-server ./dist
