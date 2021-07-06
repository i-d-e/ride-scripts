<xsl:stylesheet xmlns="http://www.openarchives.org/OAI/2.0/" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:oai_dc="http://www.openarchives.org/OAI/2.0/oai_dc/" xmlns:dcterms="http://purl.org/dc/terms/" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xpath-default-namespace="http://www.tei-c.org/ns/1.0" version="2.0" xml:id="oai-header">
    <xsl:template match="/">
        <header>
            <identifier>
                <xsl:value-of select="//TEI/@xml:id"/>
            </identifier>
            <datestamp>
                <xsl:variable name="publication_date" select="xs:date(//publicationStmt/date/@when/concat(.,'-01'))"/>
                <xsl:variable name="revision_dates" select="//revisionDesc//change/@when/xs:date(.)"/>
                <xsl:variable name="latest_date" select="max(($publication_date, $revision_dates))[1]"/>
                <xsl:value-of select="$latest_date"/>
            </datestamp>
        </header>
    </xsl:template>
</xsl:stylesheet>