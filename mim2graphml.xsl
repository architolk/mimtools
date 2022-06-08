<xsl:stylesheet version="2.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
	xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
  xmlns:sh="http://www.w3.org/ns/shacl#"
  xmlns:mim="http://bp4mc2.org/def/mim#"
  xmlns:skos="http://www.w3.org/2004/02/skos/core#"
  xmlns:graphml="http://graphml.graphdrawing.org/xmlns"
  xmlns:y="http://www.yworks.com/xml/graphml"
>

<xsl:key name="items" match="/ROOT/rdf:RDF/rdf:Description" use="@rdf:about"/>
<xsl:key name="blanks" match="/ROOT/rdf:RDF/rdf:Description" use="@rdf:nodeID"/>
<xsl:key name="resources" match="/ROOT/rdf:RDF/rdf:Description" use="@rdf:about|@rdf:nodeID"/>
<xsl:key name="node-geo" match="/ROOT/graphml:graphml/graphml:graph/graphml:node" use="graphml:data[@key='d3']"/>
<xsl:key name="edge-geo" match="/ROOT/graphml:graphml/graphml:graph/graphml:edge" use="graphml:data[@key='d7']"/>

<xsl:variable name="params" select="/ROOT/@params"/>

<xsl:template match="rdf:Description" mode="label">
  <xsl:variable name="slabel"><xsl:value-of select="replace(@rdf:about|@rdf:nodeID,'^.*(#|/)([^(#|/)]+)$','$2')"/></xsl:variable>
  <xsl:choose>
    <xsl:when test="mim:naam!=''"><xsl:value-of select="mim:naam"/></xsl:when>
    <xsl:when test="rdfs:label!=''"><xsl:value-of select="rdfs:label"/></xsl:when>
    <xsl:when test="$slabel!=''"><xsl:value-of select="$slabel"/></xsl:when>
    <xsl:otherwise><xsl:value-of select="@rdf:about|@rdf:nodeID"/></xsl:otherwise>
  </xsl:choose>
</xsl:template>
<xsl:template match="*" mode="label">
  <xsl:choose>
    <xsl:when test="exists(key('resources',@rdf:resource|rdf:nodeID))"><xsl:apply-templates select="key('resources',@rdf:resource|rdf:nodeID)" mode="label"/></xsl:when>
    <xsl:otherwise><xsl:value-of select="replace(@rdf:resource|@rdf:nodeID,'^.*(#|/)([^(#|/)]+)$','$2')"/></xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="edge-label">
  <xsl:param name="label"/>
  <xsl:param name="ratio"/> <!-- 0.0 = start, 0.5 = center, 1.0 = end -->
  <xsl:param name="position"/> <!-- to the left/right of the arrow -->
  <xsl:param name="background"/> <!-- background color -->
  <y:EdgeLabel alignment="center" configuration="AutoFlippingLabel" distance="2.0" fontFamily="Dialog" fontSize="12" fontStyle="plain" hasLineColor="false" modelName="custom" preferredPlacement="anywhere" ratio="0.5" textColor="#000000" visible="true">
    <xsl:choose>
      <xsl:when test="$background!=''"><xsl:attribute name="backgroundColor"><xsl:value-of select="$background"/></xsl:attribute></xsl:when>
      <xsl:otherwise><xsl:attribute name="hasBackgroundColor">false</xsl:attribute></xsl:otherwise>
    </xsl:choose>
    <xsl:value-of select="$label"/><y:LabelModel>
    <y:SmartEdgeLabelModel autoRotationEnabled="false" defaultAngle="0.0" defaultDistance="10.0"/></y:LabelModel>
    <y:ModelParameter><y:SmartEdgeLabelModelParameter angle="0.0" distance="1.5" distanceToCenter="false" position="{$position}" ratio="{$ratio}" segment="0"/></y:ModelParameter>
    <y:PreferredPlacementDescriptor angle="0.0" angleOffsetOnRightSide="0" angleReference="absolute" angleRotationOnRightSide="co" distance="-1.0" frozen="true" placement="anywhere" side="anywhere" sideReference="relative_to_edge_flow"/>
  </y:EdgeLabel>
</xsl:template>

<xsl:template match="*" mode="property-label">
  <xsl:apply-templates select="." mode="label"/>
  <xsl:if test="mim:type/@rdf:resource!=''">
    <xsl:text>: </xsl:text>
    <xsl:apply-templates select="mim:type" mode="label"/>
  </xsl:if>
</xsl:template>

