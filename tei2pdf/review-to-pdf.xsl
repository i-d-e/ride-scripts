<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs local" xpath-default-namespace="http://www.tei-c.org/ns/1.0"
    xmlns:local="http://ride.i-d-e.de/ns/local"
    version="2.0">
    
    <!-- 
        transform a RIDE review to HTML/CSS as a basis for PDF generation
        @author: Ulrike Henny-Krahmer
        created on 16 January 2021
        last updated on 5 September 2021
        
        This is a component file of the RIDE scripts.
		RIDE scripts is free software: you can redistribute it and/or modify
		it under the terms of the GNU General Public License as published by
		the Free Software Foundation, either version 3 of the License, or
		(at your option) any later version, see http://www.gnu.org/licenses/.
    -->
    
    <!-- PARAMS -->
    <xsl:param name="outfolder"/><!-- absolute or relative (to this XSLT) path to the output folder -->
        
    <!-- VARIABLES -->
    <xsl:variable name="wdir">/home/ulrike/Git/ride-scripts/tei2pdf/</xsl:variable><!-- absolute path to the working directory -->
    <xsl:variable name="lang" select="//langUsage/language/@ident"/>
    <xsl:variable name="review-shortcut" select="substring-before(tokenize(//publicationStmt/idno[@type='archive'],'/')[last()],'.pdf')"/>
    <xsl:variable name="review-title" select="//teiHeader//titleStmt/title/normalize-space(.)"/>
    <xsl:variable name="base" select="//taxonomy/@xml:base" />
    <xsl:variable name="home" select="'http://ride.i-d-e.de/'" />
    <xsl:variable name="issue-type" select="//seriesStmt/biblScope[@unit='issue']"/>
    <xsl:variable name="resource-type">
        <xsl:choose>
            <xsl:when test="$issue-type='Digital Scholarly Editions'">editions</xsl:when>
            <xsl:when test="$issue-type='Digital Text Collections'">text-collections</xsl:when>
            <xsl:when test="$issue-type='Tools and Environments'">tools</xsl:when>
        </xsl:choose>
    </xsl:variable>
     
    <xsl:variable name="sources" select="//teiHeader//relatedItem[@type='reviewed_resource']"/>
    <xsl:variable name="review-authors" select="//teiHeader//titleStmt/author"/>
    <xsl:variable name="accessed-dates" select="$sources//date[@type='accessed']"/>
    <xsl:variable name="current-date" select="xs:string(current-date())"/>
    <xsl:variable name="citation">
        <xsl:for-each select="$review-authors">
            <xsl:variable name="review-author-surname" select=".//surname"/>
            <xsl:variable name="review-author-forename" select=".//forename"/>
            <xsl:choose>
                <xsl:when test="position() != last()">
                    <xsl:value-of select="$review-author-surname"/><xsl:text>, </xsl:text>
                    <xsl:value-of select="$review-author-forename"/>
                    <xsl:if test="count($review-authors) &gt; 2"><xsl:text>, </xsl:text></xsl:if>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:choose>
                        <xsl:when test="count($review-authors) &gt; 1">
                            <xsl:text> and </xsl:text>
                            <xsl:value-of select="$review-author-forename"/><xsl:text> </xsl:text>
                            <xsl:value-of select="$review-author-surname"/><xsl:text>.</xsl:text>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="$review-author-surname"/><xsl:text>, </xsl:text>
                            <xsl:value-of select="$review-author-forename"/><xsl:text>.</xsl:text>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
        <xsl:text> </xsl:text>
        <xsl:choose>
            <xsl:when test="contains(lower-case($review-title),'review') or contains($review-title,'Rezension') or contains(lower-case($review-title),'editorial')">
                <xsl:text>“</xsl:text>
                <xsl:value-of select="$review-title"/>
                <xsl:text>.”</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>“Review of ‘</xsl:text>
                <xsl:value-of select="$review-title"/>
                <xsl:text>’.”</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:text> RIDE </xsl:text>
        <xsl:value-of select="//teiHeader//seriesStmt//biblScope[@unit='issue']/@n"/> (<xsl:value-of select="//teiHeader//publicationStmt//date/@when/substring(.,1,4)"/>).
        doi: <xsl:value-of select="//teiHeader//publicationStmt//idno[@type='DOI']"/>.
        Accessed: <xsl:value-of select="substring($current-date,9,2)"/>.<xsl:value-of select="substring($current-date,6,2)"/>.<xsl:value-of select="substring($current-date,1,4)"/>.
    </xsl:variable>
    
    
    <!-- FUNCTIONS -->
    <xsl:function name="local:format-date">
        <xsl:param name="date" />
        <xsl:variable name="year" select="substring($date,1,4)" />
        <xsl:variable name="month" select="substring($date,6,2)" />
        <xsl:variable name="day" select="substring($date,9,2)" />
        <xsl:value-of select="string-join(($day, $month, $year), '.')" />
    </xsl:function>
    
    <xsl:function name="local:get-cat-desc-cols">
        <xsl:param name="cat" />
        <th>
            <xsl:value-of select="$cat/catDesc[1]/normalize-space(text()[1])" />
        </th>
        <td><div><xsl:value-of select="$cat/catDesc[2]/normalize-space(.)" /></div>
            <xsl:if test="$cat/catDesc[1][ref]">
                <xsl:choose>
                    <xsl:when test="contains($cat/catDesc/ref,'and')">
                        <div>(<a href="{$base}{$cat/catDesc[ref]/ref/substring-before(@target,' #')}"><xsl:value-of select="normalize-space($cat/catDesc[ref]/ref/substring-before(.,' and'))"/></a> and <a href="{$base}{'#'}{$cat/catDesc[ref]/ref/substring-after(@target,' #')}"><xsl:value-of select="normalize-space($cat/catDesc[ref]/ref/substring-after(.,'and'))" /></a>)</div>
                    </xsl:when>
                    <xsl:otherwise>
                        <div>(<a href="{$base}{$cat/catDesc[ref]/ref/@target}"><xsl:value-of select="$cat/catDesc[ref]/ref/normalize-space()" /></a>)</div>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:if>
        </td>
    </xsl:function>
    
    <xsl:function name="local:get-booleans">
        <xsl:param name="cat" />
        <xsl:choose>
            <xsl:when test="$cat/category/catDesc[. = 'Yes']/following-sibling::catDesc/num/@value='1'">yes</xsl:when>
            <xsl:when test="$cat/category/catDesc[. = 'No']/following-sibling::catDesc/num/@value='1'">no</xsl:when>
            <xsl:when test="$cat/category/catDesc[starts-with(.,'Not applicable')]/following-sibling::catDesc/num/@value='1'">not applicable</xsl:when>
            <xsl:when test="$cat/category/catDesc[. = 'Unknown']/following-sibling::catDesc/num/@value='1'">Unknown</xsl:when>
        </xsl:choose>
    </xsl:function>
    
    <xsl:function name="local:get-select-values">
        <xsl:param name="cat" />
        <xsl:for-each select="$cat/category[.//num/@value = '1']">
            <xsl:value-of select="catDesc[1]" /><xsl:if test="catDesc[1]='Other'">
                <xsl:text>: </xsl:text>
                <xsl:value-of select="catDesc[3]/gloss/normalize-space(.)"/>
            </xsl:if>
            <xsl:if test="position() != last()">, </xsl:if>
        </xsl:for-each>
    </xsl:function>
    
    <xsl:function name="local:get-resp-row">
        <xsl:param name="context" />
        <xsl:param name="role" />
        <tr>
            <th><xsl:value-of select="$role"/>s</th>
            <xsl:for-each select="$context">
                <xsl:variable name="res" select="@xml:id"/>
                <td colspan="2">
                    <xsl:choose>
                        <xsl:when test=".//respStmt[resp=$role]">
                            <xsl:for-each select=".//respStmt[resp=$role]">
                                <xsl:sort select=".//persName"></xsl:sort>
                                <xsl:value-of select=".//persName/normalize-space()" /><xsl:if test="position() != last()"><br/></xsl:if>
                            </xsl:for-each>
                        </xsl:when>
                        <xsl:otherwise>-</xsl:otherwise>
                    </xsl:choose>
                </td>       
            </xsl:for-each>
        </tr>
    </xsl:function>
    
    
    
    <!-- TEMPLATES -->
    
    <xsl:template match="/">
        <!-- generate CSS -->
        <xsl:result-document href="{$outfolder}/{$review-shortcut}.css" method="text" encoding="UTF-8">
