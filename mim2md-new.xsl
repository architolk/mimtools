<xsl:stylesheet version="2.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
	xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
  xmlns:mim="http://modellen.mim-standaard.nl/def/mim#"
>

<xsl:output method="text"/>

<xsl:variable name="mim">http://modellen.mim-standaard.nl/def/mim#</xsl:variable>
<xsl:variable name="mim-objecttype"><xsl:value-of select="$mim"/>Objecttype</xsl:variable>
<xsl:variable name="mim-relatiesoort"><xsl:value-of select="$mim"/>Relatiesoort</xsl:variable>
<xsl:variable name="mim-generalisatie"><xsl:value-of select="$mim"/>Generalisatie</xsl:variable>
<xsl:variable name="mim-relatieklasse"><xsl:value-of select="$mim"/>Relatieklasse</xsl:variable>
<xsl:variable name="mim-externekoppeling"><xsl:value-of select="$mim"/>ExterneKoppeling</xsl:variable>
<xsl:variable name="mim-informatiemodel"><xsl:value-of select="$mim"/>Informatiemodel</xsl:variable>
<xsl:variable name="mim-domein"><xsl:value-of select="$mim"/>Domein</xsl:variable>
<xsl:variable name="mim-relatierolbron"><xsl:value-of select="$mim"/>RelatierolBron</xsl:variable>
<xsl:variable name="mim-relatieroldoel"><xsl:value-of select="$mim"/>RelatierolDoel</xsl:variable>
<xsl:variable name="mim-referentielijst"><xsl:value-of select="$mim"/>Referentielijst</xsl:variable>
<xsl:variable name="mim-codelijst"><xsl:value-of select="$mim"/>Codelijst</xsl:variable>
<xsl:variable name="mim-enumeratie"><xsl:value-of select="$mim"/>Enumeratie</xsl:variable>
<xsl:variable name="mim-primitiefdatatype"><xsl:value-of select="$mim"/>PrimitiefDatatype</xsl:variable>
<xsl:variable name="mim-gestructureerddatatype"><xsl:value-of select="$mim"/>GestructureerdDatatype</xsl:variable>
<xsl:variable name="mim-keuze"><xsl:value-of select="$mim"/>Keuze</xsl:variable>

<xsl:key name="item" match="/ROOT/rdf:RDF/rdf:Description" use="@rdf:about|@rdf:nodeID"/>
<xsl:key name="relatie" match="/ROOT/rdf:RDF/rdf:Description" use="(mim:bron|mim:doel|mim:subtype|mim:supertype)/@rdf:resource"/>

<!-- ================ -->
<!-- Helper templates -->
<!-- ================ -->

<xsl:template match="rdf:Description" mode="label">
  <xsl:choose>
    <xsl:when test="mim:naam[1]!=''"><xsl:value-of select="mim:naam[1]"/></xsl:when>
    <xsl:otherwise><xsl:value-of select="rdfs:label[1]"/></xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="rdf:Description" mode="link">
  <xsl:text>[</xsl:text><xsl:apply-templates select="." mode="label"/><xsl:text>]</xsl:text>
  <xsl:text>(</xsl:text><xsl:text>)</xsl:text>
</xsl:template>

<xsl:template match="*" mode="link">
  <xsl:apply-templates select="key('item',@rdf:resource|@rdf:nodeID)[1]" mode="link"/>
</xsl:template>

<xsl:template match="*" mode="truncate">
  <xsl:value-of select="tokenize(.,'\n')[1]"/>
</xsl:template>

<xsl:template match="*" mode="card">
  <xsl:choose>
    <xsl:when test=".='1..1'">1</xsl:when>
    <xsl:when test=".='0..-1'">0..*</xsl:when>
    <xsl:when test=".='1..-1'">1..*</xsl:when>
    <xsl:otherwise><xsl:value-of select="."/></xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- ========== -->
<!-- Tabelrijen -->
<!-- ========== -->

