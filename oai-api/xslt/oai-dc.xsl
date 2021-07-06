<xsl:stylesheet xmlns="http://www.openarchives.org/OAI/2.0/" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0" xpath-default-namespace="http://www.tei-c.org/ns/1.0" xml:id="oai-dc">
    <xsl:template match="/">
        <xsl:variable name="erJahr" select="//publicationStmt/date/substring(@when, 1, 4)"/>
        <xsl:variable name="sprache">
            <xsl:choose>
                <xsl:when test="//profileDesc/langUsage/language[@ident = 'de']">ger</xsl:when>
                <xsl:when test="//profileDesc/langUsage/language[@ident = 'en']">eng</xsl:when>
                <xsl:when test="//profileDesc/langUsage/language[@ident = 'it']">ita</xsl:when>
                <xsl:when test="//profileDesc/langUsage/language[@ident = 'fr']">fre</xsl:when>
                <xsl:otherwise>ACHTUNG FEHLER</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <metadata>
            <dc xmlns="http://www.openarchives.org/OAI/2.0/oai_dc/" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.openarchives.org/OAI/2.0/oai_dc/ http://www.openarchives.org/OAI/2.0/oai_dc.xsd">
                <dc:title>
                    <xsl:value-of select="//titleStmt/title/normalize-space(.)"/>
                </dc:title>
                <xsl:for-each select="//titleStmt/author">
                    <xsl:variable name="autor">
                        <xsl:value-of select="name/surname"/>, <xsl:value-of select="name/forename"/>
                    </xsl:variable>
                    <dc:creator>
                        <xsl:value-of select="$autor"/>
                    </dc:creator>
                </xsl:for-each>
                <dc:publisher>
                    <xsl:value-of select="//publicationStmt/publisher"/>
                </dc:publisher>
                <dc:date>
                    <xsl:value-of select="$erJahr"/>
                </dc:date>
                <dc:identifier xmlns:tel="http://krait.kb.nl/coop/tel/handbook/telterms.html" xsi:type="tel:URL">
                    <xsl:value-of select="//publicationStmt/idno[@type = 'URI']"/>
                </dc:identifier>
                <dc:identifier xmlns:tel="http://krait.kb.nl/coop/tel/handbook/telterms.html" xsi:type="tel:DOI">
                    <xsl:value-of select="//publicationStmt/idno[@type = 'DOI']"/>
                </dc:identifier>
                <dc:rights>http://creativecommons.org/licenses/by/4.0/</dc:rights>
                <dc:isPartOf>
                    <xsl:value-of select="//seriesStmt/title[@level='j']"/>
                </dc:isPartOf>
                <dc:isPartOf>
                    <xsl:value-of select="//seriesStmt/idno[@type='URI']"/>
                </dc:isPartOf>
                <xsl:for-each select="//seriesStmt/editor">
                    <xsl:variable name="surname" select="normalize-space(substring-after(.,' '))"/>
                    <xsl:variable name="forename" select="normalize-space(substring-before(.,' '))"/>
                    <dc:contributor>
                        <xsl:value-of select="$surname"/>, <xsl:value-of select="$forename"/>
                    </dc:contributor>
                </xsl:for-each>
                <xsl:variable name="reviewed_resource" select="//relatedItem[@type='reviewed_resource']"/>
                <dc:references>
                    <xsl:value-of select="$reviewed_resource//idno[@type='URI']"/>
                </dc:references>
                <dc:language>
                    <xsl:value-of select="$sprache"/>
                </dc:language>
                <xsl:for-each select="//profileDesc//keywords/term">
                    <dc:subject>
                        <xsl:value-of select="."/>
                    </dc:subject>
                </xsl:for-each>
                <dc:description>
                    <xsl:value-of select="normalize-space(//front/div[@type='abstract'])"/>
                </dc:description>
                <dc:type>Text</dc:type>
                <dc:type>Image</dc:type>
                <dc:format>html</dc:format>
            </dc>
        </metadata>
    </xsl:template>
</xsl:stylesheet>