@page {
    size: A4; 
    margin: 2cm;
    
    @bottom-right {
        font-family: sans-serif;
        font-weight: bold;
        font-size: 0.8em;
        margin-right: 7px;
        content: counter(page);
    }
    @bottom-left {
        font-family: sans-serif;
        font-size: 0.8em;
        width: 90%;
        margin-left: 7px;
        content: "<xsl:value-of select="normalize-space($citation)"/>";
    }
}

body {
    font-family: Helvetica, Arial, sans-serif;
    font-size: 12pt;
    line-height: 1.7em;
}


div.header img {
    float: left;
    width: 150px;
}
div.header h2 {
    font-weight: normal;
    text-align: right;
    font-size: 1.1em;
}
div.header p {
    text-align: right;
}
div.header a {
    color: black;
    text-decoration: none;
}
div.body {
    clear: both;
}
div.source {
    font-size: 0.9em;
}
div.abstract {
    padding: 1.5em 2em 0.5em 2em;
    font-size: 0.9em;
    background-color: #E6E6E6;
    margin: 1em 0 2em 0;
}
div.abstract h2 {
    font-size: 1em;
}
div.factsheet {
    page-break-before: always;
}

h1 {
    margin-top: 2em;
    line-height: 1.5em;
}
h2, h3 {
    page-break-after: avoid;
}
p {
    widows: 2;
    orphans: 2;
    text-align: justify;
}
li {
    text-align: justify;
}
blockquote {
    width: 90%;
    margin: 28px;
    font-size: 0.9em;
    text-align: justify;
}
p.source {
    page-break-before: avoid;
}

