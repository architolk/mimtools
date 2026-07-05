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

<xsl:variable name="mim-ns">http://modellen.mim-standaard.nl/def/mim#</xsl:variable>
<xsl:variable name="mim-Diagram"><xsl:value-of select="$mim-ns"/>Diagram</xsl:variable>

<xsl:key name="item" match="/ROOT/rdf:RDF/rdf:Description" use="@rdf:about"/>
<xsl:key name="parent" match="/ROOT/rdf:RDF/rdf:Description" use="(mim:attribuut|mim:bevatModelelement|mim:relatierol|mim:dataElement|mim:waarde|mim:referentieElement|mim:gegevensgroep)/@rdf:resource"/>

<xsl:template match="rdf:Description" mode="label">
  <xsl:choose>
    <xsl:when test="mim:naam[1]!=''"><xsl:value-of select="mim:naam[1]"/></xsl:when>
    <xsl:otherwise><xsl:value-of select="rdfs:label[1]"/></xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="rdf:Description" mode="package">
  <xsl:param name="level"/>

  <xsl:value-of select="substring('                                    ',1,$level)"/>
  <xsl:text>- [</xsl:text>
  <xsl:apply-templates select="." mode="label"/>
  <xsl:text>](</xsl:text>
  <xsl:value-of select="@rdf:about"/>
  <xsl:text>) (</xsl:text>
  <xsl:value-of select="substring-after(rdf:type/@rdf:resource,'#')"/>
  <xsl:text>)&#xa;</xsl:text>

  <xsl:apply-templates select="key('item',mim:bevatModelelement/@rdf:resource)[exists(mim:bevatModelelement)]" mode="package">
    <xsl:with-param name="level" select="2+$level"/>
  </xsl:apply-templates>
</xsl:template>

<xsl:template match="/ROOT/rdf:RDF">
  <xsl:for-each select="rdf:Description[not(exists(key('parent',@rdf:about))) and rdf:type/@rdf:resource!=$mim-Diagram]">
    <xsl:apply-templates select="." mode="package"><xsl:with-param name="level" select="0"/></xsl:apply-templates>
  </xsl:for-each>
</xsl:template>

</xsl:stylesheet>
