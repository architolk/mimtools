<xsl:stylesheet version="2.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
	xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
  xmlns:mim="http://modellen.mim-standaard.nl/def/mim#"
  xmlns:graphml="http://graphml.graphdrawing.org/xmlns"
  xmlns:y="http://www.yworks.com/xml/graphml"
>

<xsl:key name="item" match="/ROOT/rdf:RDF/rdf:Description" use="@rdf:about|@rdf:nodeID"/>

<xsl:variable name="params" select="/ROOT/@params"/>

<xsl:template match="rdf:Description" mode="diagram">
  <!-- Every diagram should have a separate diagram -->
  <!-- TODO: How to create multieple files from one xsl -->
  <graphml:graphml>
    <diagram><xsl:value-of select="rdfs:label"/></diagram>
		<graphml:graph id="G" edgedefault="directed">
			<xsl:apply-templates select="key('item',mim:visualiseert/@rdf:nodeID)" mode="diaobj"/>
		</graphml:graph>
	</graphml:graphml>
</xsl:template>

<xsl:template match="rdf:Description[exists(mim:object)]" mode="diaobj">
  <graphml:node>
    <graphml:data key='d3'><xsl:value-of select="mim:object/@rdf:resource"/></graphml:data>
    <graphml:data key='d5'>
      <y:UMLClassNode>
        <y:Geometry height="{mim:height}" width="{mim:width}" x="{mim:left}" y="{mim:top}"/>
      </y:UMLClassNode>
    </graphml:data>
  </graphml:node>
</xsl:template>

<xsl:template match="rdf:Description[exists(mim:connector)]" mode="diaobj">
  <xsl:variable name="subject-uri" select="key('item',mim:connector/@rdf:resource)/mim:bron/@rdf:resource"/>
  <xsl:variable name="property-uri" select="mim:connector/@rdf:resource"/>
  <xsl:variable name="object-uri" select="key('item',mim:connector/@rdf:resource)/mim:doel/@rdf:resource"/>
  <xsl:variable name="statement-uri">urn:md5:<xsl:value-of select="concat($subject-uri,$property-uri,$object-uri)"/></xsl:variable>
  <graphml:edge>
    <graphml:data key='d7'><xsl:value-of select="$statement-uri"/></graphml:data>
    <graphml:data key='d10'>
      <y:PolyLineEdge>
        <y:Path sx="{mim:startX}" sy="{mim:startY}" tx="{mim:endX}" ty="{mim:endY}">
          <xsl:for-each select="tokenize(mim:path,',')">
            <!-- TODO: Transpose should be done in ea2mim, not in the dia -->
            <y:Point x="{1.5*xs:decimal(substring-before(.,' '))}" y="{-1.0*xs:decimal(substring-after(.,' '))}"/>
          </xsl:for-each>
        </y:Path>
      </y:PolyLineEdge>
    </graphml:data>
  </graphml:edge>
</xsl:template>

<xsl:template match="/ROOT/rdf:RDF">
  <xsl:choose>
    <xsl:when test="$params!=''"><xsl:apply-templates select="rdf:Description[@rdf:about=$params]" mode="diagram"/></xsl:when>
    <xsl:otherwise><xsl:apply-templates select="rdf:Description[rdf:type/@rdf:resource='http://modellen.mim-standaard.nl/def/mim#Diagram']" mode="diagram"/></xsl:otherwise>
  </xsl:choose>
</xsl:template>

</xsl:stylesheet>