span.ftn {
    white-space: nowrap;
}

figure {
    margin: 20px;
    text-align: center;
    page-break-inside: avoid;
}
figcaption {
    text-align: center;
    padding-top: 5px;
    font-size: 0.9em;
}
img.graphic {
    width: 500px;
    max-height: 700px;
    object-fit: scale-down;
}
img.license {
    width: 55px;
    vertical-align: top;
}

p.code-example {
    text-align: left;
    font-size: 0.8em;
    padding-left: 1cm;
    line-height: 1em;
}
span.code-caption {
    display: block;
    text-align: center;
    font-size: 1.1em;
    page-break-before: avoid;
    margin-top: 0.5em;
    line-height: 1.7em;
}
p.bibl {
    padding-left: 2em;
    text-indent: -2em;
}
span.bibl-ref {
    display: block;
    padding-left: 0;
    text-indent: 0;
}

p.note {
    text-align: left;
}
p.note a.internalref {
    padding-right: 5px;
}

span.paracount {
    background-color: #E6E6E6;
    display: inline-block;
    margin-right: 25px;
    padding: 0 0.3em;
}
span.code {
    font-family: monospace;
    font-style: normal;
    font-size: 95%;
    background-color: #ffffff;
}
span.code.break {
    overflow-wrap: break-word;
}
span.ws {
    white-space: pre;
}
span.deletion {
    text-decoration: line-through;
}

a {
    color: #0066CC;
    text-decoration: underline;
}
a.crossref, a.text-link {
    overflow-wrap: normal;
}
a.break {
    overflow-wrap: break-word;
}

ul.labeled {
    list-style-type: none;
}

