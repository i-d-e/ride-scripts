<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs local" xpath-default-namespace="http://www.tei-c.org/ns/1.0"
    xmlns:local="http://ride.i-d-e.de/ns/local" 
    version="2.0">
    
    <!-- 
        transform RIDE reviews in TEI format to the DOAJ XML format (see https://doaj.org/docs/xml/)
        @author: Ulrike Henny-Krahmer
        created on 29 September 2021
        
        This is a component file of the RIDE scripts.
		RIDE scripts is free software: you can redistribute it and/or modify
		it under the terms of the GNU General Public License as published by
		the Free Software Foundation, either version 3 of the License, or
		(at your option) any later version, see http://www.gnu.org/licenses/.
    -->
    
    <xsl:variable name="input-data-reviews" select="collection('/home/ulrike/Git/ride/tei_all')"/>
    <xsl:variable name="input-data-editorials" select="(doc('/home/ulrike/Git/ride/issues/issue06/editorial/editorial-tei.xml'),
        doc('/home/ulrike/Git/ride/issues/issue08/editorial/editorial-tei.xml'),
        doc('/home/ulrike/Git/ride/issues/issue09/editorial/editorial-tei.xml'),
        doc('/home/ulrike/Git/ride/issues/issue16/editorial/editorial-tei.xml'))"/>
    
    <xsl:output method="xml" encoding="UTF-8" indent="yes"/>
    
    <xsl:function name="local:get-iso-639-2">
        <xsl:param name="lang"/>
        <xsl:choose>
            <xsl:when test="$lang='en'"><xsl:text>eng</xsl:text></xsl:when>
            <xsl:when test="$lang='de'"><xsl:text>ger</xsl:text></xsl:when>
            <xsl:when test="$lang='fr'"><xsl:text>fre</xsl:text></xsl:when>
            <xsl:when test="$lang='it'"><xsl:text>ita</xsl:text></xsl:when>
        </xsl:choose>
    </xsl:function>
    
    
    <xsl:template match="/">
        <records xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="https://doaj.org/static/doaj/doajArticles.xsd">
            <xsl:for-each select="($input-data-reviews, $input-data-editorials)">
                <xsl:variable name="review-lang" select=".//language/@ident"/>
                <record>
                    <language><xsl:value-of select="local:get-iso-639-2($review-lang)"/></language>
                    <publisher>Institut für Dokumentologie und Editorik e.V.</publisher>
                    <journalTitle>RIDE – A review journal for digital editions and resources</journalTitle>
                    <eissn>2363-4952</eissn>
                    <publicationDate><xsl:value-of select=".//publicationStmt/date/@when"/>-01</publicationDate>
                    <volume><xsl:value-of select=".//biblScope[@unit='issue']/@n"/></volume>
                    <doi><xsl:value-of select=".//publicationStmt/idno[@type='DOI']"/></doi>
                    <documentType>article</documentType>
                    <title language="{local:get-iso-639-2($review-lang)}"><xsl:value-of select=".//titleStmt/title/normalize-space(.)"/></title>
                    <authors>
                        <xsl:for-each select=".//titleStmt/author">
                            <author>
                                <name><xsl:value-of select="concat(name/forename, ' ', name/surname)"/></name>
                                <affiliationId><xsl:value-of select="position()"/></affiliationId>
                                <xsl:if test="starts-with(@ref,'https://orcid.org')">
                                    <orcid_id><xsl:value-of select="@ref"/></orcid_id>
                                </xsl:if>
                            </author>
                        </xsl:for-each>
                    </authors>
                    <affiliationsList>
                        <xsl:for-each select=".//titleStmt/author">
                            <affiliationName affiliationId="{position()}"><xsl:value-of select="affiliation/orgName"/></affiliationName>    
                        </xsl:for-each>
                    </affiliationsList>
                    <abstract language="{local:get-iso-639-2($review-lang)}"><xsl:value-of select=".//div[@type='abstract']/normalize-space(data(.))"/></abstract>
                    <fullTextUrl format="html"><xsl:value-of select=".//publicationStmt/idno[@type='URI']"/></fullTextUrl>
                    <keywords language="{local:get-iso-639-2(.//keywords/@xml:lang)}">
                        <xsl:for-each select=".//keywords/term">
                            <keyword><xsl:value-of select="."/></keyword>
                        </xsl:for-each>
                    </keywords>
                </record>
            </xsl:for-each>
        </records>
    </xsl:template>
    
</xsl:stylesheet>