<xsl:template match="rdf:Description" mode="tabel-attribuut">
  <xsl:param name="nesting"/>
  <xsl:text>|</xsl:text><xsl:value-of select="$nesting"/>
  <xsl:apply-templates select="." mode="label"/>
  <xsl:for-each select="key('item',mim:gegevensgroeptype/@rdf:resource)">
    <xsl:text> (</xsl:text><xsl:apply-templates select="." mode="label"/><xsl:text>):</xsl:text>
  </xsl:for-each>
  <xsl:text>|</xsl:text>
  <xsl:apply-templates select="mim:definitie" mode="truncate"/>
  <xsl:text>|</xsl:text>
  <xsl:apply-templates select="mim:type" mode="link"/>
  <xsl:text>|</xsl:text>
  <xsl:apply-templates select="mim:kardinaliteit" mode="card"/>
  <xsl:text>|&#xa;</xsl:text>
  <!-- Voor geneste attribuutsoorten -->
  <xsl:for-each select="key('item',mim:gegevensgroeptype/@rdf:resource)">
    <xsl:apply-templates select="key('item',(mim:attribuut|mim:gegevensgroep)/@rdf:resource)" mode="tabel-attribuut">
      <xsl:with-param name="nesting">- </xsl:with-param>
    </xsl:apply-templates>
  </xsl:for-each>
</xsl:template>

<xsl:template match="rdf:Description" mode="tabel-element">
  <xsl:text>|</xsl:text>
  <xsl:apply-templates select="." mode="label"/>
  <xsl:text>|</xsl:text>
  <xsl:apply-templates select="mim:definitie" mode="truncate"/>
  <xsl:text>|</xsl:text>
  <xsl:apply-templates select="mim:type" mode="link"/>
  <xsl:text>|</xsl:text>
  <xsl:apply-templates select="mim:kardinaliteit" mode="card"/>
  <xsl:text>|&#xa;</xsl:text>
</xsl:template>

<xsl:template match="rdf:Description" mode="tabel-waarde">
  <xsl:text>|</xsl:text>
  <xsl:apply-templates select="." mode="label"/>
  <xsl:text>|</xsl:text>
  <xsl:apply-templates select="mim:definitie" mode="truncate"/>
  <xsl:text>|&#xa;</xsl:text>
</xsl:template>

<xsl:template match="rdf:Description[rdf:type/@rdf:resource=($mim-relatiesoort,$mim-relatieklasse,$mim-externekoppeling)]" mode="tabel-relatie">
  <xsl:text>|</xsl:text>
  <xsl:apply-templates select="mim:bron" mode="link"/>
  <xsl:text> </xsl:text>
  <xsl:apply-templates select="." mode="label"/>
  <xsl:text> </xsl:text>
  <xsl:apply-templates select="key('item',mim:relatierol/@rdf:resource)[rdf:type/@rdf:resource=$mim-relatieroldoel]" mode="label"/>
  <xsl:text> </xsl:text>
  <xsl:apply-templates select="mim:doel" mode="link"/>
  <xsl:text> [</xsl:text><xsl:apply-templates select="mim:kardinaliteit" mode="card"/><xsl:text>]</xsl:text>
  <xsl:text>|</xsl:text>
  <xsl:apply-templates select="mim:definitie" mode="truncate"/>
  <xsl:text>|&#xa;</xsl:text>
</xsl:template>

<xsl:template match="rdf:Description[rdf:type/@rdf:resource=$mim-keuze]" mode="tabel-relatie">
  <xsl:param name="startpunt"/>
  <xsl:variable name="keuze" select="@rdf:about"/>
  <xsl:for-each select="key('relatie',$keuze)[mim:doel/@rdf:resource=$keuze]">
    <xsl:text>|</xsl:text>
    <xsl:apply-templates select="mim:bron" mode="link"/>
    <xsl:text> </xsl:text>
    <xsl:apply-templates select="." mode="label"/>
    <xsl:text> </xsl:text>
    <xsl:apply-templates select="$startpunt" mode="link"/>
    <xsl:text> [</xsl:text><xsl:apply-templates select="mim:kardinaliteit" mode="card"/><xsl:text>]</xsl:text>
    <xsl:text>|</xsl:text>
    <xsl:apply-templates select="mim:definitie" mode="truncate"/>
    <xsl:text>|&#xa;</xsl:text>
  </xsl:for-each>
</xsl:template>

<xsl:template match="rdf:Description[rdf:type/@rdf:resource=$mim-generalisatie]" mode="tabel-relatie">
  <xsl:text>|</xsl:text>
  <xsl:apply-templates select="mim:subtype" mode="link"/>
  <xsl:text> is specialisatie van </xsl:text>
  <xsl:apply-templates select="mim:supertype" mode="link"/>
  <xsl:text>|</xsl:text>
  <xsl:apply-templates select="mim:definitie" mode="truncate"/>
  <xsl:text>|&#xa;</xsl:text>
