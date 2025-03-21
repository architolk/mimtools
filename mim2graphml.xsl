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
  <xsl:if test="mim:kardinaliteit!='' and mim:kardinaliteit!='1..1'">
    <xsl:text> [</xsl:text><xsl:value-of select="mim:kardinaliteit"/><xsl:text>]</xsl:text>
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
  <xsl:apply-templates select="rdf:Description[rdf:type/@rdf:resource='http://bp4mc2.org/def/mim#Codelijst']" mode="node"/>
  <xsl:apply-templates select="rdf:Description[rdf:type/@rdf:resource='http://bp4mc2.org/def/mim#GestructureerdDatatype']" mode="node"/>
  <xsl:apply-templates select="rdf:Description[rdf:type/@rdf:resource='http://bp4mc2.org/def/mim#Referentielijst']" mode="node"/>
  <xsl:apply-templates select="rdf:Description[rdf:type/@rdf:resource='http://bp4mc2.org/def/mim#Relatieklasse']" mode="node"/>
	<xsl:apply-templates select="rdf:Description[rdf:type/@rdf:resource='http://bp4mc2.org/def/mim#Gegevensgroeptype']" mode="node"/>
  <xsl:apply-templates select="rdf:Description[rdf:type/@rdf:resource='http://bp4mc2.org/def/mim#Relatiesoort']" mode="edge"/>
  <xsl:apply-templates select="rdf:Description[rdf:type/@rdf:resource='http://bp4mc2.org/def/mim#Relatieklasse']" mode="edge"/>
  <xsl:apply-templates select="rdf:Description[rdf:type/@rdf:resource='http://bp4mc2.org/def/mim#Generalisatie']" mode="edge-gen"/>
  <xsl:apply-templates select="rdf:Description[rdf:type/@rdf:resource='http://bp4mc2.org/def/mim#Keuze']" mode="edge"/>
</xsl:template>

<xsl:template match="rdf:Description" mode="node">
  <xsl:variable name="subject-uri" select="@rdf:about"/>
  <xsl:variable name="geo" select="key('node-geo',$subject-uri)"/>
  <xsl:if test="not($params='follow') or exists($geo/graphml:data)">
    <node id="{$subject-uri}">
  		<data key="d3"><xsl:value-of select="@rdf:about"/></data>
  		<data key="d6">
  			<y:UMLClassNode>
          <xsl:variable name="geo" select="key('node-geo',@rdf:about)"/>
          <xsl:choose>
            <xsl:when test="exists($geo/graphml:data/*/y:Geometry)"><xsl:copy-of select="$geo/graphml:data/*/y:Geometry"/></xsl:when>
  				  <xsl:otherwise><y:Geometry height="90.0" width="80.0" x="637.0" y="277.0"/></xsl:otherwise>
          </xsl:choose>
          <xsl:choose>
            <xsl:when test="exists($geo/graphml:data/*/y:Fill)"><xsl:copy-of select="$geo/graphml:data/*/y:Fill"/></xsl:when>
            <xsl:otherwise><y:Fill color="#ffffc7" transparent="false"/></xsl:otherwise>
          </xsl:choose>
          <y:BorderStyle color="#000000" type="line" width="1.0"/>
          <y:NodeLabel alignment="center" autoSizePolicy="node_width" fontFamily="Dialog" fontSize="13" fontStyle="bold" hasBackgroundColor="false" hasLineColor="false" height="25" horizontalTextPosition="center" iconTextGap="4" modelName="internal" modelPosition="t" textColor="#000000" verticalTextPosition="bottom" visible="true" width="57.9931640625" x="33.50341796875" y="0.0">
  					<xsl:apply-templates select="." mode="label"/>
          </y:NodeLabel>
          <y:UML clipContent="true" constraint="" detailsColor="#000000" omitDetails="false" stereotype="{replace(rdf:type/@rdf:resource,'^.*(#|/)([^(#|/)]+)$','$2')}" use3DEffect="false">
            <y:AttributeLabel>
              <!-- Properties -->
    					<xsl:for-each select="key('resources',(mim:attribuut|mim:waarde|mim:dataElement|mim:referentieElement)/(@rdf:nodeID|@rdf:resource))">
                <xsl:apply-templates select="." mode="property-label"/><xsl:text>