<xsl:template match="/">
	<graphml>
		<key attr.name="url" attr.type="string" for="node" id="d3"/>
    <key attr.name="statement-url" attr.type="string" for="edge" id="d7"/>
    <key attr.name="url" attr.type="string" for="edge" id="d8"/>
		<key for="node" id="d6" yfiles.type="nodegraphics"/>
		<key for="edge" id="d10" yfiles.type="edgegraphics"/>
		<graph id="G" edgedefault="directed">
			<xsl:apply-templates select="ROOT/rdf:RDF"/>
		</graph>
	</graphml>
</xsl:template>

<xsl:template match="rdf:RDF">
  <xsl:apply-templates select="rdf:Description[rdf:type/@rdf:resource='http://bp4mc2.org/def/mim#Objecttype']" mode="node"/>
  <xsl:apply-templates select="rdf:Description[rdf:type/@rdf:resource='http://bp4mc2.org/def/mim#Keuze']" mode="node"/>
  <xsl:apply-templates select="rdf:Description[rdf:type/@rdf:resource='http://bp4mc2.org/def/mim#Enumeratie']" mode="node"/>
  <xsl:apply-templates select="rdf:Description[rdf:type/@rdf:resource='http://bp4mc2.org/def/mim#GestructureerdDatatype']" mode="node"/>
  <xsl:apply-templates select="rdf:Description[rdf:type/@rdf:resource='http://bp4mc2.org/def/mim#Relatiesoort']" mode="edge"/>
  <xsl:apply-templates select="rdf:Description[rdf:type/@rdf:resource='http://bp4mc2.org/def/mim#Keuze']" mode="edge"/>
</xsl:template>

<xsl:template match="rdf:Description" mode="node">
  <xsl:variable name="geo" select="key('node-geo',@rdf:about)"/>
  <xsl:if test="not($params='follow') or exists($geo/graphml:data)">
    <node id="{@rdf:about}">
  		<data key="d3"><xsl:value-of select="@rdf:about"/></data>
  		<data key="d6">
  			<y:UMLClassNode>
          <xsl:variable name="geo" select="key('node-geo',@rdf:about)"/>
          <xsl:choose>
            <xsl:when test="exists($geo/graphml:data/*/y:Geometry)"><xsl:copy-of select="$geo/graphml:data/*/y:Geometry"/></xsl:when>
  				  <xsl:otherwise><y:Geometry height="90.0" width="80.0" x="637.0" y="277.0"/></xsl:otherwise>
          </xsl:choose>
          <y:Fill color="#ffffc7" transparent="false"/>
          <y:BorderStyle color="#000000" type="line" width="1.0"/>
          <y:NodeLabel alignment="center" autoSizePolicy="node_width" fontFamily="Dialog" fontSize="13" fontStyle="bold" hasBackgroundColor="false" hasLineColor="false" height="25" horizontalTextPosition="center" iconTextGap="4" modelName="internal" modelPosition="t" textColor="#000000" verticalTextPosition="bottom" visible="true" width="57.9931640625" x="33.50341796875" y="0.0">
  					<xsl:apply-templates select="." mode="label"/>
          </y:NodeLabel>
          <y:UML clipContent="true" constraint="" detailsColor="#000000" omitDetails="false" stereotype="{replace(rdf:type/@rdf:resource,'^.*(#|/)([^(#|/)]+)$','$2')}" use3DEffect="false">
            <y:AttributeLabel>
              <!-- Properties -->
    					<xsl:for-each select="key('resources',(mim:attribuut|mim:waarde|mim:dataElement)/(@rdf:nodeID|@rdf:resource))">
                <xsl:variable name="object-uri"><xsl:value-of select="(sh:node|sh:class)/@rdf:resource"/></xsl:variable>
                <xsl:variable name="object-geo" select="key('node-geo',$object-uri)"/>
                <xsl:if test="not(exists(key('items',$object-uri))) or ($params='follow' and not(exists($object-geo/graphml:data)))">
                  <xsl:apply-templates select="." mode="property-label"/><xsl:text>
</xsl:text>
                </xsl:if>
    					</xsl:for-each>
            </y:AttributeLabel>
            <y:MethodLabel />
          </y:UML>
        </y:UMLClassNode>
  		</data>
  	</node>
  </xsl:if>
</xsl:template>