</xsl:template>

<!-- Failsafe -->
<xsl:template match="rdf:Description" mode="tabel-relatie">
  <xsl:text>|TODO|</xsl:text>
  <xsl:value-of select="rdf:type/@rdf:resource"/>
  <xsl:text>|&#xa;</xsl:text>
</xsl:template>

<!-- ======================== -->
<!-- Model property templates -->
<!-- ======================== -->

<xsl:template match="mim:naam|mim:label" mode="property">
  <xsl:if test="local-name()!='label' or not(exists(../mim:naam))">
    <xsl:text>|Naam|</xsl:text>
    <xsl:apply-templates select=".." mode="label"/>
    <xsl:text>|&#xa;</xsl:text>
  </xsl:if>
</xsl:template>

<xsl:template match="mim:herkomst" mode="property">
  <xsl:text>|Herkomst|</xsl:text>
  <xsl:value-of select="."/>
  <xsl:text>|&#xa;</xsl:text>
</xsl:template>

<xsl:template match="mim:definitie" mode="property">
  <xsl:text>|Definitie|</xsl:text>
  <xsl:apply-templates select="." mode="truncate"/>
  <xsl:text>|&#xa;</xsl:text>
</xsl:template>

<xsl:template match="mim:herkomstDefinitie" mode="property">
  <xsl:text>|Herkomst definitie|</xsl:text>
  <xsl:value-of select="."/>
  <xsl:text>|&#xa;</xsl:text>
</xsl:template>

<xsl:template match="mim:indicatieAbstractObject" mode="property">
  <xsl:text>|Indicatie abstract object|</xsl:text>
  <xsl:if test=".='true'">Ja</xsl:if>
  <xsl:if test=".='false'">Nee</xsl:if>
  <xsl:text>|&#xa;</xsl:text>
</xsl:template>

<xsl:template match="mim:unidirectioneel" mode="property">
  <xsl:text>|Unidirectioneel|</xsl:text>
  <xsl:if test=".='true'">Ja</xsl:if>
  <xsl:if test=".='false'">Nee</xsl:if>
  <xsl:text>|&#xa;</xsl:text>
</xsl:template>

<xsl:template match="mim:datumOpname" mode="property">
  <xsl:text>|Datum opname|</xsl:text>
  <xsl:value-of select="."/>
  <xsl:text>|&#xa;</xsl:text>
</xsl:template>

<xsl:template match="mim:populatie" mode="property">
  <xsl:text>|Populatie|</xsl:text>
  <xsl:value-of select="."/>
  <xsl:text>|&#xa;</xsl:text>
</xsl:template>

<xsl:template match="mim:patroon" mode="property">
  <xsl:text>|Patroon|</xsl:text>
  <xsl:value-of select="."/>
  <xsl:text>|&#xa;</xsl:text>
</xsl:template>

<xsl:template match="mim:formeelPatroon" mode="property">
  <xsl:text>|Formeel patroon|</xsl:text>
  <xsl:value-of select="."/>
  <xsl:text>|&#xa;</xsl:text>
</xsl:template>

<xsl:template match="mim:locatie" mode="property">
  <xsl:text>|Locatie|</xsl:text>
  <xsl:value-of select="."/>
  <xsl:text>|&#xa;</xsl:text>
</xsl:template>

<xsl:template match="mim:attribuut|rdf:type|mim:gegevensgroep|mim:bron|mim:doel|mim:relatierol|mim:type|mim:dataElement|mim:referentieElement|mim:waarde" mode="property">
  <!-- Handled otherwise -->
</xsl:template>

<!-- Failsafe, for unparsed items -->
<xsl:template match="*" mode="property">
  <xsl:text>|TODO: </xsl:text>
  <xsl:value-of select="local-name()"/>
  <xsl:text>|</xsl:text>
  <xsl:apply-templates select="." mode="truncate"/><xsl:value-of select="@rdf:resource|@rdf:nodeID"/>
  <xsl:text>|&#xa;</xsl:text>
</xsl:template>

<!-- ======================= -->
<!-- Model element templates -->
<!-- ======================= -->

