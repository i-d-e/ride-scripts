<xsl:stylesheet xmlns="http://www.openarchives.org/OAI/2.0/" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" version="2.0" xpath-default-namespace="http://www.tei-c.org/ns/1.0" xml:id="oai-marcxml">
    <xsl:template match="/">
        <xsl:variable name="erJahr" select="//publicationStmt/date/substring(@when, 1, 4)"/>
        <xsl:variable name="aktDatum" select="xs:string(current-date())"/>
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
            <collection xmlns="http://www.loc.gov/MARC21/slim" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.loc.gov/MARC21/slim http://www.loc.gov/standards/marcxml/schema/MARC21slim.xsd">
                <record>
                    <leader>00000naa a22000007u 4500</leader>
                    <controlfield tag="005">20150601100359.0</controlfield>
                    <controlfield tag="007">cr||||||||||||</controlfield>
                    <controlfield tag="008">
                        <xsl:value-of select="substring($aktDatum,3,2)"/>
                        <xsl:value-of select="substring($aktDatum,6,2)"/>
                        <xsl:value-of select="substring($aktDatum,9,2)"/>s<xsl:value-of select="$erJahr"/>||||gw |||||oo||| 00||||<xsl:value-of select="$sprache"/>||</controlfield>
                    <datafield ind1="7" ind2=" " tag="024">
                        <subfield code="a">
                            <xsl:value-of select="//publicationStmt/idno[@type = 'DOI']"/>
                        </subfield>
                        <subfield code="2">doi</subfield>
                    </datafield>
                    <datafield ind1=" " ind2=" " tag="041">
                        <subfield code="a">
                            <xsl:value-of select="$sprache"/>
                        </subfield>
                    </datafield>
                    <datafield tag="093" ind1=" " ind2=" ">
                        <subfield code="b">b</subfield>
                    </datafield>
                    <xsl:for-each select="//titleStmt/author">
                        <xsl:variable name="autor">
                            <xsl:value-of select="name/surname"/>, <xsl:value-of select="name/forename"/>
                        </xsl:variable>
                        <xsl:variable name="affiliation">
                            <xsl:value-of select="affiliation/orgName"/>
                            <xsl:if test="(affiliation/placeName) and (affiliation/orgName)">, </xsl:if>
                            <xsl:value-of select="affiliation/placeName"/>
                        </xsl:variable>
                        <xsl:variable name="tag" select="if (position() = 1) then '100' else '700'"/>
                        <datafield ind1="1" ind2=" " tag="{$tag}">
                            <subfield code="a">
                                <xsl:value-of select="$autor"/>
                            </subfield>
                            <subfield code="4">aut</subfield>
                            <xsl:if test="@ref">
                                <xsl:if test="@ref[contains(., 'gnd')]">
                                    <subfield code="0">(DE-588)<xsl:value-of select="tokenize(@ref, '/')[last()]"/>
                                    </subfield>
                                </xsl:if>
                                <xsl:if test="@ref[contains(., 'orcid')]">
                                    <subfield code="0">(orcid)<xsl:value-of select="tokenize(@ref, '/')[last()]"/>
                                    </subfield>
                                </xsl:if>
                                <xsl:if test="@ref[contains(., 'viaf')]">
                                    <subfield code="0">(viaf)<xsl:value-of select="tokenize(@ref, '/')[last()]"/>
                                    </subfield>
                                </xsl:if>
                            </xsl:if>
                            <subfield code="u">
                                <xsl:value-of select="$affiliation"/>
                            </subfield>
                        </datafield>
                    </xsl:for-each>
                    <datafield ind1="0" ind2="0" tag="245">
                        <subfield code="a">
                            <xsl:value-of select="normalize-space(//titleStmt/title)"/>
                        </subfield>
                    </datafield>
                    <datafield ind1=" " ind2=" " tag="264">
                        <subfield code="c">
                            <xsl:value-of select="$erJahr"/>
                        </subfield>
                    </datafield>
                    <datafield tag="506" ind1="0" ind2=" ">
                        <subfield code="a">open-access</subfield>
                    </datafield>
                    <datafield ind1="3" ind2=" " tag="520">
                        <subfield code="a">
                            <xsl:variable name="abstract" select="//front/div[@type='abstract']/p/normalize-space(.)"/>
                            <xsl:choose>
                                <xsl:when test="string-length($abstract) &gt; 995">
                                    <xsl:value-of select="replace(substring($abstract,1,995),'\w+$','')"/>
                                    <xsl:text> ...</xsl:text>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="$abstract"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </subfield>
                    </datafield>
                    <datafield ind1=" " ind2=" " tag="540">
                        <subfield code="a">Creative Commons - Namensnennung 4.0 International</subfield>
                        <subfield code="f">cc-by-4.0</subfield>
                        <subfield code="u">http://creativecommons.org/licenses/by/4.0/</subfield>
                        <subfield code="2">cc</subfield>
                    </datafield>
                    <xsl:for-each select="//profileDesc/textClass/keywords/term">
                        <datafield ind1=" " ind2=" " tag="653">
                            <subfield code="a">
                                <xsl:value-of select="."/>
                            </subfield>
                        </datafield>
                    </xsl:for-each>
                    <!--
                    <xsl:for-each select="//fileDesc/seriesStmt/editor">
                        <datafield tag="700" ind1="1" ind2=" ">
                            <subfield code="a">
                                <xsl:value-of select="substring-after(normalize-space(.),' ')"/>
                                <xsl:text>, </xsl:text>
                                <xsl:value-of select="substring-before(normalize-space(.),' ')"/>
                            </subfield>
                            <xsl:choose>
                                <xsl:when test="@role = 'chief'">
                                    <subfield code="4">pbd</subfield>
                                    <subfield code="e">Publishing director</subfield>
                                </xsl:when>
                                <xsl:when test="@role = 'technical'">
                                    <subfield code="4">mrk</subfield>
                                    <subfield code="e">Markup editor</subfield>
                                </xsl:when>
                                <xsl:when test="@role = 'managing'">
                                    <subfield code="4">pbd</subfield>
                                    <subfield code="e">Publishing director</subfield>
                                </xsl:when>
                                <xsl:when test="@role = 'assistant'">
                                    <subfield code="4">ctb</subfield>
                                    <subfield code="e">contributor</subfield>
                                </xsl:when>
                                <xsl:otherwise>
                                    <subfield code="4">edt</subfield>
                                    <subfield code="e">Publishing editor</subfield>
                                </xsl:otherwise>
                            </xsl:choose>
                            <xsl:if test="@ref">
                                <xsl:if test="@ref[contains(., 'gnd')]">
                                    <subfield code="0">(DE-588)<xsl:value-of select="tokenize(@ref, '/')[last()]"/>
                                    </subfield>
                                </xsl:if>
                                <xsl:if test="@ref[contains(., 'orcid')]">
                                    <subfield code="0">(orcid)<xsl:value-of select="tokenize(@ref, '/')[last()]"/>
                                    </subfield>
                                </xsl:if>
                                <xsl:if test="@ref[contains(., 'viaf')]">
                                    <subfield code="0">(viaf)<xsl:value-of select="tokenize(@ref, '/')[last()]"/>
                                    </subfield>
                                </xsl:if>
                            </xsl:if>
                        </datafield>
                    </xsl:for-each>
                    -->
                    <datafield ind1="1" ind2="2" tag="710">
                        <subfield code="a">Institut für Dokumentologie und Editorik e.V.</subfield>
                        <subfield code="g">Köln</subfield>
                        <subfield code="0">(DE-588)6521152-2</subfield>
                        <subfield code="4">edt</subfield>
                    </datafield>
                    <datafield ind1="1" ind2=" " tag="773">
                        <subfield code="g">volume:<xsl:value-of select="//fileDesc/seriesStmt/biblScope/@n"/>
                        </subfield>
                        <subfield code="g">month:<xsl:value-of select="tokenize(//publicationStmt/date/@when, '-')[2]"/>
                        </subfield>
                        <subfield code="g">year:<xsl:value-of select="$erJahr"/>
                        </subfield>
                        <subfield code="7">nnas</subfield>
                    </datafield>
                    <datafield ind1="1" ind2="8" tag="773">
                        <subfield code="x">2363-4952</subfield>
                    </datafield>
                    <datafield ind1="4" ind2=" " tag="856">
                        <subfield code="u">
                            <xsl:value-of select="//publicationStmt/idno[@type = 'URI']"/>
                        </subfield>
                        <subfield code="q">pdf</subfield>
                    </datafield>
                    <datafield ind1="4" ind2="0" tag="856">
                        <subfield code="u">
                            <xsl:value-of select="//publicationStmt/idno[@type = 'archive']"/>
                        </subfield>
                        <subfield code="q">pdf</subfield>
                        <subfield code="x">Transfer-URL</subfield>
                    </datafield>
                </record>
            </collection>
        </metadata>
    </xsl:template>
</xsl:stylesheet>