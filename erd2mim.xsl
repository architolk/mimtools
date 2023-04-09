<xsl:stylesheet version="2.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
	xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
	xmlns:ldm="http://powerdesigner.com/def#"

	xmlns:o="object"
	xmlns:a="attribute"
	xmlns:c="collection"

  exclude-result-prefixes="o a c"
>

	<xsl:key name="item" match="//*" use="@Id"/>

	<xsl:variable name="prefix">urn:uuid:</xsl:variable>

	<!-- Helper -->
	<xsl:template match="*" mode="check">
		<rdf:Description rdf:about="urn:test:{@Id}">
			<xsl:for-each select="*">
				<rdfs:label><xsl:value-of select="local-name()"/></rdfs:label>
			</xsl:for-each>
		</rdf:Description>
	</xsl:template>

	<xsl:template match="/">
		<rdf:RDF>
		</rdf:RDF>
	</xsl:template>
</xsl:stylesheet>
