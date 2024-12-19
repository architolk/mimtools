#

If you want to automate the process of generating MIM models, please at the following in:

`.github/workflows/gen-mim-ld.yml`

(and change accordingly... - stuff in CAPTITALS)

```

name: Generation

# Trigger generation of mim and ld files when changes in the eap file are pushed to remote.
on:
  push:
    paths:
      - 'FOLDER-WITH-SOURCE-MODELS/**'
  # Allows you to run this workflow manually from the Actions tab
  workflow_dispatch:

jobs:
  gen-pipeline:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout
        uses: actions/checkout@v2
      - name: Set up JDK 11
        uses: actions/setup-java@v3
        with:
          java-version: '11'
          distribution: 'adopt'
      - name: Fetch ea2rdf
        uses: robinraju/release-downloader@v1.3
        with:
          repository: "architolk/ea2rdf"
          tag: "v1.1.0"
          fileName: "ea2rdf.jar"
      - name: Fetch rdf2rdf
        uses: robinraju/release-downloader@v1.3
        with:
          repository: "architolk/rdf2rdf"
          tag: "v1.1.0"
          fileName: "rdf2rdf.jar"
      - name: Fetch rdf2xml
        uses: robinraju/release-downloader@v1.3
        with:
          repository: "architolk/rdf2xml"
          tag: "v1.0.0"
          fileName: "rdf2xml.jar"
      - name: Convert EA to RDF
        run: java -jar ea2rdf.jar -e FOLDER-WITH-SOURCE-MODELS/SOURCE-MODEL-NAME > model-ea.ttl
      - name: Convert EA in RDF to MIM in RDF
        run: java -jar rdf2rdf.jar zvg-ea.ttl model-mim.ttl ea2mim.yaml
      - name: Convert MIM in RDF to RDFS/OWL/SHACL in RDF
        run: java -jar rdf2rdf.jar model-mim.ttl informatiemodel/rdf/zvg-ont.ttl mim2onto.yaml
      - name: Create Model diagram from ontology
        run: java -jar rdf2xml.jar model-ont.ttl model.graphml rdf2graphml.xsl follow model-edited.graphml
      - name: Commit pipeline output
        uses: EndBug/add-and-commit@v9
        with:
          message: Convert EAP model
          add: 'SOURCE-MODEL-NAME'
```