</xsl:text>
    					</xsl:for-each>
            </y:AttributeLabel>
            <y:MethodLabel />
          </y:UML>
        </y:UMLClassNode>
  		</data>
  	</node>
  </xsl:if>
  <!-- Link to DataType elements -->
  <xsl:for-each select="key('resources',(mim:attribuut|mim:waarde|mim:dataElement)/(@rdf:nodeID|@rdf:resource))">
    <xsl:for-each select="key('resources',mim:type/@rdf:resource)[rdf:type/@rdf:resource='http://bp4mc2.org/def/mim#Enumeratie' or rdf:type/@rdf:resource='http://bp4mc2.org/def/mim#GestructureerdDatatype' or rdf:type/@rdf:resource='http://bp4mc2.org/def/mim#Keuze' or rdf:type/@rdf:resource='http://bp4mc2.org/def/mim#Referentielijst' or rdf:type/@rdf:resource='http://bp4mc2.org/def/mim#Codelijst']">
      <xsl:variable name="object-uri" select="@rdf:about"/>
      <xsl:variable name="object-geo" select="key('node-geo',$object-uri)"/>
      <xsl:variable name="property-uri">mim:type</xsl:variable>
      <xsl:variable name="statement-uri">urn:md5:<xsl:value-of select="concat($subject-uri,$property-uri,$object-uri)"/></xsl:variable>
      <xsl:variable name="statement-geo" select="key('edge-geo',$statement-uri)"/>
      <xsl:if test="not($params='follow') or exists($object-geo/graphml:data)">
        <edge source="{$subject-uri}" target="{$object-uri}">
          <data key="d7"><xsl:value-of select="$statement-uri"/></data>
          <data key="d8"><xsl:value-of select="$property-uri"/></data>
          <data key="d10">
            <y:PolyLineEdge>
              <xsl:copy-of select="$statement-geo/graphml:data/y:PolyLineEdge/y:Path"/>
              <y:LineStyle color="#000000" type="dashed" width="1.0"/>
              <y:Arrows source="none" target="plain"/>
              <y:BendStyle smoothed="false"/>
            </y:PolyLineEdge>
          </data>
        </edge>
      </xsl:if>
    </xsl:for-each>
  </xsl:for-each>
</xsl:template>

