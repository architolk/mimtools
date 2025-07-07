<xsl:stylesheet version="2.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
	xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
  xmlns:sh="http://www.w3.org/ns/shacl#"
  xmlns:skos="http://www.w3.org/2004/02/skos/core#"
  xmlns:graphml="http://graphml.graphdrawing.org/xmlns"
  xmlns:y="http://www.yworks.com/xml/graphml"
  xmlns:owl="http://www.w3.org/2002/07/owl#"
  xmlns:dct="http://purl.org/dc/terms/"
  xmlns:foaf="http://xmlns.com/foaf/0.1/"
  xmlns:mim="http://modellen.mim-standaard.nl/def/mim#"
>

<xsl:output method="text"/>

<xsl:variable name="mim">http://modellen.mim-standaard.nl/def/mim#</xsl:variable>
<xsl:variable name="mim-objecttype"><xsl:value-of select="$mim"/>Objecttype</xsl:variable>
<xsl:variable name="mim-relatiesoort"><xsl:value-of select="$mim"/>Relatiesoort</xsl:variable>
<xsl:variable name="mim-informatiemodel"><xsl:value-of select="$mim"/>Informatiemodel</xsl:variable>
<xsl:variable name="mim-relatierolbron"><xsl:value-of select="$mim"/>RelatierolBron</xsl:variable>
<xsl:variable name="mim-relatieroldoel"><xsl:value-of select="$mim"/>RelatierolDoel</xsl:variable>
<xsl:variable name="mim-enumeratie"><xsl:value-of select="$mim"/>Enumeratie</xsl:variable>
<xsl:variable name="mim-primitiefdatatype"><xsl:value-of select="$mim"/>PrimitiefDatatype</xsl:variable>

<xsl:variable name="params" select="/ROOT/@params"/>
<xsl:variable name="lang">
  <xsl:choose>
    <xsl:when test="substring-after($params,'lang=')!=''"><xsl:value-of select="substring-after($params,'lang=')"/></xsl:when>
    <xsl:otherwise>en</xsl:otherwise>
  </xsl:choose>
</xsl:variable>

<xsl:key name="gen-sub" match="/ROOT/rdf:RDF/rdf:Description" use="mim:subtype/@rdf:resource"/>
<xsl:key name="gen-super" match="/ROOT/rdf:RDF/rdf:Description" use="mim:supertype/@rdf:resource"/>
<xsl:key name="ot" match="/ROOT/rdf:RDF/rdf:Description" use="mim:attribuut/@rdf:resource"/>
<xsl:key name="rs-bron" match="/ROOT/rdf:RDF/rdf:Description[rdf:type/@rdf:resource=$mim-relatiesoort]" use="mim:bron/@rdf:resource"/>
<xsl:key name="rs-doel" match="/ROOT/rdf:RDF/rdf:Description[rdf:type/@rdf:resource=$mim-relatiesoort]" use="mim:doel/@rdf:resource"/>

<xsl:key name="resource" match="/ROOT/rdf:RDF/rdf:Description" use="@rdf:about|@rdf:nodeID"/>
<xsl:key name="pshape" match="/ROOT/rdf:RDF/rdf:Description" use="sh:path/@rdf:resource"/>

<xsl:variable name="terms">
  <xsl:for-each select="/ROOT/rdf:RDF/rdf:Description[rdf:type/@rdf:resource=$mim-objecttype or rdf:type/@rdf:resource=$mim-enumeratie or rdf:type/@rdf:resource=$mim-primitiefdatatype]">
    <term id="{mim:identifier}" label="{lower-case(rdfs:label)}"/>
  </xsl:for-each>
</xsl:variable>

<xsl:template match="*" mode="anchor">
  <xsl:value-of select="replace(replace(.,'[^A-Za-z0-9-]','-'),'[-]+','-')"/>
</xsl:template>

<xsl:template match="*" mode="lcase-anchor">
  <xsl:value-of select="replace(replace(lower-case(.),'[^A-Za-z0-9-]','-'),'[-]+','-')"/>
</xsl:template>

