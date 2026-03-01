<xsl:stylesheet version="2.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
	xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
  xmlns:mim="http://modellen.mim-standaard.nl/def/mim#"
  xmlns:graphml="http://graphml.graphdrawing.org/xmlns"
  xmlns:y="http://www.yworks.com/xml/graphml"
>

<xsl:output method="text"/>

<xsl:template match="/ROOT/rdf:RDF">
  <xsl:for-each select="rdf:Description[rdf:type/@rdf:resource='http://modellen.mim-standaard.nl/def/mim#Diagram']">
    <xsl:value-of select="@rdf:about"/>
    <xsl:text> </xsl:text>
    <xsl:value-of select="rdfs:label"/>
    <xsl:text>&#xa;</xsl:text>
  </xsl:for-each>
</xsl:template>

</xsl:stylesheet>