<xsl:template match="rdf:Description" mode="edge-gen">
  <xsl:variable name="subject-uri" select="mim:subtype/@rdf:resource"/>
  <xsl:if test="exists(key('items',$subject-uri))">
    <xsl:for-each select="mim:supertype[exists(key('items',@rdf:resource))]">
      <xsl:variable name="object-uri" select="@rdf:resource"/>
      <xsl:variable name="subject-geo" select="key('node-geo',$subject-uri)"/>
      <xsl:if test="not($params='follow') or exists($subject-geo/graphml:data)">
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
                <y:Arrows source="none" target="white_delta"/>
                <y:BendStyle smoothed="false"/>
              </y:PolyLineEdge>
            </data>
          </edge>
        </xsl:if>
      </xsl:if>
    </xsl:for-each>
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
        <!-- Asssociation with Association class -->
        <xsl:choose>
          <xsl:when test="../rdf:type/@rdf:resource='http://bp4mc2.org/def/mim#Relatieklasse'">
            <xsl:variable name="object-uri-helper"><xsl:value-of select="../@rdf:about"/>_HELPER</xsl:variable>
            <xsl:variable name="helper-geo" select="key('node-geo',$object-uri-helper)"/>
            <node id="{$object-uri-helper}">
              <data key="d3"><xsl:value-of select="$object-uri-helper"/></data>
              <data key="d6">
                <y:ShapeNode>
                  <xsl:choose>
                    <xsl:when test="exists($helper-geo/graphml:data/*/y:Geometry)"><xsl:copy-of select="$helper-geo/graphml:data/*/y:Geometry"/></xsl:when>
          				  <xsl:otherwise><y:Geometry height="5.0" width="5.0" x="645.0" y="241.5"/></xsl:otherwise>
                  </xsl:choose>
                  <y:Fill color="#000000" transparent="false"/>
                  <y:BorderStyle color="#000000" raised="false" type="line" width="1.0"/>
                  <y:Shape type="ellipse"/>
                </y:ShapeNode>
              </data>
            </node>
            <edge source="{../@rdf:about}_HELPER" target="{../@rdf:about}">
        			<data key="d10">
        				<y:PolyLineEdge>
                  <y:LineStyle color="#000000" type="line" width="1.0"/>
        					<y:Arrows source="none" target="none"/>
                </y:PolyLineEdge>
              </data>
            </edge>
            <edge source="{$subject-uri}" target="{../@rdf:about}_HELPER">
        			<data key="d10">
        				<y:PolyLineEdge>
                  <y:LineStyle color="#000000" type="line" width="1.0"/>
        					<y:Arrows source="none" target="none"/>
                </y:PolyLineEdge>
              </data>
            </edge>
            <edge source="{../@rdf:about}_HELPER" target="{$object-uri}">
              <data key="d10">
        				<y:PolyLineEdge>
                  <y:LineStyle color="#000000" type="line" width="1.0"/>
                  <xsl:variable name="target-arrow">
                    <xsl:choose>
                      <xsl:when test="../mim:unidirectioneel='true'">plain</xsl:when>
                      <xsl:otherwise>none</xsl:otherwise>
                    </xsl:choose>
                  </xsl:variable>
        					<y:Arrows source="none" target="{$target-arrow}"/>
                  <xsl:if test="../mim:kardinaliteit!='' and not(key('items',../mim:relatierol/@rdf:resource)[rdf:type/@rdf:resource='http://bp4mc2.org/def/mim#RelatierolDoel']/mim:kardinaliteit!='')">
                    <xsl:call-template name="edge-label">
                      <xsl:with-param name="label"><xsl:value-of select="../mim:kardinaliteit"/></xsl:with-param>
                      <xsl:with-param name="ratio">1.0</xsl:with-param>
                      <xsl:with-param name="position">left</xsl:with-param>
                    </xsl:call-template>
                  </xsl:if>
                  <xsl:for-each select="key('resources',../mim:relatierol/(@rdf:resource|@rdf:nodeID))[rdf:type/@rdf:resource='http://bp4mc2.org/def/mim#RelatierolDoel']">
                    <xsl:if test="mim:naam!='' or rdfs:label!=''">
                      <xsl:call-template name="edge-label">
                        <xsl:with-param name="label"><xsl:apply-templates select="." mode="label"/></xsl:with-param>
                        <xsl:with-param name="ratio">1.0</xsl:with-param>
                        <xsl:with-param name="position">left</xsl:with-param>
                      </xsl:call-template>
                    </xsl:if>
                    <xsl:if test="mim:kardinaliteit!=''">
                      <xsl:call-template name="edge-label">
                        <xsl:with-param name="label"><xsl:value-of select="mim:kardinaliteit"/></xsl:with-param>
                        <xsl:with-param name="ratio">1.0</xsl:with-param>
                        <xsl:with-param name="position">right</xsl:with-param>
                      </xsl:call-template>
                    </xsl:if>
                  </xsl:for-each>
                </y:PolyLineEdge>
              </data>
            </edge>
          </xsl:when>
          <xsl:otherwise>
            <!-- Associations -->
            <xsl:variable name="object-geo" select="key('node-geo',$object-uri)"/>
            <xsl:variable name="property-uri"><xsl:value-of select="../(@rdf:about|@rdf:nodeID)"/></xsl:variable>
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
                    <xsl:variable name="source-arrow">
                      <xsl:choose>
                        <xsl:when test="../mim:aggregatietype/@rdf:resource='http://bp4mc2.org/def/mim#Compositie'">diamond</xsl:when>
                        <xsl:when test="../mim:aggregatietype/@rdf:resource='http://bp4mc2.org/def/mim#Aggregatie'">white_diamond</xsl:when>
                        <xsl:otherwise>none</xsl:otherwise>
                      </xsl:choose>
                    </xsl:variable>
                    <xsl:variable name="target-arrow">
                      <xsl:choose>
                        <xsl:when test="../mim:unidirectioneel='true'">plain</xsl:when>
                        <xsl:otherwise>none</xsl:otherwise>
                      </xsl:choose>
                    </xsl:variable>
          					<y:Arrows source="{$source-arrow}" target="{$target-arrow}"/>
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
                      <xsl:if test="mim:naam!='' or rdfs:label!=''">
                        <xsl:call-template name="edge-label">
                          <xsl:with-param name="label"><xsl:apply-templates select="." mode="label"/></xsl:with-param>
                          <xsl:with-param name="ratio">0.0</xsl:with-param>
                          <xsl:with-param name="position">left</xsl:with-param>
                        </xsl:call-template>
                      </xsl:if>
                      <xsl:if test="mim:kardinaliteit!=''">
                        <xsl:call-template name="edge-label">
                          <xsl:with-param name="label"><xsl:value-of select="mim:kardinaliteit"/></xsl:with-param>
                          <xsl:with-param name="ratio">0.0</xsl:with-param>
                          <xsl:with-param name="position">right</xsl:with-param>
                        </xsl:call-template>
                      </xsl:if>
                    </xsl:for-each>
                    <xsl:for-each select="key('resources',../mim:relatierol/(@rdf:resource|@rdf:nodeID))[rdf:type/@rdf:resource='http://bp4mc2.org/def/mim#RelatierolDoel']">
                      <xsl:if test="mim:naam!='' or rdfs:label!=''">
                        <xsl:call-template name="edge-label">
                          <xsl:with-param name="label"><xsl:apply-templates select="." mode="label"/></xsl:with-param>
                          <xsl:with-param name="ratio">1.0</xsl:with-param>
                          <xsl:with-param name="position">left</xsl:with-param>
                        </xsl:call-template>
                      </xsl:if>
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
          </xsl:otherwise>
        </xsl:choose>
      </xsl:if>
    </xsl:for-each>
  </xsl:if>
</xsl:template>

</xsl:stylesheet>