<xsl:template match="*" mode="label">
  <xsl:choose>
    <xsl:when test="rdfs:label[@xml:lang=$lang]!=''"><xsl:value-of select="rdfs:label[@xml:lang=$lang]"/></xsl:when>
    <xsl:otherwise><xsl:value-of select="rdfs:label[1]"/></xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="*" mode="labelledlink">
  <xsl:text>[</xsl:text><xsl:apply-templates select="." mode="label"/><xsl:text>](</xsl:text>
  <xsl:if test="mim:identifier!=''"><xsl:text>#</xsl:text><xsl:apply-templates select="mim:identifier" mode="anchor"/></xsl:if>
  <xsl:text>)</xsl:text>
</xsl:template>

<xsl:template match="text()" mode="header2">
  <xsl:text>&#xa;## </xsl:text><xsl:value-of select="."/><xsl:text>&#xa;&#xa;</xsl:text>
</xsl:template>
<xsl:template match="*" mode="header2">
  <xsl:variable name="label">
    <xsl:apply-templates select="." mode="label"/>
    <xsl:if test="mim:identifier!=''"> {#<xsl:apply-templates select="mim:identifier" mode="anchor"/>}</xsl:if>
  </xsl:variable>
  <xsl:apply-templates select="$label" mode="header2"/>
</xsl:template>

<xsl:template match="text()" mode="header3">
  <xsl:text>&#xa;### </xsl:text><xsl:value-of select="."/><xsl:text>&#xa;&#xa;</xsl:text>
</xsl:template>
<xsl:template match="*" mode="header3">
  <xsl:variable name="label">
    <xsl:apply-templates select="." mode="label"/>
    <xsl:if test="mim:identifier!=''"> {#<xsl:apply-templates select="mim:identifier" mode="anchor"/>}</xsl:if>
  </xsl:variable>
  <xsl:apply-templates select="$label" mode="header3"/>
</xsl:template>

<xsl:template match="*" mode="table-def-header">
  <xsl:text>|{: .def}||&#xa;</xsl:text>
  <xsl:text>|-|-|&#xa;</xsl:text>
</xsl:template>

<xsl:template match="*" mode="meta-supertype">
  <xsl:if test="exists(key('gen-sub',@rdf:about))">
    <xsl:text>|Supertype|</xsl:text>
    <xsl:for-each select="key('gen-sub',@rdf:about)/mim:supertype/@rdf:resource">
      <xsl:if test="position()!=1"><xsl:text>, </xsl:text></xsl:if>
      <xsl:apply-templates select="key('resource',.)" mode="labelledlink"/>
    </xsl:for-each>
    <xsl:text>|&#xa;</xsl:text>
  </xsl:if>
</xsl:template>

<xsl:template match="*" mode="meta-subtype">
  <xsl:if test="exists(key('gen-super',@rdf:about))">
    <xsl:text>|Subtype(s)|</xsl:text>
    <xsl:for-each select="key('gen-super',@rdf:about)/mim:subtype/@rdf:resource">
      <xsl:if test="position()!=1"><xsl:text>, </xsl:text></xsl:if>
      <xsl:apply-templates select="key('resource',.)" mode="labelledlink"/>
    </xsl:for-each>
    <xsl:text>|&#xa;</xsl:text>
  </xsl:if>
</xsl:template>

<xsl:template match="*" mode="meta-superdatatype">
  <xsl:if test="exists(key('gen-sub',@rdf:about))">
    <xsl:text>|Gebaseerd op|</xsl:text>
    <xsl:for-each select="key('gen-sub',@rdf:about)/mim:supertype/@rdf:resource">
      <xsl:if test="position()!=1"><xsl:text>, </xsl:text></xsl:if>
      <xsl:variable name="mimtype"><xsl:value-of select="substring-after(.,$mim)"/></xsl:variable>
      <xsl:choose>
        <xsl:when test="$mimtype!=''"><xsl:value-of select="$mimtype"/></xsl:when>
        <xsl:otherwise><xsl:apply-templates select="key('resource',.)" mode="labelledlink"/></xsl:otherwise>
      </xsl:choose>
    </xsl:for-each>
    <xsl:text>|&#xa;</xsl:text>
  </xsl:if>
</xsl:template>

<xsl:template match="*" mode="parse-definitie">
  <xsl:param name="subject"/>
  <xsl:variable name="attrterms">
    <xsl:for-each select="key('resource',key('resource',$subject)/mim:attribuut/@rdf:resource)">
      <term id="{mim:identifier}" label="{lower-case(rdfs:label)}"/>
    </xsl:for-each>
  </xsl:variable>
  <xsl:for-each select="tokenize(replace(.,'\n','&lt;br/>'),'\[')">
    <xsl:variable name="token"><xsl:value-of select="substring-before(.,']')"/></xsl:variable>
    <xsl:choose>
      <xsl:when test="position()=1"><xsl:value-of select="."/></xsl:when>
      <xsl:when test="$token!=''">
        <xsl:text>[</xsl:text>
        <xsl:value-of select="$token"/>
        <xsl:text>](</xsl:text>
        <xsl:choose>
          <xsl:when test="exists($terms/term[@label=lower-case($token)])"><xsl:text>#</xsl:text><xsl:value-of select="$terms/term[@label=lower-case($token)][1]/@id"/></xsl:when>
          <xsl:otherwise>
            <!-- Term bestaat niet als objecttype, enumeratie of primitief datatype, dus blijkbaar een attribuutsoort als onderdeel van de sleutel? -->
            <xsl:if test="exists($attrterms/term[@label=lower-case($token)])"><xsl:text>#</xsl:text><xsl:value-of select="$attrterms/term[@label=lower-case($token)][1]/@id"/></xsl:if>
          </xsl:otherwise>
        </xsl:choose>
        <xsl:text>)</xsl:text>
        <xsl:value-of select="substring-after(.,']')"/>
    </xsl:when>
      <xsl:otherwise><xsl:value-of select="."/></xsl:otherwise>
    </xsl:choose>
  </xsl:for-each>
</xsl:template>

<xsl:template match="*" mode="meta-definitie">
  <xsl:if test="exists(mim:definitie)">
    <xsl:text>|Definitie|</xsl:text><xsl:apply-templates select="mim:definitie" mode="parse-definitie"><xsl:with-param name="subject" select="@rdf:about"/></xsl:apply-templates><xsl:text>|&#xa;</xsl:text>
  </xsl:if>
</xsl:template>

<xsl:template match="*" mode="meta-toelichting">
  <xsl:if test="exists(mim:toelichting)">
    <xsl:text>|Toelichting|</xsl:text><xsl:apply-templates select="mim:toelichting" mode="parse-definitie"><xsl:with-param name="subject" select="@rdf:about"/></xsl:apply-templates><xsl:text>|&#xa;</xsl:text>
  </xsl:if>
</xsl:template>

<xsl:template match="*" mode="meta-begrip">
  <xsl:if test="exists(mim:begrip)">
    <xsl:text>|Begrip|</xsl:text>
    <xsl:for-each select="key('resource',mim:begrip/@rdf:resource)">
      <xsl:if test="position()!=1"><xsl:text>, </xsl:text></xsl:if>
      <xsl:text>[</xsl:text><xsl:value-of select="rdfs:label"/><xsl:text>](#</xsl:text><xsl:apply-templates select="rdfs:label" mode="lcase-anchor"/><xsl:text>)</xsl:text>
    </xsl:for-each>
    <xsl:text>|&#xa;</xsl:text>
  </xsl:if>
</xsl:template>

<xsl:template match="*" mode="meta-bron">
  <xsl:if test="exists(dct:source)">
    <xsl:text>|Bron|</xsl:text>
    <xsl:for-each select="key('resource',dct:source/@rdf:resource)">
      <xsl:if test="position()!=1"><xsl:text>, </xsl:text></xsl:if>
      <xsl:text>[</xsl:text><xsl:value-of select="dct:bibliographicCitation"/><xsl:text>](</xsl:text><xsl:value-of select="foaf:page/@rdf:resource"/><xsl:text>)</xsl:text>
    </xsl:for-each>
    <xsl:text>|&#xa;</xsl:text>
  </xsl:if>
</xsl:template>

<xsl:template match="*" mode="meta-eigenschappen-kenmerken">
  <xsl:if test="exists(mim:attribuut)">
    <xsl:text>|Kenmerken|</xsl:text>
    <xsl:for-each select="key('resource',mim:attribuut/(@rdf:resource|@rdf:nodeID))"><xsl:sort select="rdfs:label"/>
      <xsl:if test="position()!=1"><xsl:text>, </xsl:text></xsl:if>
      <xsl:apply-templates select="." mode="labelledlink"/>
    </xsl:for-each>
    <xsl:text>|&#xa;</xsl:text>
  </xsl:if>
</xsl:template>

<xsl:template match="*" mode="meta-eigenschappen-rollen">
  <xsl:if test="exists(key('rs-bron',@rdf:about))">
    <xsl:text>|Rollen|</xsl:text>
    <xsl:for-each select="key('rs-bron',@rdf:about)"><xsl:sort select="rdfs:label"/>
      <xsl:if test="position()!=1"><xsl:text>, </xsl:text></xsl:if>
      <xsl:apply-templates select="." mode="labelledlink"/>
    </xsl:for-each>
    <xsl:text>|&#xa;</xsl:text>
  </xsl:if>
</xsl:template>

<xsl:template match="*" mode="meta-eigenschappen-relaties">
  <xsl:if test="exists(key('rs-doel',@rdf:about))">
    <xsl:text>|Relatie met|</xsl:text>
    <xsl:for-each select="key('rs-doel',@rdf:about)"><xsl:sort select="rdfs:label"/>
      <xsl:if test="position()!=1"><xsl:text>, </xsl:text></xsl:if>
      <xsl:apply-templates select="." mode="labelledlink"/>
    </xsl:for-each>
    <xsl:text>|&#xa;</xsl:text>
  </xsl:if>
</xsl:template>

<xsl:template match="*" mode="recurse">
  <xsl:copy-of select="key('blank',rdf:first/@rdf:nodeID)"/>
  <xsl:apply-templates select="key('blank',rdf:rest/@rdf:nodeID)" mode="recurse"/>
</xsl:template>

<xsl:template match="*" mode="meta-eigenaar">
  <xsl:text>|Eigenschap van|</xsl:text>
  <xsl:for-each select="key('ot',@rdf:about)">
      <xsl:apply-templates select="." mode="labelledlink"/>
  </xsl:for-each>
  <xsl:text>|&#xa;</xsl:text>
</xsl:template>

<xsl:template match="*" mode="meta-rolbron">
  <xsl:text>|Rol van|</xsl:text>
  <xsl:value-of select="key('resource',mim:relatierol/(@rdf:resource|@rdf:nodeID))[rdf:type/@rdf:resource=$mim-relatierolbron]/mim:kardinaliteit"/>
  <xsl:text> </xsl:text>
  <xsl:apply-templates select="key('resource',mim:bron/@rdf:resource)" mode="labelledlink"/>
  <xsl:text>|&#xa;</xsl:text>
</xsl:template>

<xsl:template match="*" mode="meta-roldoel">
  <xsl:text>|Met|</xsl:text>
  <xsl:variable name="card"><xsl:value-of select="key('resource',mim:relatierol/(@rdf:resource|@rdf:nodeID))[rdf:type/@rdf:resource=$mim-relatieroldoel]/mim:kardinaliteit"/></xsl:variable>
  <xsl:value-of select="$card"/>
  <xsl:if test="$card=''"><xsl:value-of select="mim:kardinaliteit"/></xsl:if>
  <xsl:text> </xsl:text>
  <xsl:for-each select="key('resource',mim:doel/@rdf:resource)">
      <xsl:apply-templates select="." mode="labelledlink"/>
  </xsl:for-each>
  <xsl:text>|&#xa;</xsl:text>
</xsl:template>

<xsl:template match="*" mode="meta-waardetype">
  <xsl:text>|Type|</xsl:text>
  <xsl:variable name="mimtype"><xsl:value-of select="substring-after(mim:type/@rdf:resource,$mim)"/></xsl:variable>
  <xsl:choose>
    <xsl:when test="$mimtype!=''"><xsl:value-of select="$mimtype"/></xsl:when>
    <xsl:otherwise><xsl:apply-templates select="key('resource',mim:type/@rdf:resource)" mode="labelledlink"/></xsl:otherwise>
  </xsl:choose>
  <xsl:text>|&#xa;</xsl:text>
</xsl:template>

<xsl:template match="*" mode="meta-waarden">
  <xsl:variable name="waardelijst">
    <xsl:for-each select="key('resource',mim:type/@rdf:resource)">
      <xsl:for-each select="key('resource',mim:waarde/@rdf:nodeID)">
        <waarde><xsl:value-of select="rdfs:label"/></waarde>
      </xsl:for-each>
    </xsl:for-each>
  </xsl:variable>
  <xsl:if test="exists($waardelijst/waarde)">
    <xsl:text>|Mogelijke waarden|</xsl:text>
    <xsl:for-each select="$waardelijst/waarde">
      <xsl:if test="position()!=1"><xsl:text>; </xsl:text></xsl:if>
      <xsl:value-of select="."/>
    </xsl:for-each>
    <xsl:text>|&#xa;</xsl:text>
  </xsl:if>
</xsl:template>

<xsl:template match="*" mode="objecttypen">
  <xsl:apply-templates select="." mode="header2"/>
  <xsl:apply-templates select="." mode="table-def-header"/>
  <xsl:apply-templates select="." mode="meta-begrip"/>
  <xsl:apply-templates select="." mode="meta-supertype"/>
  <xsl:apply-templates select="." mode="meta-subtype"/>
  <xsl:apply-templates select="." mode="meta-definitie"/>
  <xsl:apply-templates select="." mode="meta-toelichting"/>
  <xsl:apply-templates select="." mode="meta-bron"/>
  <xsl:apply-templates select="." mode="meta-eigenschappen-kenmerken"/>
  <xsl:apply-templates select="." mode="meta-eigenschappen-rollen"/>
  <xsl:apply-templates select="." mode="meta-eigenschappen-relaties"/>
  <xsl:apply-templates select="key('resource',mim:attribuut/@rdf:resource)" mode="attribuutsoorten"/>
  <xsl:apply-templates select="key('rs-bron',@rdf:about)" mode="relatiesoorten"/>
</xsl:template>

<xsl:template match="*" mode="attribuutsoorten">
  <xsl:apply-templates select="." mode="header3"/>
  <xsl:apply-templates select="." mode="table-def-header"/>
  <xsl:apply-templates select="." mode="meta-begrip"/>
  <xsl:apply-templates select="." mode="meta-definitie"/>
  <xsl:apply-templates select="." mode="meta-toelichting"/>
  <xsl:apply-templates select="." mode="meta-bron"/>
  <xsl:apply-templates select="." mode="meta-eigenaar"/>
  <xsl:apply-templates select="." mode="meta-waardetype"/>
  <xsl:apply-templates select="." mode="meta-waarden"/>
</xsl:template>

<xsl:template match="*" mode="relatiesoorten">
  <xsl:apply-templates select="." mode="header3"/>
  <xsl:apply-templates select="." mode="table-def-header"/>
  <xsl:apply-templates select="." mode="meta-begrip"/>
  <xsl:apply-templates select="." mode="meta-definitie"/>
  <xsl:apply-templates select="." mode="meta-toelichting"/>
  <xsl:apply-templates select="." mode="meta-bron"/>
  <xsl:apply-templates select="." mode="meta-rolbron"/>
  <xsl:apply-templates select="." mode="meta-roldoel"/>
</xsl:template>

<xsl:template match="*" mode="enumeraties">
  <xsl:apply-templates select="." mode="header3"/>
  <xsl:text>De volgende waarden zijn mogelijk:&#x0a;</xsl:text>
  <xsl:for-each select="key('resource',mim:waarde/@rdf:nodeID)"><xsl:sort select="rdfs:label"/>
    <xsl:text>- </xsl:text>
    <xsl:choose>
      <xsl:when test="mim:begrip/@rdf:resource!=''">
        <xsl:text>[</xsl:text><xsl:value-of select="rdfs:label"/><xsl:text>]</xsl:text>
        <xsl:variable name="term-anchor"><xsl:apply-templates select="key('resource',mim:begrip/@rdf:resource)/rdfs:label" mode="lcase-anchor"/></xsl:variable>
        <xsl:choose>
          <!-- When info of begrip in this file, use it -->
          <xsl:when test="$term-anchor!=''"><xsl:text>(#</xsl:text><xsl:value-of select="$term-anchor"/><xsl:text>)</xsl:text></xsl:when>
          <!-- Otherwise: expect begrip in different document, use URI -->
          <xsl:otherwise><xsl:text>(</xsl:text><xsl:value-of select="mim:begrip/@rdf:resource"/><xsl:text>)</xsl:text></xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise><xsl:value-of select="rdfs:label"/></xsl:otherwise>
    </xsl:choose>
    <xsl:text>&#x0a;</xsl:text>
  </xsl:for-each>
</xsl:template>

<xsl:template match="*" mode="datatypes">
  <xsl:apply-templates select="." mode="header3"/>
  <xsl:apply-templates select="." mode="table-def-header"/>
  <xsl:apply-templates select="." mode="meta-begrip"/>
  <xsl:apply-templates select="." mode="meta-definitie"/>
  <xsl:apply-templates select="." mode="meta-toelichting"/>
  <xsl:apply-templates select="." mode="meta-superdatatype"/>
</xsl:template>

<xsl:template match="rdf:Description" mode="class-hierarchy-leaf">
  <xsl:param name="spaces"/>
  <xsl:value-of select="$spaces"/><xsl:text>- </xsl:text>
  <xsl:apply-templates select="." mode="labelledlink"/>
  <xsl:text>&#xa;</xsl:text>
  <xsl:variable name="uri" select="@rdf:about"/>
  <xsl:for-each select="../rdf:Description[rdf:type/@rdf:resource=$mim-objecttype and key('gen-sub',@rdf:about)/mim:supertype/@rdf:resource=$uri]"><xsl:sort select="concat(rdfs:label[@xml:lang=$lang],rdfs:label[1])"/>
    <xsl:apply-templates select="." mode="class-hierarchy-leaf"><xsl:with-param name="spaces"><xsl:value-of select="concat($spaces,'  ')"/></xsl:with-param></xsl:apply-templates>
  </xsl:for-each>
</xsl:template>

<xsl:template match="rdf:RDF" mode="class-hierarchy">
  <xsl:for-each select="rdf:Description[rdf:type/@rdf:resource=$mim-objecttype and not(exists(key('gen-sub',@rdf:about)))]"><xsl:sort select="concat(rdfs:label[@xml:lang=$lang],rdfs:label[1])"/>
    <xsl:apply-templates select="." mode="class-hierarchy-leaf"><xsl:with-param name="spaces"></xsl:with-param></xsl:apply-templates>
  </xsl:for-each>
</xsl:template>

<xsl:template match="rdf:Description" mode="informatiemodel">
  <xsl:text># CIM </xsl:text>
  <xsl:value-of select="rdfs:label"/>
  <xsl:text>&#x0a;&#x0a;</xsl:text>
  <xsl:text>![](</xsl:text>
  <xsl:apply-templates select="rdfs:label" mode="anchor"/>
  <xsl:text>.svg "Conceptueel informatiemodel </xsl:text>
  <xsl:value-of select="rdfs:label"/>
  <xsl:text>")&#xa;&#xa;</xsl:text>
</xsl:template>

<xsl:template match="/ROOT/rdf:RDF">
  <xsl:apply-templates select="rdf:Description[rdf:type/@rdf:resource=$mim-informatiemodel]" mode="informatiemodel"/>
  <xsl:apply-templates select="." mode="class-hierarchy"/>
  <xsl:for-each select="rdf:Description[rdf:type/@rdf:resource=$mim-objecttype]"><xsl:sort select="concat(rdfs:label[@xml:lang=$lang],rdfs:label[1])"/>
    <xsl:apply-templates select="." mode="objecttypen"/>
  </xsl:for-each>
  <xsl:text>&#x0a;## Waardetypering en referentielijsten&#x0a;</xsl:text>
  <xsl:for-each select="rdf:Description[rdf:type/@rdf:resource=$mim-primitiefdatatype]"><xsl:sort select="concat(rdfs:label[@xml:lang=$lang],rdfs:label[1])"/>
    <xsl:apply-templates select="." mode="datatypes"/>
  </xsl:for-each>
  <xsl:for-each select="rdf:Description[rdf:type/@rdf:resource=$mim-enumeratie]"><xsl:sort select="concat(rdfs:label[@xml:lang=$lang],rdfs:label[1])"/>
    <xsl:apply-templates select="." mode="enumeraties"/>
  </xsl:for-each>
</xsl:template>

</xsl:stylesheet>