table {
    border-spacing: 0;
    border-collapse: collapse;
    margin: 1.5em auto;
    max-width: 100%;
    /*font-size: 0.8em;*/
}
table caption {
    text-align: center;
}
table td, table th {
    padding: 7px;
    vertical-align: top;
    text-align: left;
}
table, td, tr, th {
    border: 1px solid #BBBBBB;
}
.factsheet table {
    width: 100%;
    font-size: 0.9em;
    line-height: 1.2em;
}
.factsheet th[colspan="3"], .factsheet th[colspan="2"] {
    background-color: #999999;
    color: #FFFFFF;
    padding: 5px 7px;
}
.factsheet tr, .factsheet th, .factsheet td {
    page-break-inside: avoid;
}

        </xsl:result-document>
        <!-- generate HTML -->
        <xsl:result-document href="{$outfolder}/{$review-shortcut}.html" method="html" encoding="UTF-8">
            <xsl:text disable-output-escaping='yes'>&lt;!DOCTYPE html&gt;</xsl:text>
            <html>
                <head>
                    <title><xsl:value-of select="$review-title"/></title>
                    <link rel="stylesheet" href="{$review-shortcut}.css"></link>
                    <script src="https://unpkg.com/pagedjs/dist/paged.polyfill.js"></script>
                </head>
                <body>
                    <div class="header">
                        <img src="{$wdir}/img/ide-logo.png" alt="IDE-Logo"/>
                        <h2><a href="https://ride.i-d-e.de/">RIDE – A review journal for digital editions and resources</a></h2>
                        <p>published by the <a href="https://www.i-d-e.de/">IDE</a></p>
                    </div>
                    <div class="body">
                        <h1><xsl:value-of select="$review-title"/></h1>
                        <div class="source">
                            <xsl:choose>
                                <xsl:when test="contains(lower-case($review-title),'editorial')">
                                    <p>By 
                                        <xsl:for-each select="$review-authors">
                                            <xsl:variable name="review-author-surname" select=".//surname"/>
                                            <xsl:variable name="review-author-forename" select=".//forename"/>
                                            <xsl:value-of select="$review-author-forename"/><xsl:text> </xsl:text><xsl:value-of select="$review-author-surname"/>
                                            (<xsl:value-of select=".//orgName"/>), <xsl:value-of select=".//email"/>
                                            <xsl:choose>
                                                <xsl:when test="position() != last()">
                                                    <xsl:choose>
                                                        <xsl:when test="count($review-authors) &gt; 2"><xsl:text>, </xsl:text></xsl:when>
                                                        <xsl:otherwise><xsl:text> and </xsl:text></xsl:otherwise>
                                                    </xsl:choose>
                                                </xsl:when>
                                                <xsl:otherwise><xsl:text>.</xsl:text></xsl:otherwise>
                                            </xsl:choose>
                                        </xsl:for-each></p>
                                </xsl:when>
                                <xsl:otherwise>
                                    <p>
                                        <xsl:for-each select="$sources">
                                            <xsl:variable name="pos" select="position()"/>
                                            <em><xsl:value-of select=".//title"/></em><xsl:text>, </xsl:text>
                                            <xsl:value-of select=".//editor"/><xsl:text> (ed.), </xsl:text>
                                            <xsl:value-of select=".//date[@type='publication']"/><xsl:text>. </xsl:text>
                                            <a href="{.//idno[@type='URI']}"><xsl:value-of select=".//idno[@type='URI']"/></a>
                                            (Last Accessed: <xsl:value-of select="substring($accessed-dates[$pos],9,2)"/>.<xsl:value-of select="substring($accessed-dates[$pos],6,2)"/>.<xsl:value-of select="substring($accessed-dates[$pos],1,4)"/><xsl:text>)</xsl:text>
                                            <xsl:choose>
                                                <xsl:when test="position() = last()"><xsl:text>.</xsl:text></xsl:when>
                                                <xsl:otherwise><xsl:text>; </xsl:text></xsl:otherwise>
                                            </xsl:choose>
                                        </xsl:for-each>
                                        Reviewed by 
                                        <xsl:for-each select="$review-authors">
                                            <xsl:choose>
                                                <xsl:when test="@ref != ''">
                                                    <xsl:choose>
                                                        <xsl:when test="@ref/contains(., 'orcid')">
                                                            <a href="{@ref}"><img src="{concat($wdir,'/img/orcid-small.png')}" alt="orcid-icon" title="ORCID Identifier"
                                                                style="width:18px;"/></a>
                                                            <xsl:text> </xsl:text>
                                                        </xsl:when>
                                                        <xsl:when test="@ref/contains(., 'gnd')">
                                                            <a href="{@ref}"><img src="{concat($wdir,'/img/gnd-small.png')}" alt="gnd-icon" title="GND Identifier"
                                                                style="width:18px;"/></a>
                                                            <xsl:text> </xsl:text>
                                                        </xsl:when>
                                                        <xsl:when test="@ref/contains(., 'viaf')">
                                                            <a href="{@ref}"><img src="{concat($wdir,'/img/viaf-small.png')}" alt="viaf-icon" title="VIAF Identifier"
                                                                style="width:18px;"/></a>
                                                            <xsl:text> </xsl:text>
                                                        </xsl:when>
                                                        <xsl:otherwise/>
                                                    </xsl:choose>
                                                </xsl:when>
                                                <xsl:otherwise/>
                                            </xsl:choose>
                                            <xsl:variable name="review-author-surname" select=".//surname"/>
                                            <xsl:variable name="review-author-forename" select=".//forename"/>
                                            <xsl:value-of select="$review-author-forename"/><xsl:text> </xsl:text><xsl:value-of select="$review-author-surname"/>
                                            (<xsl:value-of select=".//orgName"/>), <xsl:value-of select=".//email"/>
                                            <xsl:choose>
                                                <xsl:when test="position() != last()">
                                                    <xsl:choose>
                                                        <xsl:when test="count($review-authors) &gt; 2"><xsl:text>, </xsl:text></xsl:when>
                                                        <xsl:otherwise><xsl:text> and </xsl:text></xsl:otherwise>
                                                    </xsl:choose>
                                                </xsl:when>
                                                <xsl:otherwise><xsl:text>.</xsl:text></xsl:otherwise>
                                            </xsl:choose>
                                        </xsl:for-each> <br/><a href="http://creativecommons.org/licenses/by/4.0/"><img class="license" src="{$wdir}/img/by.png" alt="CC-BY"/></a></p>
                                </xsl:otherwise>
                            </xsl:choose>
                        </div>
                        <xsl:if test="not(contains(lower-case($review-title),'editorial'))">
                            <div class="abstract">
                                <h2>Abstract</h2>
                                <p><xsl:apply-templates select="//front/div[@type='abstract']"/></p>
                            </div>
                        </xsl:if>
                        <div class="text">
                            <xsl:apply-templates select="//body"/>
                        </div>
                        <xsl:if test="//body//note">
                            <div class="notes">
                                <xsl:choose>
                                    <xsl:when test="$lang='de'">
                                        <h2>Anmerkungen</h2>
                                    </xsl:when>
                                    <xsl:when test="$lang='it'">
                                        <h2>Note</h2>
                                    </xsl:when>
                                    <xsl:when test="$lang='fr'">
                                        <h2>Note</h2>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <h2>Notes</h2>
                                    </xsl:otherwise>
                                </xsl:choose>
                                <xsl:for-each select="//body//note[starts-with(@xml:id,'ftn')]">
                                    <p class="note">
                                        <a href="#fnid-{@xml:id}" class="internalref"><span id="{@xml:id}"><xsl:value-of select="substring-after(@xml:id,'ftn')"/></span>.</a>
                                        <xsl:apply-templates/>
                                    </p>
                                </xsl:for-each>
                            </div>
                        </xsl:if>
                        <xsl:if test="//back/div[@type='bibliography']">
                            <div class="references">
                                <xsl:choose>
                                    <xsl:when test="$lang='de'">
                                        <h2>Bibliographie</h2>
                                    </xsl:when>
                                    <xsl:when test="$lang='it'">
                                        <h2>Bibliografia</h2>
                                    </xsl:when>
                                    <xsl:when test="$lang='fr'">
                                        <h2>Références</h2>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <h2>References</h2>
                                    </xsl:otherwise>
                                </xsl:choose>
                                <xsl:apply-templates select="//back//head | //back//bibl | //back//p"/>
                            </div>
                        </xsl:if>
                    </div>
                    <xsl:for-each select="//teiHeader//taxonomy">
                        <xsl:variable name="pos" select="position()"/>
                        <xsl:call-template name="factsheet">
                            <xsl:with-param name="pos" select="$pos"/>
                        </xsl:call-template>    
                    </xsl:for-each>                    
                </body>
            </html>
        </xsl:result-document>
    </xsl:template>
    
    
    
    <xsl:template match="body//div">
        <div>
            <xsl:if test="@xml:id">
                <xsl:attribute name="id" select="@xml:id"/>
            </xsl:if>
            <xsl:apply-templates/>
        </div>
    </xsl:template>
    
    <xsl:template match="body/div/head">
        <h2><xsl:apply-templates/></h2>
    </xsl:template>
    
    <xsl:template match="body/div/div/head | body/div/div/div/head">
        <h3><xsl:apply-templates/></h3>
    </xsl:template>
    
    <xsl:template match="back//listBibl/head">
        <h3><xsl:apply-templates/></h3>
    </xsl:template>
    
    <xsl:template match="body//table/head">
        <caption><xsl:apply-templates/></caption>
    </xsl:template>
    
    <xsl:template match="body//p | back//p">
        <xsl:apply-templates select="figure[not(starts-with(@xml:id,'code'))]"/>
        <p>
            <xsl:if test="@xml:id">
                <xsl:attribute name="id" select="@xml:id"/>
                <span class="paracount"><xsl:value-of select="substring-after(@xml:id,'p')"/></span>
            </xsl:if>
            <xsl:apply-templates select="child::*[name() != 'figure' or starts-with(@xml:id,'code')]|text()"/>
        </p>
    </xsl:template>
    
    <!-- quotes -->
    <xsl:template match="body//cit">
        <blockquote><xsl:apply-templates/></blockquote>
    </xsl:template>
    
    <xsl:template match="body//cit/bibl">
        <p class="source">(<xsl:apply-templates/>)</p>
    </xsl:template>
    
    <!-- figures -->
    <xsl:template match="body//figure[not(starts-with(@xml:id,'code'))]">
        <figure id="{@xml:id}"><xsl:apply-templates/></figure>
    </xsl:template>
    
    <xsl:template match="body//figure[starts-with(@xml:id,'code')]">
        <p class="code-example" id="{@xml:id}"><xsl:apply-templates/></p>
    </xsl:template>
    
    <xsl:template match="body//graphic">
        <img src="{@url}" class="graphic" alt="{@xml:id}"/>
    </xsl:template>
    
    <xsl:template match="body//figure[starts-with(@xml:id,'img')]/head[@type='legend']">
        <figcaption>
            <xsl:choose>
                <xsl:when test="$lang='de'">
                    <xsl:text>Abb. </xsl:text>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text>Fig. </xsl:text>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:value-of select="parent::figure/@xml:id/substring-after(.,'img')"/>
            <xsl:if test=". != ''"><xsl:text>: </xsl:text></xsl:if>
            <xsl:apply-templates/>
        </figcaption>
    </xsl:template>
    
    <xsl:template match="body//figure[starts-with(@xml:id,'code')]//head[@type='legend']">
        <span class="code-caption">
            <xsl:text>Code </xsl:text>
            <xsl:value-of select="parent::figure/@xml:id/substring-after(.,'code')"/>
            <xsl:if test=". != ''">
                <xsl:text>: </xsl:text>
                <xsl:apply-templates/>
            </xsl:if>
        </span>
    </xsl:template>
    
    <xsl:template match="lb">
        <br/>
    </xsl:template>
    
    <xsl:template match="space">
        <span class="ws">
            <xsl:choose>
                <xsl:when test="@unit='tabs'">
                    <xsl:for-each select="1 to xs:integer(@quantity)">
                        <xsl:text>&#x9;</xsl:text>
                    </xsl:for-each>
                </xsl:when>
                <xsl:when test="@unit='chars'">
                    <xsl:for-each select="1 to xs:integer(@quantity)">
                        <xsl:text>&#x00A0;</xsl:text>
                    </xsl:for-each>
                </xsl:when>
            </xsl:choose>
        </span>
    </xsl:template>
    
    <!-- tables -->
    <xsl:template match="table">
        <table>
            <xsl:apply-templates/>
        </table>
    </xsl:template>
    
    <xsl:template match="row">
        <tr>
            <xsl:apply-templates/>
        </tr>
    </xsl:template>
    
    <xsl:template match="cell[not(parent::row[@role='label'])]">
        <td>
            <xsl:apply-templates/>
        </td>
    </xsl:template>
    
    <xsl:template match="cell[parent::row[@role='label']]">
        <th>
            <xsl:apply-templates/>
        </th>
    </xsl:template>
    
    <!-- lists -->
    <xsl:template match="list[@rend='bulleted']">
        <ul>
            <xsl:apply-templates/>
        </ul>
    </xsl:template>
    
    <xsl:template match="list[@rend='ordered']">
        <ol>
            <xsl:apply-templates/>
        </ol>
    </xsl:template>
    
    <xsl:template match="list[@rend='labeled']">
        <ul class="labeled">
            <xsl:apply-templates/>
        </ul>
    </xsl:template>
    
    <xsl:template match="item">
        <li>
            <xsl:apply-templates/>
        </li>
    </xsl:template>
    
    <xsl:template match="label">
        <span class="label"><xsl:apply-templates/></span>
    </xsl:template>
    
    
    
    <xsl:template match="emph">
        <em><xsl:apply-templates/></em>
    </xsl:template>
    
    <xsl:template match="hi[@rend='bold']">
        <strong><xsl:apply-templates/></strong>
    </xsl:template>
    
    <xsl:template match="hi[@rend='superscript']">
        <sup><xsl:apply-templates/></sup>
    </xsl:template>
    
    <xsl:template match="ref[@target][not(@type)][starts-with(normalize-space(.),'http')][string-length(normalize-space(.)) &gt;= 60]">
        <a href="{@target}" class="break"><xsl:apply-templates/></a>
    </xsl:template>
    
    <xsl:template match="ref[@target][not(@type)][starts-with(normalize-space(.),'http')][string-length(normalize-space(.)) &lt; 60]">
        <a href="{@target}"><xsl:apply-templates/></a>
    </xsl:template>
    
    <xsl:template match="ref[@target][not(@type)][not(starts-with(normalize-space(.),'http'))]">
        <a href="{@target}" class="text-link"><xsl:apply-templates/></a>
    </xsl:template>
    
    <xsl:template match="ref[@target][@type='crossref']">
        <a href="{@target}" class="crossref"><xsl:apply-templates/></a>
    </xsl:template>
    
    <xsl:template match="body//code[string-length(normalize-space(.)) &lt; 60] | back//code[string-length(normalize-space(.)) &lt; 60] | body//eg">
        <span class="code"><xsl:apply-templates/></span>
    </xsl:template>
    
    <xsl:template match="body//code[string-length(normalize-space(.)) &gt;= 60] | back//code[string-length(normalize-space(.)) &gt;= 60]">
        <span class="code break"><xsl:apply-templates/></span>
    </xsl:template>
    
    
    
    <xsl:template match="body//note[starts-with(@xml:id,'ftn')]">
        <sup><a href="#{@xml:id}" class="internalref" id="fnid-{@xml:id}"><xsl:value-of select="substring-after(@xml:id,'ftn')"/></a></sup>
    </xsl:template>
    <xsl:template match="body//seg[@type='ftn']">
        <span class="ftn"><xsl:apply-templates/></span>
    </xsl:template>
    
    <!-- revisions -->
    <xsl:template match="body//mod">
        <xsl:variable name="change_id" select="substring-after(@change,'#')"/>
        <xsl:variable name="change-date" select="//revisionDesc//change[@xml:id=$change_id]/@when"/>
        <xsl:variable name="change-year" select="substring($change-date,1,4)"/>
        <xsl:variable name="change-month" select="substring($change-date,6,2)"/>
        <xsl:variable name="change-day" select="substring($change-date,9,2)"/>
        <span class="revision">
            <xsl:choose>
                <xsl:when test="$lang='de'"> Nachtrag vom <xsl:value-of select="$change-day"/>.<xsl:value-of select="$change-month"/>.<xsl:value-of select="$change-year"/>: </xsl:when>
                <xsl:otherwise> Revision <xsl:value-of select="$change-date"/>: </xsl:otherwise>
            </xsl:choose>
            <xsl:apply-templates/>
        </span>
    </xsl:template>
    
    <xsl:template match="body//mod//del">
        <span class="deletion"><xsl:apply-templates/></span>
    </xsl:template>
    
    <!-- bibliography -->
    <xsl:template match="back//bibl">
        <p class="bibl">
            <xsl:if test="@xml:id">
                <xsl:attribute name="id" select="@xml:id"/>
            </xsl:if>
            <xsl:apply-templates/>
        </p>
    </xsl:template>
    
    <xsl:template match="back//seg[@type='bibl-ref']">
        <span class="bibl-ref">
            <xsl:apply-templates/>
        </span>
    </xsl:template>
    
    <!-- ignore -->
    <xsl:template match="teiHeader//text()"/>    
    
    
    <!-- factsheet-templates -->
    <xsl:template name="factsheet">
        <xsl:param name="pos"/>
        <xsl:variable name="source" select="$sources[$pos]"/>
        <div class="factsheet">
            <h2>Factsheet</h2>
            <table class="factsheet">
                <tbody>
                    <tr>
                        <th colspan="2">Resource reviewed</th>
                    </tr>
                    <tr>
                        <th>Title</th>
                        <td><xsl:value-of select="$source/bibl/title/normalize-space()" /></td>
                    </tr>
                    <tr>
                        <th>Editors</th>
                        <td><xsl:value-of select="$source/bibl/editor/normalize-space()" /></td>
                    </tr>
                    <tr>
                        <xsl:variable name="res_URI" select="$source//idno[@type='URI']/normalize-space()" />
                        <th>URI</th>
                        <td><a href="{$res_URI}"><xsl:value-of select="$res_URI" /></a></td>
                    </tr>
                    <tr>
                        <th>Publication Date</th>
                        <td><xsl:value-of select="$source//date[@type='publication']" /></td>
                    </tr>
                    <tr>
                        <th>Date of last access</th>
                        <td><xsl:value-of select="local:format-date($source//date[@type='accessed'])" /></td>
                    </tr>
                </tbody>
            </table>
            <xsl:for-each select="//titleStmt//author">
                <table class="factsheet">
                    <tbody>
                        <tr>
                            <th colspan="2">Reviewer</th>
                        </tr>
                        <tr>
                            <th>Name</th>
                            <td>           
                                <xsl:choose>
                                    <xsl:when test="@ref != ''">
                                        <xsl:choose>
                                            <xsl:when test="@ref/contains(., 'orcid')">
                                                <a href="{@ref}"><img src="{concat($wdir,'/img/orcid-small.png')}" alt="orcid-icon" title="ORCID Identifier"
                                                    style="width:18px;"/></a>
                                                <xsl:text> </xsl:text>
                                            </xsl:when>
                                            <xsl:when test="@ref/contains(., 'gnd')">
                                                <a href="{@ref}"><img src="{concat($wdir,'/img/gnd-small.png')}" alt="gnd-icon" title="GND Identifier"
                                                    style="width:18px;"/></a>
                                                <xsl:text> </xsl:text>
                                            </xsl:when>
                                            <xsl:when test="@ref/contains(., 'viaf')">
                                                <a href="{@ref}"><img src="{concat($wdir,'/img/viaf-small.png')}" alt="viaf-icon" title="VIAF Identifier"
                                                    style="width:18px;"/></a>
                                                <xsl:text> </xsl:text>
                                            </xsl:when>
                                            <xsl:otherwise/>
                                        </xsl:choose>
                                    </xsl:when>
                                    <xsl:otherwise/>
                                </xsl:choose>
                                <xsl:value-of select="concat(.//surname, ', ', .//forename)" /></td>
                        </tr>
                        <xsl:if test=".//orgName/text()">
                            <tr>
                                <th>Affiliation</th>
                                <td>
                                    <xsl:value-of select=".//orgName" />
                                </td>
                            </tr>
                        </xsl:if>
                        <xsl:if test=".//placeName/text()">
                            <tr>
                                <th>Place</th>
                                <td><xsl:value-of select=".//placeName" /></td>
                            </tr>
                        </xsl:if>
                        <tr>
                            <th>Email</th>
                            <td><xsl:value-of select="replace(.//email, '@', ' (at) ')" /></td>
                        </tr>
                    </tbody>
                </table>
            </xsl:for-each>
            <table class="factsheet">
                <tbody>
                    <!-- category on the highest level -->
                    <xsl:for-each select="//taxonomy[$pos]/category">
                        <tr>
                            <th colspan="3"><xsl:value-of select="catDesc"/></th>
                        </tr>
                        <!-- category on the second level -->
                        <xsl:for-each select="category">
                            <tr>
                                <xsl:copy-of select="local:get-cat-desc-cols(current())" />
                                <xsl:choose>
                                    <xsl:when test="category/catDesc[.='Yes']">
                                        <!-- child categories with booleans -->
                                        <td><xsl:copy-of select="local:get-booleans(current())" /></td>
                                    </xsl:when>
                                    <xsl:when test="category and not(category/catDesc[.='Yes'])">
                                        <!-- child categories which are select options -->
                                        <td><xsl:copy-of select="local:get-select-values(current())" /></td>
                                    </xsl:when>
                                </xsl:choose>
                            </tr>
                        </xsl:for-each>
                    </xsl:for-each>
                    <xsl:if test="$source//respStmt">
                        <tr>
                            <th colspan="3">Personnel</th>
                        </tr>
                        <xsl:if test="$source//respStmt[resp='Editor']">
                            <xsl:copy-of select="local:get-resp-row($source, 'Editor')" />
                        </xsl:if>
                        <xsl:if test="$source//respStmt[resp='Encoder']">
                            <xsl:copy-of select="local:get-resp-row($source, 'Encoder')" />
                        </xsl:if>
                        <xsl:if test="$source//respStmt[resp='Programmer']">
                            <xsl:copy-of select="local:get-resp-row($source, 'Programmer')" />
                        </xsl:if>
                        <xsl:if test="$source//respStmt[resp='Advisor']">
                            <xsl:copy-of select="local:get-resp-row($source, 'Advisor')" />
                        </xsl:if>
                        <xsl:if test="$source//respStmt[resp='Designer']">
                            <xsl:copy-of select="local:get-resp-row($source, 'Designer')" />
                        </xsl:if>
                        <xsl:if test="$source//respStmt[resp='Administrator']">
                            <xsl:copy-of select="local:get-resp-row($source, 'Administrator')" />
                        </xsl:if>
                        <xsl:if test="$source//respStmt[resp='Contributor']">
                            <xsl:copy-of select="local:get-resp-row($source, 'Contributor')" />
                        </xsl:if>
                    </xsl:if>
                </tbody>
            </table>
        </div>
    </xsl:template>

   

</xsl:stylesheet>