<xsl:template match="rdf:Description[rdf:type/@rdf:resource=$mim-informatiemodel]" mode="parse">
  <xsl:text># Model </xsl:text>
  <xsl:apply-templates select="." mode="label"/>
  <xsl:text>&#xa;&#xa;</xsl:text>
  <!-- HIER MOET EIGENLIJK NOG IETS MET EEN PLAATJE -->
  <xsl:for-each select="key('item',mim:bevatModelelement/@rdf:resource)"><xsl:sort select="mim:naam[1]|rdfs:label[1]"/>
    <xsl:apply-templates select="." mode="parse"/>
  </xsl:for-each>
</xsl:template>

<xsl:template match="rdf:Description[rdf:type/@rdf:resource=$mim-domein]" mode="parse">
  <xsl:text>## Domein </xsl:text>
  <xsl:apply-templates select="." mode="label"/>
  <xsl:text>&#xa;&#xa;</xsl:text>
  <!-- HIER MOET EIGENLIJK NOG IETS MET EEN PLAATJE -->
  <xsl:for-each select="key('item',mim:bevatModelelement/@rdf:resource)[rdf:type/@rdf:resource=($mim-objecttype,$mim-relatieklasse)]"><xsl:sort select="mim:naam[1]|rdfs:label[1]"/>
    <xsl:if test="position()=1"><xsl:text>## Objecttypes en relatieklassen&#xa;&#xa;</xsl:text></xsl:if>
    <xsl:apply-templates select="." mode="parse"/>
  </xsl:for-each>
  <xsl:for-each select="key('item',mim:bevatModelelement/@rdf:resource)[rdf:type/@rdf:resource=($mim-keuze,$mim-primitiefdatatype,$mim-gestructureerddatatype)]"><xsl:sort select="mim:naam[1]|rdfs:label[1]"/>
    <xsl:if test="position()=1"><xsl:text>## Datatypes&#xa;&#xa;</xsl:text></xsl:if>
    <xsl:apply-templates select="." mode="parse"/>
  </xsl:for-each>
  <xsl:for-each select="key('item',mim:bevatModelelement/@rdf:resource)[rdf:type/@rdf:resource=($mim-referentielijst,$mim-enumeratie,$mim-codelijst)]"><xsl:sort select="mim:naam[1]|rdfs:label[1]"/>
    <xsl:if test="position()=1"><xsl:text>## Lijsten&#xa;&#xa;</xsl:text></xsl:if>
    <xsl:apply-templates select="." mode="parse"/>
  </xsl:for-each>
  <!-- Completeness check - only for debug -->
  <!--
  <xsl:for-each-group select="key('item',mim:bevatModelelement/@rdf:resource)" group-by="rdf:type/@rdf:resource">
    <xsl:text>> FOUND: </xsl:text><xsl:value-of select="rdf:type/@rdf:resource"/><xsl:text>&#xa;</xsl:text>
  </xsl:for-each-group>
  -->
</xsl:template>

<xsl:template match="rdf:Description[rdf:type/@rdf:resource=($mim-objecttype,$mim-relatieklasse)]" mode="parse">
  <xsl:text>### </xsl:text>
  <xsl:apply-templates select="." mode="label"/>
  <xsl:if test="rdf:type/@rdf:resource=$mim-relatieklasse">
    <xsl:text> (relatieklasse)</xsl:text>
  </xsl:if>
  <xsl:text>&#xa;&#xa;</xsl:text>
  <xsl:text>|{: .def}||&#xa;</xsl:text>
  <xsl:text>|-|-|&#xa;</xsl:text>
  <xsl:apply-templates select="*" mode="property"/>
  <xsl:text>&#xa;</xsl:text>
  <xsl:if test="exists(mim:attribuut)">
    <xsl:text>|Attribuut|Definitie|Formaat|Card|&#xa;</xsl:text>
    <xsl:text>|---------|---------|-------|----|&#xa;</xsl:text>
    <xsl:apply-templates select="key('item',(mim:attribuut|mim:gegevensgroep)/@rdf:resource)" mode="tabel-attribuut"/>
    <xsl:text>&#xa;</xsl:text>
  </xsl:if>
  <xsl:if test="exists(key('relatie',@rdf:about))">
    <xsl:text>|Relatie|Definitie&#xa;</xsl:text>
    <xsl:text>|-------|---------|&#xa;</xsl:text>
    <xsl:apply-templates select="key('relatie',@rdf:about)" mode="tabel-relatie">
      <xsl:with-param name="startpunt" select="."/>
    </xsl:apply-templates>
    <xsl:text>&#xa;</xsl:text>
  </xsl:if>