<xsl:template match="rdf:Description" mode="edge">
  <xsl:variable name="subject-uri">
    <xsl:choose>
      <xsl:when test="mim:bron/@rdf:resource!=''"><xsl:value-of select="mim:bron/@rdf:resource"/></xsl:when>
      <xsl:otherwise><xsl:value-of select="@rdf:about"/></xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:if test="exists(key('items',$subject-uri))">
    <xsl:for-each select="mim:doel[exists(key('items',@rdf:resource))]">
      <xsl:variable name="object-uri" select="@rdf:resource"/>
      <xsl:variable name="subject-geo" select="key('node-geo',$subject-uri)"/>
      <xsl:if test="not($params='follow') or exists($subject-geo/graphml:data)">
        <!-- Associations -->
        <xsl:variable name="object-geo" select="key('node-geo',$object-uri)"/>
        <xsl:variable name="property-uri"><xsl:value-of select="@rdf:about|@rdf:nodeID"/></xsl:variable>
        <xsl:variable name="statement-uri">urn:md5:<xsl:value-of select="concat($subject-uri,$property-uri,$object-uri)"/></xsl:variable>
        <xsl:variable name="statement-geo" select="key('edge-geo',$statement-uri)"/>
        <xsl:if test="not($params='follow') or exists($object-geo/graphml:data)">
          <edge source="{$subject-uri}" target="{$object-uri}">
            <data key="d7"><xsl:value-of select="$statement-uri"/></data>
            <data key="d8"><xsl:value-of select="$property-uri"/></data>
      			<data key="d10">
      				<y:PolyLineEdge>
                <xsl:copy-of select="$statement-geo/graphml:data/y:PolyLineEdge/y:Path"/>
      					<y:LineStyle color="#000000" type="line" width="1.0"/>
      					<y:Arrows source="none" target="plain"/>
                <xsl:if test="../rdf:type/@rdf:resource!='http://bp4mc2.org/def/mim#Keuze'">
                  <xsl:call-template name="edge-label">
                    <xsl:with-param name="label"><xsl:apply-templates select=".." mode="label"/></xsl:with-param>
                    <xsl:with-param name="ratio">0.5</xsl:with-param>
                    <xsl:with-param name="position">left</xsl:with-param>
                  </xsl:call-template>
                </xsl:if>
                <xsl:call-template name="edge-label">
                  <xsl:with-param name="label">«<xsl:apply-templates select="../rdf:type" mode="label"/>»</xsl:with-param>
                  <xsl:with-param name="ratio">0.5</xsl:with-param>
                  <xsl:with-param name="position">right</xsl:with-param>
                </xsl:call-template>
                <xsl:if test="../mim:kardinaliteit!='' and not(key('items',../mim:relatierol/@rdf:resource)[rdf:type/@rdf:resource='http://bp4mc2.org/def/mim#RelatierolDoel']/mim:kardinaliteit!='')">
                  <xsl:call-template name="edge-label">
                    <xsl:with-param name="label"><xsl:value-of select="../mim:kardinaliteit"/></xsl:with-param>
                    <xsl:with-param name="ratio">1.0</xsl:with-param>
                    <xsl:with-param name="position">left</xsl:with-param>
                  </xsl:call-template>
                </xsl:if>
                <xsl:for-each select="key('resources',../mim:relatierol/(@rdf:resource|@rdf:nodeID))[rdf:type/@rdf:resource='http://bp4mc2.org/def/mim#RelatierolBron']">
                  <xsl:call-template name="edge-label">
                    <xsl:with-param name="label"><xsl:apply-templates select="." mode="label"/></xsl:with-param>
                    <xsl:with-param name="ratio">0.0</xsl:with-param>
                    <xsl:with-param name="position">left</xsl:with-param>
                  </xsl:call-template>
                  <xsl:if test="mim:kardinaliteit!=''">
                    <xsl:call-template name="edge-label">
                      <xsl:with-param name="label"><xsl:value-of select="mim:kardinaliteit"/></xsl:with-param>
                      <xsl:with-param name="ratio">0.0</xsl:with-param>
                      <xsl:with-param name="position">right</xsl:with-param>
                    </xsl:call-template>
                  </xsl:if>
                </xsl:for-each>
                <xsl:for-each select="key('resources',../mim:relatierol/(@rdf:resource|@rdf:nodeID))[rdf:type/@rdf:resource='http://bp4mc2.org/def/mim#RelatierolDoel']">
                  <xsl:call-template name="edge-label">
                    <xsl:with-param name="label"><xsl:apply-templates select="." mode="label"/></xsl:with-param>
                    <xsl:with-param name="ratio">1.0</xsl:with-param>
                    <xsl:with-param name="position">left</xsl:with-param>
                  </xsl:call-template>
                  <xsl:if test="mim:kardinaliteit!=''">
                    <xsl:call-template name="edge-label">
                      <xsl:with-param name="label"><xsl:value-of select="mim:kardinaliteit"/></xsl:with-param>
                      <xsl:with-param name="ratio">1.0</xsl:with-param>
                      <xsl:with-param name="position">right</xsl:with-param>
                    </xsl:call-template>
                  </xsl:if>
                </xsl:for-each>
      					<y:BendStyle smoothed="false"/>
      				</y:PolyLineEdge>
      			</data>
      		</edge>
        </xsl:if>
      </xsl:if>
    </xsl:for-each>
  </xsl:if>
</xsl:template>

</xsl:stylesheet>
