# mimtools
A couple of tools regarding MIM

Build:

```
mvn clean package
```

Usage:
```
java -jar mimtools.jar <model-to-check> metamodel/mim.ttl metamodel/mim-shapes.ttl report.ttl
```

`mim.ttl` contains the MIM ontology, `mim-shapes.ttl` contains the constraints against which the model is validated. Replace these with the appropriate version of the MIM metamodel.

The results are placed into `report.ttl`, according to the SHACL report ontology.