</xsl:template>

<xsl:template match="rdf:Description[rdf:type/@rdf:resource=($mim-primitiefdatatype,$mim-gestructureerddatatype,$mim-keuze)]" mode="parse">
  <xsl:if test="rdf:type/@rdf:resource!=$mim-keuze or exists(mim:type)">
    <xsl:text>### </xsl:text>
    <xsl:apply-templates select="." mode="label"/>
    <xsl:text>&#xa;&#xa;</xsl:text>
    <xsl:text>|{: .def}||&#xa;</xsl:text>
    <xsl:text>|-|-|&#xa;</xsl:text>
    <xsl:apply-templates select="*" mode="property"/>
    <xsl:if test="rdf:type/@rdf:resource=$mim-keuze">
      <xsl:text>|Keuze tussen|</xsl:text>
      <xsl:for-each select="key('item',mim:type/@rdf:resource)">
        <xsl:if test="position()!=1"><xsl:text>, </xsl:text></xsl:if>
        <xsl:apply-templates select="." mode="link"/>
      </xsl:for-each>
      <xsl:text>|&#xa;</xsl:text>
    </xsl:if>
    <xsl:text>&#xa;</xsl:text>
    <xsl:if test="exists(mim:dataElement)">
      <xsl:text>|Data-element|Definitie|Formaat|Card|&#xa;</xsl:text>
      <xsl:text>|------------|---------|-------|----|&#xa;</xsl:text>
      <xsl:apply-templates select="key('item',mim:dataElement/@rdf:resource)" mode="tabel-element"/>
      <xsl:text>&#xa;</xsl:text>
    </xsl:if>
  </xsl:if>
</xsl:template>

<xsl:template match="rdf:Description[rdf:type/@rdf:resource=($mim-codelijst,$mim-enumeratie,$mim-referentielijst)]" mode="parse">
  <xsl:if test="rdf:type/@rdf:resource!=$mim-keuze or exists(mim:type)">
    <xsl:text>### </xsl:text>
    <xsl:apply-templates select="." mode="label"/>
    <xsl:text>&#xa;&#xa;</xsl:text>
    <xsl:text>|{: .def}||&#xa;</xsl:text>
    <xsl:text>|-|-|&#xa;</xsl:text>
    <xsl:apply-templates select="*" mode="property"/>
    <xsl:text>&#xa;</xsl:text>
    <xsl:if test="exists(mim:referentieElement)">
      <xsl:text>|Referentie-element|Definitie|Formaat|Card|&#xa;</xsl:text>
      <xsl:text>|------------------|---------|-------|----|&#xa;</xsl:text>
      <xsl:apply-templates select="key('item',mim:referentieElement/@rdf:resource)" mode="tabel-element"/>
      <xsl:text>&#xa;</xsl:text>
    </xsl:if>
    <xsl:if test="exists(mim:waarde)">
      <xsl:text>|Waarde|Definitie|&#xa;</xsl:text>
      <xsl:text>|------|---------|&#xa;</xsl:text>
      <xsl:apply-templates select="key('item',mim:waarde/@rdf:resource)" mode="tabel-waarde"/>
      <xsl:text>&#xa;</xsl:text>
    </xsl:if>
  </xsl:if>
</xsl:template>

<!-- Failsafe, for unparsed items -->
<xsl:template match="rdf:Description" mode="parse">
  <xsl:text>> TODO ELEMENT: </xsl:text>
  <xsl:value-of select="rdf:type/@rdf:resource"/>
  <xsl:text>&#xa;&#xa;</xsl:text>
</xsl:template>

<!-- ================ -->
<!-- ROOT Entry point -->
<!-- ================ -->

<xsl:template match="/ROOT/rdf:RDF">
  <xsl:for-each select="rdf:Description[rdf:type/@rdf:resource=$mim-informatiemodel]"><xsl:sort select="mim:naam[1]|rdfs:label[1]"/>
    <xsl:apply-templates select="." mode="parse"/>
  </xsl:for-each>
  <!-- Completeness check - only for debug -->
  <!--
  <xsl:for-each-group select="rdf:Description" group-by="rdf:type/@rdf:resource">
    <xsl:text>> FOUND: </xsl:text><xsl:value-of select="rdf:type/@rdf:resource"/><xsl:text>&#xa;</xsl:text>
  </xsl:for-each-group>
  -->
</xsl:template>

</xsl:stylesheet>
