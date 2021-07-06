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
        last updated on 12 February 2021
        
        This is a component file of the RIDE scripts.
		RIDE scripts is free software: you can redistribute it and/or modify
		it under the terms of the GNU General Public License as published by
		the Free Software Foundation, either version 3 of the License, or
		(at your option) any later version, see http://www.gnu.org/licenses/.
    -->
    
        
    <!-- VARIABLES -->
    <xsl:variable name="wdir">/home/ulrike/Dokumente/IDE/Reviews/PDF-Export</xsl:variable><!-- absolute path to the working directory -->
    <xsl:variable name="outfolder">out</xsl:variable><!-- absolute or relative (to this XSLT) path to the output folder -->
    <xsl:variable name="lang" select="//langUsage/language/@ident"/>
    <xsl:variable name="review-shortcut" select="substring-before(tokenize(base-uri(.),'/')[last()],'-tei.xml')"/>
    <xsl:variable name="review-title" select="//teiHeader//titleStmt/title/normalize-space(.)"/>
    <xsl:variable name="base" select="//taxonomy/@xml:base" />
    <xsl:variable name="home" select="'http://ride.i-d-e.de/'" />
    <xsl:variable name="resource-type">
        <xsl:variable name="issue-type" select="//seriesStmt/biblScope[@unit='issue']"/>
        <xsl:choose>
            <xsl:when test="$issue-type='Digital Scholarly Editions'">editions</xsl:when>
            <xsl:when test="$issue-type='Digital Text Collections'">text-collections</xsl:when>
            <xsl:when test="$issue-type='Tools and Environments'">tools</xsl:when>
        </xsl:choose>
    </xsl:variable>
    <!-- questionnaire labels, selects, helptexts -->
    <xsl:variable name="labels-editions">
        <labels xmlns="http://ride.i-d-e.de/ns/local">
            <cat>
                <id>editor</id>
                <label>Editors</label>
            </cat>
            <cat>
                <id>resource_date_publication</id>
                <label>Publication Date</label>
            </cat>
            <cat>
                <id>bibl_desc</id>
                <label>Bibliographic description</label>
            </cat>
            <cat>
                <id>contributors</id>
                <label>Contributors</label>
            </cat>
            <cat>
                <id>contacts</id>
                <label>Contacts</label>
            </cat>
            <cat>
                <id>selection</id>
                <label>Selection of materials</label>
            </cat>
            <cat>
                <id>explained</id>
                <label>Explanation</label>
            </cat>
            <cat>
                <id>reasonable</id>
                <label>Reasonability</label>
            </cat>
            <cat>
                <id>data_archive</id>
                <label>Archiving of the data</label>
            </cat>
            <cat>
                <id>aims</id>
                <label>Aims</label>
            </cat>
            <cat>
                <id>methods</id>
                <label>Methods</label>
            </cat>
            <cat>
                <id>data_model</id>
                <label>Data Model</label>
            </cat>
            <cat>
                <id>help</id>
                <label>Help</label>
            </cat>
            <cat>
                <id>citation</id>
                <label>Citation</label>
            </cat>
            <cat>
                <id>complete</id>
                <label>Completion</label>
            </cat>
            <cat>
                <id>institutional_curation</id>
                <label>Institutional Curation</label>
            </cat>
            <cat>
                <id>previous_edition</id>
                <label>Previous Edition</label>
            </cat>
            <cat>
                <id>materials_used</id>
                <label>Materials Used</label>
            </cat>
            <cat>
                <id>introduction</id>
                <label>Introduction</label>
            </cat>
            <cat>
                <id>bibliography</id>
                <label>Bibliography</label>
            </cat>
            <cat>
                <id>commentary</id>
                <label>Commentary</label>
            </cat>
            <cat>
                <id>contexts</id>
                <label>Contexts</label>
            </cat>
            <cat>
                <id>images</id>
                <label>Images</label>
            </cat>
            <cat>
                <id>image_quality</id>
                <label>Image quality</label>
            </cat>
            <cat>
                <id>transcriptions</id>
                <label>Transcriptions</label>
            </cat>
            <cat>
                <id>text_quality</id>
                <label>Text quality</label>
            </cat>
            <cat>
                <id>indices</id>
                <label>Indices</label>
            </cat>
            <cat>
                <id>documents</id>
                <label>Documents</label>
            </cat>
            <cat>
                <id>doc_type</id>
                <label>Types of documents</label>
            </cat>
            <cat>
                <id>single_manuscript</id>
                <label>Single manuscript</label>
            </cat>
            <cat>
                <id>single_work</id>
                <label>Single work</label>
            </cat>
            <cat>
                <id>collection_of_texts</id>
                <label>Collection of texts</label>
            </cat>
            <cat>
                <id>collected_works</id>
                <label>Collected works</label>
            </cat>
            <cat>
                <id>papers</id>
                <label>Papers</label>
            </cat>
            <cat>
                <id>archival_holding</id>
                <label>Archival holding</label>
            </cat>
            <cat>
                <id>charters</id>
                <label>Charters</label>
            </cat>
            <cat>
                <id>letters</id>
                <label>Letters</label>
            </cat>
            <cat>
                <id>diary</id>
                <label>Diary</label>
            </cat>
            <cat>
                <id>doc_time</id>
                <label>Document era</label>
            </cat>
            <cat>
                <id>classics</id>
                <label>Classics</label>
            </cat>
            <cat>
                <id>medieval</id>
                <label>Medieval</label>
            </cat>
            <cat>
                <id>early_modern</id>
                <label>Early Modern</label>
            </cat>
            <cat>
                <id>modern</id>
                <label>Modern</label>
            </cat>
            <cat>
                <id>subject</id>
                <label>Subject</label>
            </cat>
            <cat>
                <id>history</id>
                <label>History</label>
            </cat>
            <cat>
                <id>philology_literary_studies</id>
                <label>Philology / Literary Studies</label>
            </cat>
            <cat>
                <id>philosophy_theology</id>
                <label>Philosophy / Theology</label>
            </cat>
            <cat>
                <id>history_of_science</id>
                <label>History of Science</label>
            </cat>
            <cat>
                <id>musicology</id>
                <label>Musicology</label>
            </cat>
            <cat>
                <id>art_history</id>
                <label>Art History</label>
            </cat>
            <cat>
                <id>spin_offs</id>
                <label>Spin-offs</label>
            </cat>
            <cat>
                <id>app</id>
                <label>App</label>
            </cat>
            <cat>
                <id>mobile</id>
                <label>Mobile</label>
            </cat>
            <cat>
                <id>PDF</id>
                <label>PDF</label>
            </cat>
            <cat>
                <id>browse_by</id>
                <label>Browse by</label>
            </cat>
            <cat>
                <id>authors</id>
                <label>Authors</label>
            </cat>
            <cat>
                <id>works</id>
                <label>Works</label>
            </cat>
            <cat>
                <id>versions</id>
                <label>Versions</label>
            </cat>
            <cat>
                <id>structure</id>
                <label>Structure</label>
            </cat>
            <cat>
                <id>pages</id>
                <label>Pages</label>
            </cat>
            <cat>
                <id>browse_by_documents</id>
                <label>Documents</label>
            </cat>
            <cat>
                <id>type_of_material</id>
                <label>Type of material</label>
            </cat>
            <cat>
                <id>browse_by_images</id>
                <label>Images</label>
            </cat>
            <cat>
                <id>dates</id>
                <label>Dates</label>
            </cat>
            <cat>
                <id>persons</id>
                <label>Persons</label>
            </cat>
            <cat>
                <id>places</id>
                <label>Places</label>
            </cat>
            <cat>
                <id>simple</id>
                <label>Simple</label>
            </cat>
            <cat>
                <id>advanced</id>
                <label>Advanced</label>
            </cat>
            <cat>
                <id>wildcard</id>
                <label>Wildcard</label>
            </cat>
            <cat>
                <id>index</id>
                <label>Index</label>
            </cat>
            <cat>
                <id>suggest</id>
                <label>Suggest functionalities</label>
            </cat>
            <cat>
                <id>helptext</id>
                <label>Helptext</label>
            </cat>
            <cat>
                <id>audience</id>
                <label>Audience</label>
            </cat>
            <cat>
                <id>scholars</id>
                <label>Scholars</label>
            </cat>
            <cat>
                <id>interested_public</id>
                <label>Interested public</label>
            </cat>
            <cat>
                <id>typology</id>
                <label>Typology</label>
            </cat>
            <cat>
                <id>facsimile_edition</id>
                <label>Facsimile Edition</label>
            </cat>
            <cat>
                <id>archive_edition</id>
                <label>Archive Edition</label>
            </cat>
            <cat>
                <id>documentary_edition</id>
                <label>Documentary Edition</label>
            </cat>
            <cat>
                <id>diplomatic_edition</id>
                <label>Diplomatic Edition</label>
            </cat>
            <cat>
                <id>genetic_edition</id>
                <label>Genetic Edition</label>
            </cat>
            <cat>
                <id>work_critical_edition</id>
                <label>Work Critical Edition</label>
            </cat>
            <cat>
                <id>text_critical_edition</id>
                <label>Text Critical Edition</label>
            </cat>
            <cat>
                <id>enriched_edition</id>
                <label>Enriched Edition</label>
            </cat>
            <cat>
                <id>database_edition</id>
                <label>Database Edition</label>
            </cat>
            <cat>
                <id>digital_library</id>
                <label>Digital Library</label>
            </cat>
            <cat>
                <id>typology_collection_of_texts</id>
                <label>Collection of Texts</label>
            </cat>
            <cat>
                <id>critical_editing</id>
                <label>Critical editing</label>
            </cat>
            <cat>
                <id>transmission_examined</id>
                <label>Transmission examined</label>
            </cat>
            <cat>
                <id>palaeographic_annotations</id>
                <label>Palaeographic annotations</label>
            </cat>
            <cat>
                <id>normalization</id>
                <label>Normalization</label>
            </cat>
            <cat>
                <id>variants</id>
                <label>Variants</label>
            </cat>
            <cat>
                <id>emendation</id>
                <label>Emendation</label>
            </cat>
            <cat>
                <id>commentary_notes</id>
                <label>Commentary notes</label>
            </cat>
            <cat>
                <id>standards</id>
                <label>Standards</label>
            </cat>
            <cat>
                <id>XML</id>
                <label>XML</label>
            </cat>
            <cat>
                <id>standardized_data_model</id>
                <label>Standardized data model</label>
            </cat>
            <cat>
                <id>text_type</id>
                <label>Types of text</label>
            </cat>
            <cat>
                <id>facsimiles</id>
                <label>Facsimiles</label>
            </cat>
            <cat>
                <id>diplomatic_transcription</id>
                <label>Diplomatic transcription</label>
            </cat>
            <cat>
                <id>edited_text</id>
                <label>Edited text</label>
            </cat>
            <cat>
                <id>translations</id>
                <label>Translations</label>
            </cat>
            <cat>
                <id>commentaries</id>
                <label>Commentaries</label>
            </cat>
            <cat>
                <id>semantic_data</id>
                <label>Semantic data</label>
            </cat>
            <cat>
                <id>persistent_identification</id>
                <label>Persistent Identification and Addressing</label>
            </cat>
            <cat>
                <id>DOI</id>
                <label>DOI</label>
            </cat>
            <cat>
                <id>ARK</id>
                <label>ARK</label>
            </cat>
            <cat>
                <id>URN</id>
                <label>URN</label>
            </cat>
            <cat>
                <id>PURL.ORG</id>
                <label>PURL.ORG</label>
            </cat>
            <cat>
                <id>persistent_URLs</id>
                <label>Persistent URLs</label>
            </cat>
            <cat>
                <id>interfaces</id>
                <label>Interfaces</label>
            </cat>
            <cat>
                <id>OAI-PMH</id>
                <label>OAI-PMH</label>
            </cat>
            <cat>
                <id>REST</id>
                <label>REST</label>
            </cat>
            <cat>
                <id>general_API</id>
                <label>General API</label>
            </cat>
            <cat>
                <id>open_access</id>
                <label>Open Access</label>
            </cat>
            <cat>
                <id>basic_data_accessible</id>
                <label>Accessibility of the basic data</label>
            </cat>
            <cat>
                <id>download</id>
                <label>Download</label>
            </cat>
            <cat>
                <id>reuse</id>
                <label>Reuse</label>
            </cat>
            <cat>
                <id>rights</id>
                <label>Rights</label>
            </cat>
            <cat>
                <id>declared</id>
                <label>Declared</label>
            </cat>
            <cat>
                <id>license</id>
                <label>License</label>
            </cat>
            <cat>
                <id>CC0</id>
                <label>CC0</label>
            </cat>
            <cat>
                <id>CC-BY</id>
                <label>CC-BY</label>
            </cat>
            <cat>
                <id>CC-BY-ND</id>
                <label>CC-BY-ND</label>
            </cat>
            <cat>
                <id>CC-BY-NC</id>
                <label>CC-BY-NC</label>
            </cat>
            <cat>
                <id>CC-BY-SA</id>
                <label>CC-BY-SA</label>
            </cat>
            <cat>
                <id>CC-BY-NC-ND</id>
                <label>CC-BY-NC-ND</label>
            </cat>
            <cat>
                <id>CC-BY-NC-SA</id>
                <label>CC-BY-NC-SA</label>
            </cat>
            <cat>
                <id>PDM</id>
                <label>PDM</label>
            </cat>
            <cat>
                <id>no_license</id>
                <label>No explicit license / all rights reserved</label>
            </cat>
        </labels>
    </xsl:variable>
    <xsl:variable name="selects-editions">
        <selects xmlns="http://ride.i-d-e.de/ns/local">
            <select>doc_type</select>
            <select>doc_time</select>
            <select>subject</select>
            <select>spin_offs</select>
            <select>browse_by</select>
            <select>audience</select>
            <select>typology</select>
            <select>critical_editing</select>
            <select>text_type</select>
            <select>persistent_identification</select>
            <select>interfaces</select>
            <select>license</select>
        </selects>
    </xsl:variable>
    
    <xsl:variable name="labels-text-collections">
        <labels xmlns="http://ride.i-d-e.de/ns/local">
            <!-- General information -->
            <cat>
                <id>editor</id>
                <label>Editors</label>
            </cat>
            <cat>
                <id>resource_date_publication</id>
                <label>Publication Date</label>
            </cat>
            <cat>
                <id>bibl_desc</id>
                <label>Bibliographic description</label>
            </cat>
            <cat>
                <id>contributors</id>
                <label>Contributors</label>
            </cat>
            <cat>
                <id>contacts</id>
                <label>Contacts</label>
            </cat>
            <!-- Aims -->
            <cat>
                <id>aims</id>
                <label>Aims</label>
            </cat>
            <cat>
                <id>doc_contents</id>
                <label>Documentation</label>
            </cat>
            <cat>
                <id>purpose</id>
                <label>Purpose</label>
            </cat>
            <cat>
                <id>research</id>
                <label>Research</label>
            </cat>
            <cat>
                <id>teaching</id>
                <label>Teaching</label>
            </cat>
            <cat>
                <id>general_purpose</id>
                <label>General purpose</label>
            </cat>
            <cat>
                <id>research_type</id>
                <label>Kind of research</label>
            </cat>
            <cat>
                <id>qualitative</id>
                <label>Qualitative research</label>
            </cat>
            <cat>
                <id>quantitative</id>
                <label>Quantitative research</label>
            </cat>
            <cat>
                <id>classification</id>
                <label>Self-classification</label>
            </cat>
            <cat>
                <id>collection</id>
                <label>Collection</label>
            </cat>
            <cat>
                <id>corpus</id>
                <label>Corpus</label>
            </cat>
            <cat>
                <id>digital_archive</id>
                <label>Digital Archive</label>
            </cat>
            <cat>
                <id>digital_library</id>
                <label>Digital Library</label>
            </cat>
            <cat>
                <id>digital_edition</id>
                <label>Digital Edition</label>
            </cat>
            <cat>
                <id>portal</id>
                <label>Portal</label>
            </cat>
            <cat>
                <id>database</id>
                <label>Database</label>
            </cat>
            <cat>
                <id>no_classification</id>
                <label>no classification given</label>
            </cat>
            <cat>
                <id>research_fields</id>
                <label>Field of research</label>
            </cat>
            <cat>
                <id>field_history</id>
                <label>History</label>
            </cat>
            <cat>
                <id>field_literary_studies</id>
                <label>Literary studies</label>
            </cat>
            <cat>
                <id>field_linguistics</id>
                <label>Linguistics</label>
            </cat>
            <cat>
                <id>field_musicology</id>
                <label>Musicology</label>
            </cat>
            <cat>
                <id>field_art_history</id>
                <label>Art history</label>
            </cat>
            <cat>
                <id>field_archaeology</id>
                <label>Archaeology</label>
            </cat>
            <cat>
                <id>field_philosophy</id>
                <label>Philosophy</label>
            </cat>
            <cat>
                <id>field_religious_studies</id>
                <label>Religious studies</label>
            </cat>
            <cat>
                <id>field_sociology</id>
                <label>Sociology</label>
            </cat>
            <!-- Content -->
            <cat>
                <id>content</id>
                <label>Content</label>
            </cat>
            <cat>
                <id>era</id>
                <label>Era</label>
            </cat>
            <cat>
                <id>era_classics</id>
                <label>Classics</label>
            </cat>
            <cat>
                <id>era_medieval</id>
                <label>Medieval</label>
            </cat>
            <cat>
                <id>era_early_modern</id>
                <label>Early Modern</label>
            </cat>
            <cat>
                <id>era_modern</id>
                <label>Modern</label>
            </cat>
            <cat>
                <id>era_contemporary</id>
                <label>Contemporary</label>
            </cat>
            <cat>
                <id>language</id>
                <label>Language</label>
            </cat>
            <cat>
                <id>arabic</id>
                <label>Arabic</label>
            </cat>
            <cat>
                <id>chinese</id>
                <label>Chinese</label>
            </cat>
            <cat>
                <id>danish</id>
                <label>Danish</label>
            </cat>
            <cat>
                <id>english</id>
                <label>English</label>
            </cat>
            <cat>
                <id>finnish</id>
                <label>Finnish</label>
            </cat>
            <cat>
                <id>french</id>
                <label>French</label>
            </cat>
            <cat>
                <id>german</id>
                <label>German</label>
            </cat>
            <cat>
                <id>greek</id>
                <label>Greek</label>
            </cat>
            <cat>
                <id>hebrew</id>
                <label>Hebrew</label>
            </cat>
            <cat>
                <id>hindi</id>
                <label>Hindi</label>
            </cat>
            <cat>
                <id>italian</id>
                <label>Italian</label>
            </cat>
            <cat>
                <id>japanese</id>
                <label>Japanese</label>
            </cat>
            <cat>
                <id>latin</id>
                <label>Latin</label>
            </cat>
            <cat>
                <id>norwegian</id>
                <label>Norwegian</label>
            </cat>
            <cat>
                <id>polish</id>
                <label>Polish</label>
            </cat>
            <cat>
                <id>portuguese</id>
                <label>Portuguese</label>
            </cat>
            <cat>
                <id>russian</id>
                <label>Russian</label>
            </cat>
            <cat>
                <id>spanish</id>
                <label>Spanish</label>
            </cat>
            <cat>
                <id>swedish</id>
                <label>Swedish</label>
            </cat>
            <cat>
                <id>turkish</id>
                <label>Turkish</label>
            </cat>
            <cat>
                <id>text_type</id>
                <label>Types of text</label>
            </cat>
            <cat>
                <id>literary_works</id>
                <label>Literary works</label>
            </cat>
            <cat>
                <id>private_documents</id>
                <label>Private documents</label>
            </cat>
            <cat>
                <id>essays</id>
                <label>Essays</label>
            </cat>
            <cat>
                <id>newspaper_articles</id>
                <label>Newspaper/journal articles</label>
            </cat>
            <cat>
                <id>charters</id>
                <label>Charters</label>
            </cat>
            <cat>
                <id>inscriptions</id>
                <label>Inscriptions</label>
            </cat>
            <cat>
                <id>files_records</id>
                <label>Files/Records</label>
            </cat>
            <cat>
                <id>protocols</id>
                <label>Protocols</label>
            </cat>
            <cat>
                <id>scientific_papers</id>
                <label>Scientific papers</label>
            </cat>
            <cat>
                <id>speech_transcripts</id>
                <label>Speech transcripts</label>
            </cat>
            <cat>
                <id>add_information</id>
                <label>Additional information</label>
            </cat>
            <cat>
                <id>introduction</id>
                <label>Introduction</label>
            </cat>
            <cat>
                <id>commentary</id>
                <label>Commentary</label>
            </cat>
            <cat>
                <id>context_material</id>
                <label>Context material</label>
            </cat>
            <cat>
                <id>bibliography</id>
                <label>Bibliography</label>
            </cat>
            <cat>
                <id>facsimile</id>
                <label>Facsimile</label>
            </cat>
            <!-- Composition -->
            <cat>
                <id>documentation_methods</id>
                <label>Documentation</label>
            </cat>
            <cat>
                <id>selection</id>
                <label>Selection</label>
            </cat>
            <cat>
                <id>selection_language</id>
                <label>Language</label>
            </cat>
            <cat>
                <id>selection_author</id>
                <label>Author</label>
            </cat>
            <cat>
                <id>selection_country</id>
                <label>Country</label>
            </cat>
            <cat>
                <id>selection_epoch</id>
                <label>Epoch</label>
            </cat>
            <cat>
                <id>selection_genre</id>
                <label>Genre</label>
            </cat>
            <cat>
                <id>selection_topic</id>
                <label>Topic</label>
            </cat>
            <cat>
                <id>selection_style</id>
                <label>Style</label>
            </cat>
            <cat>
                <id>selection_linguistic_characteristics</id>
                <label>Linguistic characteristics</label>
            </cat>
            <cat>
                <id>size</id>
                <label>Size</label>
            </cat>
            <cat>
                <id>size_texts</id>
                <label>Texts/records</label>
            </cat>
            <cat>
                <id>texts_le10</id>
                <label>&lt;= 10</label>
            </cat>
            <cat>
                <id>texts_11-50</id>
                <label>11-50</label>
            </cat>
            <cat>
                <id>texts_51-100</id>
                <label>51-100</label>
            </cat>
            <cat>
                <id>texts_gt100_</id>
                <label>&gt; 100</label>
            </cat>
            <cat>
                <id>texts_gt1000</id>
                <label>&gt; 1000</label>
            </cat>
            <cat>
                <id>texts_unknown</id>
                <label>unknown</label>
            </cat>
            <cat>
                <id>size_tokens</id>
                <label>Tokens</label>
            </cat>
            <cat>
                <id>tokens_lt100.000</id>
                <label>&lt; 100,000</label>
            </cat>
            <cat>
                <id>tokens_100.000-1mio</id>
                <label>100,000- 1 Mio.</label>
            </cat>
            <cat>
                <id>tokens_gt1mio</id>
                <label>&gt; 1 Mio.</label>
            </cat>
            <cat>
                <id>tokens_gt10mio</id>
                <label>&gt; 10 Mio.</label>
            </cat>
            <cat>
                <id>tokens_unknown</id>
                <label>unknown</label>
            </cat>
            <cat>
                <id>structure</id>
                <label>Structure</label>
            </cat>
            <cat>
                <id>acquisition</id>
                <label>Data acquisition and integration</label>
            </cat>
            <cat>
                <id>text_recording</id>
                <label>Text recording</label>
            </cat>
            <cat>
                <id>text_integration</id>
                <label>Text integration</label>
            </cat>
            <cat>
                <id>full_text</id>
                <label>Full texts</label>
            </cat>
            <cat>
                <id>reuse_metadata</id>
                <label>Metadata</label>
            </cat>
            <cat>
                <id>reuse_annotation</id>
                <label>Annotations</label>
            </cat>
            <cat>
                <id>quality</id>
                <label>Quality assurance</label>
            </cat>
            <cat>
                <id>typology</id>
                <label>Typology</label>
            </cat>
            <cat>
                <id>typology_general_purpose</id>
                <label>General purpose collection</label>
            </cat>
            <cat>
                <id>typology_corpus</id>
                <label>Corpus</label>
            </cat>
            <cat>
                <id>typology_collection_records</id>
                <label>Collection of records</label>
            </cat>
            <cat>
                <id>typology_canon</id>
                <label>Canon</label>
            </cat>
            <cat>
                <id>typology_oeuvre</id>
                <label>Complete works/œuvre</label>
            </cat>
            <cat>
                <id>typology_reference_corpus</id>
                <label>Reference corpus</label>
            </cat>
            <cat>
                <id>typology_contrastive_corpus</id>
                <label>Contrastive corpus</label>
            </cat>
            <cat>
                <id>typology_parallel_corpus</id>
                <label>Parallel corpus</label>
            </cat>
            <cat>
                <id>typology_diachronic_corpus</id>
                <label>Diachronic corpus</label>
            </cat>
            <!-- Data Modelling -->
            <cat>
                <id>data_modelling</id>
                <label>Data Modelling</label>
            </cat>
            <cat>
                <id>text_treatment</id>
                <label>Text treatment</label>
            </cat>
            <cat>
                <id>normalized_transcription</id>
                <label>Normalized transcription</label>
            </cat>
            <cat>
                <id>orthographic_transcription</id>
                <label>Orthographic transcription</label>
            </cat>
            <cat>
                <id>phonetic_transcription</id>
                <label>Phonetic/phonemic transcription</label>
            </cat>
            <cat>
                <id>diplomatic_transcription</id>
                <label>Diplomatic transcription</label>
            </cat>
            <cat>
                <id>transliteration</id>
                <label>Transliteration</label>
            </cat>
            <cat>
                <id>edited_text</id>
                <label>Edited text</label>
            </cat>
            <cat>
                <id>translated_text</id>
                <label>Translated text</label>
            </cat>
            <cat>
                <id>summarized_text</id>
                <label>Summarized text</label>
            </cat>
            <cat>
                <id>sampled_text</id>
                <label>Sampled text transcriptions</label>
            </cat>
            <cat>
                <id>basic_format</id>
                <label>Basic format</label>
            </cat>
            <cat>
                <id>plain_text</id>
                <label>Plain text</label>
            </cat>
            <cat>
                <id>xml</id>
                <label>XML</label>
            </cat>
            <cat>
                <id>html</id>
                <label>HTML</label>
            </cat>
            <cat>
                <id>annotation</id>
                <label>Annotations</label>
            </cat>
            <cat>
                <id>annotation_type</id>
                <label>Annotation type</label>
            </cat>
            <cat>
                <id>semantic_annotations</id>
                <label>Semantic annotations</label>
            </cat>
            <cat>
                <id>linguistic_annotations</id>
                <label>Linguistic annotations</label>
            </cat>
            <cat>
                <id>editorial_annotations</id>
                <label>Editorial annotations</label>
            </cat>
            <cat>
                <id>structural_information</id>
                <label>Structural information</label>
            </cat>
            <cat>
                <id>annotation_integration</id>
                <label>Annotation integration</label>
            </cat>
            <cat>
                <id>embedded</id>
                <label>Embedded</label>
            </cat>
            <cat>
                <id>stand-off</id>
                <label>Stand-off</label>
            </cat>
            <cat>
                <id>metadata</id>
                <label>Metadata</label>
            </cat>
            <cat>
                <id>metadata_type</id>
                <label>Metadata type</label>
            </cat>
            <cat>
                <id>descriptive</id>
                <label>Descriptive</label>
            </cat>
            <cat>
                <id>structural</id>
                <label>Structural</label>
            </cat>
            <cat>
                <id>administrative</id>
                <label>Administrative</label>
            </cat>
            <cat>
                <id>metadata_level</id>
                <label>Metadata level</label>
            </cat>
            <cat>
                <id>whole_collection</id>
                <label>Whole collection</label>
            </cat>
            <cat>
                <id>collection_parts</id>
                <label>Collection parts/components</label>
            </cat>
            <cat>
                <id>individual_texts</id>
                <label>Individual texts</label>
            </cat>
            <cat>
                <id>data_standards</id>
                <label>Data schemas and standards</label>
            </cat>
            <cat>
                <id>data_schema</id>
                <label>Schemas</label>
            </cat>
            <cat>
                <id>standardized_schema</id>
                <label>General standardized schema</label>
            </cat>
            <cat>
                <id>customized_standard_schema</id>
                <label>Customized standard schema</label>
            </cat>
            <cat>
                <id>project_specific</id>
                <label>Project specific schema</label>
            </cat>
            <cat>
                <id>standard_format</id>
                <label>Standards</label>
            </cat>
            <cat>
                <id>tei</id>
                <label>TEI</label>
            </cat>
            <cat>
                <id>cei</id>
                <label>CEI</label>
            </cat>
            <cat>
                <id>ead</id>
                <label>EAD</label>
            </cat>
            <cat>
                <id>xces</id>
                <label>(X)CES</label>
            </cat>
            <cat>
                <id>dublin_core</id>
                <label>Dublin Core</label>
            </cat>
            <cat>
                <id>edm</id>
                <label>EDM</label>
            </cat>
            <cat>
                <id>mets</id>
                <label>METS</label>
            </cat>
            <cat>
                <id>mods</id>
                <label>MODS</label>
            </cat>
            <cat>
                <id>skos</id>
                <label>SKOS</label>
            </cat>
            <cat>
                <id>owl</id>
                <label>OWL</label>
            </cat>
            <cat>
                <id>imdi</id>
                <label>IMDI</label>
            </cat>
            <cat>
                <id>cmdi</id>
                <label>CMDI</label>
            </cat>
            <cat>
                <id>tcf</id>
                <label>TCF</label>
            </cat>
            <cat>
                <id>olac</id>
                <label>OLAC</label>
            </cat>
            <cat>
                <id>eagles</id>
                <label>EAGLES</label>
            </cat>
            <cat>
                <id>pos_tagsets</id>
                <label>standardized PoS tagset(s)</label>
            </cat>
            <!-- Provision -->
            <cat>
                <id>provision</id>
                <label>Provision</label>
            </cat>
            <cat>
                <id>basic_data_accessible</id>
                <label>Accessability of the basic data</label>
            </cat>
            <cat>
                <id>download</id>
                <label>Download</label>
            </cat>
            <cat>
                <id>technical_interfaces</id>
                <label>Technical interfaces</label>
            </cat>
            <cat>
                <id>OAI-PMH</id>
                <label>OAI-PMH</label>
            </cat>
            <cat>
                <id>REST</id>
                <label>REST</label>
            </cat>
            <cat>
                <id>SPARQL_endpoint</id>
                <label>SPARQL endpoint</label>
            </cat>
            <cat>
                <id>general_API</id>
                <label>General API</label>
            </cat>
            <cat>
                <id>analytical_data</id>
                <label>Analytical data</label>
            </cat>
            <cat>
                <id>reuse</id>
                <label>Reuse</label>
            </cat>
            <!-- User interface -->
            <cat>
                <id>user_interface</id>
                <label>User interface</label>
            </cat>
            <cat>
                <id>user_interface_sub</id>
                <label>User Interface questions</label>
            </cat>
            <cat>
                <id>interface_provision</id>
                <label>Interface provision</label>
            </cat>
            <cat>
                <id>usability</id>
                <label>Usability</label>
            </cat>
            <cat>
                <id>access_modes</id>
                <label>Acces modes</label>
            </cat>
            <cat>
                <id>browsing</id>
                <label>Browsing</label>
            </cat>
            <cat>
                <id>full_text_search</id>
                <label>Fulltext search</label>
            </cat>
            <cat>
                <id>advanced_search</id>
                <label>Advanced search</label>
            </cat>
            <cat>
                <id>analysis</id>
                <label>Analysis</label>
            </cat>
            <cat>
                <id>analysis_tools</id>
                <label>Tools</label>
            </cat>
            <cat>
                <id>analysis_customization</id>
                <label>Customization</label>
            </cat>
            <cat>
                <id>visualization</id>
                <label>Visualization</label>
            </cat>
            <cat>
                <id>networks</id>
                <label>Networks</label>
            </cat>
            <cat>
                <id>charts</id>
                <label>Charts</label>
            </cat>
            <cat>
                <id>treemaps</id>
                <label>Treemaps</label>
            </cat>
            <cat>
                <id>wordclouds</id>
                <label>Wordclouds</label>
            </cat>
            <cat>
                <id>no_visualization</id>
                <label>no visualization</label>
            </cat>
            <cat>
                <id>personalization</id>
                <label>Personalization</label>
            </cat>
            <!-- Preservation -->
            <cat>
                <id>preservation</id>
                <label>Preservation</label>
            </cat>
            <cat>
                <id>documentation_project</id>
                <label>Documentation</label>
            </cat>
            <cat>
                <id>open_access</id>
                <label>Open Access</label>
            </cat>
            <cat>
                <id>rights</id>
                <label>Rights</label>
            </cat>
            <cat>
                <id>rights_declared</id>
                <label>Declared</label>
            </cat>
            <cat>
                <id>rights_license</id>
                <label>License</label>
            </cat>
            <cat>
                <id>CC0</id>
                <label>CC0</label>
            </cat>
            <cat>
                <id>CC-BY_only</id>
                <label>CC-BY</label>
            </cat>
            <cat>
                <id>CC-BY-ND</id>
                <label>CC-BY-ND</label>
            </cat>
            <cat>
                <id>CC-BY-NC</id>
                <label>CC-BY-NC</label>
            </cat>
            <cat>
                <id>CC-BY-SA</id>
                <label>CC-BY-SA</label>
            </cat>
            <cat>
                <id>CC-BY-NC-ND</id>
                <label>CC-BY-NC-ND</label>
            </cat>
            <cat>
                <id>CC-BY-NC-SA</id>
                <label>CC-BY-NC-SA</label>
            </cat>
            <cat>
                <id>PDM</id>
                <label>PDM</label>
            </cat>
            <cat>
                <id>no_license</id>
                <label>No explicit license / all rights reserved</label>
            </cat>
            <cat>
                <id>persistent_identification</id>
                <label>Persistent identification and addressing</label>
            </cat>
            <cat>
                <id>DOI</id>
                <label>DOI</label>
            </cat>
            <cat>
                <id>ARK</id>
                <label>ARK</label>
            </cat>
            <cat>
                <id>URN</id>
                <label>URN</label>
            </cat>
            <cat>
                <id>PURL.ORG</id>
                <label>PURL.ORG</label>
            </cat>
            <cat>
                <id>persistent_URLs</id>
                <label>Persistent URLs</label>
            </cat>
            <cat>
                <id>citation</id>
                <label>Citation</label>
            </cat>
            <cat>
                <id>archiving</id>
                <label>Archiving of the data</label>
            </cat>
            <cat>
                <id>curation</id>
                <label>Institutional curation</label>
            </cat>
            <cat>
                <id>completion</id>
                <label>Completion</label>
            </cat>
        </labels>
    </xsl:variable>
    <xsl:variable name="selects-text-collections">
        <selects xmlns="http://ride.i-d-e.de/ns/local">
            <select>purpose</select>
            <select>research_type</select>
            <select>classification</select>
            <select>research_fields</select>
            <select>era</select>
            <select>language</select>
            <select>text_type</select>
            <select>add_information</select>
            <select>selection</select>
            <select>size_texts</select>
            <select>size_tokens</select>
            <select>text_integration</select>
            <select>typology</select>
            <select>text_treatment</select>
            <select>basic_format</select>
            <select>annotation_type</select>
            <select>annotation_integration</select>
            <select>metadata_type</select>
            <select>metadata_level</select>
            <select>data_schema</select>
            <select>standard_format</select>
            <select>technical_interfaces</select>
            <select>visualization</select>
            <select>rights_license</select>
            <select>persistent_identification</select>
        </selects>
    </xsl:variable>
    
    <xsl:variable name="labels-tools">
        <labels xmlns="http://ride.i-d-e.de/ns/local">
            <!-- General information -->
            <cat>
                <id>editor</id>
                <label>Editors</label>
            </cat>
            <cat>
                <id>resource_date_publication</id>
                <label>Publication Date</label>
            </cat>
            <cat>
                <id>bibl_desc</id>
                <label>Bibliographic description</label>
            </cat>
            <cat>
                <id>contributors</id>
                <label>Contributors</label>
            </cat>
            <cat>
                <id>contacts</id>
                <label>Contacts</label>
            </cat>
            <cat>
                <id>software_type</id>
                <label>Type of reviewed software</label>
            </cat>
            <cat>
                <id>software_tool</id>
                <label>Tool</label>
            </cat>
            <cat>
                <id>software_vre</id>
                <label>VRE</label>
            </cat>
            <cat>
                <id>identification_environment</id>
                <label>Environment/platform</label>
            </cat>
            <cat>
                <id>identification_os</id>
                <label>Operating System</label>
            </cat>
            <cat>
                <id>identification_browser</id>
                <label>Web-browser</label>
            </cat>
            <cat>
                <id>identification_other</id>
                <label>Another Application</label>
            </cat>
            <cat>
                <id>purpose</id>
                <label>Purpose</label>
            </cat>
            <cat>
                <id>purpose_general</id>
                <label>General purpose</label>
            </cat>
            <cat>
                <id>purpose_specific</id>
                <label>Specific purpose</label>
            </cat>
            <cat>
                <id>funding</id>
                <label>Funding</label>
            </cat>
            <cat>
                <id>funding_free</id>
                <label>Free</label>
            </cat>
            <cat>
                <id>funding_support</id>
                <label>Supported</label>
            </cat>
            <cat>
                <id>funding_paywall</id>
                <label>Beyond Paywall</label>
            </cat>
            <cat>
                <id>maturity</id>
                <label>Maturity</label>
            </cat>
            <cat>
                <id>maturity_release</id>
                <label>Release</label>
            </cat>
            <cat>
                <id>maturity_beta</id>
                <label>Beta</label>
            </cat>
            <cat>
                <id>maturity_alpha</id>
                <label>Alpha</label>
            </cat>
            <!-- Methods -->
            <cat>
                <id>programming_lang</id>
                <label>Programming language(s)</label>
            </cat>
            <cat>
                <id>programming_lang_c</id>
                <label>C family</label>
            </cat>
            <cat>
                <id>programming_lang_java</id>
                <label>Java</label>
            </cat>
            <cat>
                <id>programming_lang_python</id>
                <label>Python</label>
            </cat>
            <cat>
                <id>programming_lang_php</id>
                <label>PHP</label>
            </cat>
            <cat>
                <id>programming_lang_r</id>
                <label>R</label>
            </cat>
            <cat>
                <id>programming_lang_ruby</id>
                <label>Ruby</label>
            </cat>
            <cat>
                <id>programming_lang_xslt</id>
                <label>XSLT/XQuery</label>
            </cat>
            <cat>
                <id>reuse</id>
                <label>Reuse</label>
            </cat>
            <cat>
                <id>input_format</id>
                <label>Input format</label>
            </cat>
            <cat>
                <id>input_format_xml</id>
                <label>XML</label>
            </cat>
            <cat>
                <id>input_format_xml-tei</id>
                <label>XML-TEI</label>
            </cat>
            <cat>
                <id>input_format_txt</id>
                <label>txt</label>
            </cat>
            <cat>
                <id>input_format_pdf</id>
                <label>PDF</label>
            </cat>
            <cat>
                <id>input_format_csv</id>
                <label>csv</label>
            </cat>
            <cat>
                <id>input_format_html</id>
                <label>HTML</label>
            </cat>
            <cat>
                <id>input_format_json</id>
                <label>JSON</label>
            </cat>
            <cat>
                <id>input_format_rdf</id>
                <label>RDF</label>
            </cat>
            <cat>
                <id>output_format</id>
                <label>Output format</label>
            </cat>
            <cat>
                <id>output_format_xml</id>
                <label>XML</label>
            </cat>
            <cat>
                <id>output_format_xml-tei</id>
                <label>XML-TEI</label>
            </cat>
            <cat>
                <id>output_format_txt</id>
                <label>txt</label>
            </cat>
            <cat>
                <id>output_format_pdf</id>
                <label>PDF</label>
            </cat>
            <cat>
                <id>output_format_csv</id>
                <label>csv</label>
            </cat>
            <cat>
                <id>output_format_html</id>
                <label>HTML</label>
            </cat>
            <cat>
                <id>output_format_json</id>
                <label>JSON</label>
            </cat>
            <cat>
                <id>output_format_rdf</id>
                <label>RDF</label>
            </cat>
            <cat>
                <id>encoding</id>
                <label>Encoding</label>
            </cat>
            <cat>
                <id>encoding_latin-1</id>
                <label>latin-1</label>
            </cat>
            <cat>
                <id>encoding_utf-8</id>
                <label>utf-8</label>
            </cat>
            <cat>
                <id>encoding_utf-16</id>
                <label>utf-16</label>
            </cat>
            <cat>
                <id>encoding_preprocessing</id>
                <label>Preprocessing</label>
            </cat>
           
            <cat>
                <id>dependencies</id>
                <label>Dependencies</label>
            </cat>
            <cat>
                <id>dependencies_installation</id>
                <label>Dependencies installation</label>
            </cat>
            <cat>
                <id>documentation</id>
                <label>Documentation</label>
            </cat>
            <cat>
                <id>documentation_format</id>
                <label>Format of documentation</label>
            </cat>
            <cat>
                <id>documentation_format_readme</id>
                <label>readme</label>
            </cat>
            <cat>
                <id>documentation_format_txt</id>
                <label>txt</label>
            </cat>
            <cat>
                <id>documentation_format_html</id>
                <label>HTML</label>
            </cat>
            <cat>
                <id>documentation_format_pdf</id>
                <label>PDF</label>
            </cat>
            <cat>
                <id>documentation_section</id>
                <label>Sections of documentation</label>
            </cat>
            <cat>
                <id>documentation_section_getting</id>
                <label>Getting-started (installation and configuration)</label>
            </cat>
            <cat>
                <id>documentation_section_step</id>
                <label>Step-by-step instructions</label>
            </cat>
            <cat>
                <id>documentation_section_example</id>
                <label>Examples</label>
            </cat>
            <cat>
                <id>documentation_section_troubleshooting</id>
                <label>Troubleshooting</label>
            </cat>
            <cat>
                <id>documentation_section_faq</id>
                <label>FAQ</label>
            </cat>
            <cat>
                <id>documentation_section_support</id>
                <label>Support section</label>
            </cat>
            <cat>
                <id>documentation_section_api</id>
                <label>API documentation</label>
            </cat>
                       <cat>
                <id>documentation_language</id>
                <label>Language of documentation</label>
            </cat>
            <cat>
                <id>documentation_language_arabic</id>
                <label>Arabic</label>
            </cat>
            <cat>
                <id>documentation_language_chinese</id>
                <label>Chinese</label>
            </cat>
            <cat>
                <id>documentation_language_danish</id>
                <label>Danish</label>
            </cat>
            <cat>
                <id>documentation_language_english</id>
                <label>English</label>
            </cat>
            <cat>
                <id>documentation_language_finnish</id>
                <label>Finnish</label>
            </cat>
            <cat>
                <id>documentation_language_french</id>
                <label>French</label>
            </cat>
            <cat>
                <id>documentation_language_german</id>
                <label>German</label>
            </cat>
            <cat>
                <id>documentation_language_greek</id>
                <label>Greek</label>
            </cat>
            <cat>
                <id>documentation_language_hebrew</id>
                <label>Hebrew</label>
            </cat>
            <cat>
                <id>documentation_language_hindi</id>
                <label>Hindi</label>
            </cat>
            <cat>
                <id>documentation_language_italian</id>
                <label>Italian</label>
            </cat>
            <cat>
                <id>documentation_language_japanese</id>
                <label>Japanese</label>
            </cat>
            <cat>
                <id>documentation_language_latin</id>
                <label>Latin</label>
            </cat>
            <cat>
                <id>documentation_language_norwegian</id>
                <label>Norwegian</label>
            </cat>
            <cat>
                <id>documentation_language_polish</id>
                <label>Polish</label>
            </cat>
            <cat>
                <id>documentation_language_portuguese</id>
                <label>Portuguese</label>
            </cat>
            <cat>
                <id>documentation_language_russian</id>
                <label>Russian</label>
            </cat>
            <cat>
                <id>documentation_language_spanish</id>
                <label>Spanish</label>
            </cat>
            <cat>
                <id>documentation_language_swedish</id>
                <label>Swedish</label>
            </cat>
            <cat>
                <id>documentation_language_turkish</id>
                <label>Turkish</label>
            </cat>
            <cat>
                <id>support</id>
                <label>Active Support</label>
            </cat>
            <cat>
                <id>support_form</id>
                <label>Type of support</label>
            </cat>
            <cat>
                <id>support_form_help</id>
                <label>Help desk</label>
            </cat>
            <cat>
                <id>support_form_forum</id>
                <label>Forum</label>
            </cat>
            <cat>
                <id>support_form_mailinglist</id>
                <label>Mailing list</label>
            </cat>
            <cat>
                <id>tracker</id>
                <label>Bug/issue tracker</label>
            </cat>
            <cat>
                <id>build</id>
                <label>Build and install (personal learning curve)</label>
            </cat>
            <cat>
                <id>build_straightforward</id>
                <label>Straightforward</label>
            </cat>
            <cat>
                <id>build_normal</id>
                <label>Normal</label>
            </cat>
            <cat>
                <id>build_tricky</id>
                <label>Tricky</label>
            </cat>
            <cat>
                <id>test</id>
                <label>Testing</label>
            </cat>
            <cat>
                <id>platform_deploy</id>
                <label>Deployment on platforms</label>
            </cat>
            <cat>
                <id>platform_deploy_linux</id>
                <label>Linux</label>
            </cat>
            <cat>
                <id>platform_deploy_mac</id>
                <label>Mac</label>
            </cat>
            <cat>
                <id>platform_deploy_android</id>
                <label>Android</label>
            </cat>
            <cat>
                <id>platform_deploy_ios</id>
                <label>ios</label>
            </cat>
            <cat>
                <id>platform_deploy_windows</id>
                <label>Windows</label>
            </cat>
            <cat>
                <id>devices_deploy</id>
                <label>Deployment on devices</label>
            </cat>
            <cat>
                <id>devices_deploy_desktop</id>
                <label>Deployment on desktop</label>
            </cat>
            <cat>
                <id>devices_deploy_laptop</id>
                <label>Deployment on laptop</label>
            </cat>
            <cat>
                <id>devices_deploy_smartphone</id>
                <label>Deployment on smartphone</label>
            </cat>
            <cat>
                <id>devices_deploy_tablet</id>
                <label>Deployment on tablet</label>
            </cat>
            <cat>
                <id>devices_deploy_smartboard</id>
                <label>Deployment on smartboard</label>
            </cat>
            <cat>
                <id>browser_deploy</id>
                <label>Deployment on browser</label>
            </cat>
            <cat>
                <id>browser_deploy_mozilla</id>
                <label>Mozilla</label>
            </cat>
            <cat>
                <id>browser_deploy_chrome</id>
                <label>Chrome</label>
            </cat>
            <cat>
                <id>browser_deploy_safari</id>
                <label>Safari</label>
            </cat>
            <cat>
                <id>browser_plugin</id>
                <label>Browser plugin</label>
            </cat>
            <cat>
                <id>api</id>
                <label>API</label>
            </cat>
            <cat>
                <id>code</id>
                <label>Code</label>
            </cat>
            <cat>
                <id>license</id>
                <label>License</label>
            </cat>
            <cat>
                <id>license_gpl</id>
                <label>GNU/GPL</label>
            </cat>
            <cat>
                <id>license_lgpl</id>
                <label>GNU/LGPL</label>
            </cat>
            <cat>
                <id>license_apache</id>
                <label>Apache</label>
            </cat>
            <cat>
                <id>license_mit</id>
                <label>MIT</label>
            </cat>
            <cat>
                <id>license_mozilla</id>
                <label>Mozilla</label>
            </cat>
            <cat>
                <id>license_cc0</id>
                <label>CC0</label>
            </cat>
            <cat>
                <id>license_ccby</id>
                <label>CC-BY</label>
            </cat>
            <cat>
                <id>license_ccbynd</id>
                <label>CC-BY-ND</label>
            </cat>
            <cat>
                <id>license_ccbync</id>
                <label>CC-BY-NC</label>
            </cat>
            <cat>
                <id>license_ccbysa</id>
                <label>CC-BY-SA</label>
            </cat>
            <cat>
                <id>license_ccbyncnd</id>
                <label>CC-BY-NC-ND</label>
            </cat>
            <cat>
                <id>license_ccbyncsa</id>
                <label>CC-BY-NC-SA</label>
            </cat>
            <cat>
                <id>license_notexplicit</id>
                <label>Not explicit</label>
            </cat>
            <cat>
                <id>Credit</id>
                <label>Credit</label>
            </cat>
            <cat>
                <id>registered</id>
                <label>Registered in software repository</label>
            </cat>
            <cat>
                <id>registered_contribute</id>
                <label>Contributing possible</label>
            </cat>
            <cat>
                <id>analyzed</id>
                <label>Code Analysability</label>
            </cat>
            <cat>
                <id>extended</id>
                <label>Code Extensibility</label>
            </cat>
            <cat>
                <id>reused</id>
                <label>Code Reusability</label>
            </cat>
            <cat>
                <id>security</id>
                <label>Information of security/privacy</label>
            </cat>
            <cat>
                <id>maintenance</id>
                <label>Maintenance</label>
            </cat>
            <cat>
                <id>citability</id>
                <label>Citability</label>
            </cat>
            <cat>
                <id>user</id>
                <label>User group</label>
            </cat>
            <cat>
                <id>user_researcher</id>
                <label>Researcher</label>
            </cat>
            <cat>
                <id>user_scientist</id>
                <label>Scientists</label>
            </cat>
            <cat>
                <id>user_humanist</id>
                <label>Humanists</label>
            </cat>
            <cat>
                <id>user_public</id>
                <label>Public</label>
            </cat>
            <cat>
                <id>user_interaction</id>
                <label>User interaction</label>
            </cat>
            <cat>
                <id>user_interaction_reading</id>
                <label>Reading</label>
            </cat>
            <cat>
                <id>user_interaction_text</id>
                <label>Text editing</label>
            </cat>
            <cat>
                <id>user_interaction_analysis</id>
                <label>Text analysis</label>
            </cat>
            <cat>
                <id>user_interaction_image</id>
                <label>Image editing</label>
            </cat>
            <cat>
                <id>user_interaction_searching</id>
                <label>Searching</label>
            </cat>
            <cat>
                <id>user_interaction_visualization</id>
                <label>Visualization</label>
            </cat>
            <cat>
                <id>user_interaction_comparing</id>
                <label>Comparing</label>
            </cat>
            <cat>
                <id>user_interaction_compiling</id>
                <label>Compiling</label>
            </cat>
            <cat>
                <id>user_interface</id>
                <label>User Interface</label>
            </cat>
            <cat>
                <id>user_interface_gui</id>
                <label>Graphical User Interface</label>
            </cat>
            <cat>
                <id>user_interface_cli</id>
                <label>Command Line Interface</label>
            </cat>
            <cat>
                <id>user_interface_api</id>
                <label>API</label>
            </cat>
            <cat>
                <id>visualization</id>
                <label>Visualization</label>
            </cat>
            <cat>
                <id>empowerment</id>
                <label>User Empowerment</label>
            </cat>
            <cat>
                <id>accessibility</id>
                <label>Accessibility</label>
            </cat>
        </labels>
    </xsl:variable>
    <xsl:variable name="selects-tools">
        <selects xmlns="http://ride.i-d-e.de/ns/local">
            <select>software_type</select>
            <select>identification_environment</select>
            <select>purpose</select>
            <select>funding</select>
            <select>maturity</select>
            <select>programming_lang</select>
            <select>reuse</select>
            <select>input_format</select>
            <select>output_format</select>
            <select>encoding</select>
            <select>encoding_preprocessing</select>
            <select>dependencies</select>
            <select>dependencies_installation</select>
            <select>documentation</select>
            <select>documentation_format</select>
            <select>documentation_section</select>
            <select>documentation_language</select>
            <select>support</select>
            <select>support_form</select>
            <select>tracker</select>
            <select>build</select>
            <select>test</select>
            <select>platform_deploy</select>
            <select>devices_deploy</select>
            <select>browser_deploy</select>
            <select>browser_plugin</select>
            <select>api</select>
            <select>code</select>
            <select>license</select>
            <select>credit</select>
            <select>registered</select>
            <select>registered_contribute</select>
            <select>analyzed</select>
            <select>extended</select>
            <select>reused</select>
            <select>security</select>
            <select>maintenance</select>
            <select>citability</select>
            <select>user</select>
            <select>user_interaction</select>
            <select>user_interface</select>
            <select>visualization</select>
            <select>empowerment</select>
            <select>accessibility</select>
        </selects>
    </xsl:variable>
    
    <xsl:variable name="labels">
        <xsl:choose>
            <xsl:when test="$resource-type='editions'">
                <xsl:copy-of select="$labels-editions"/>
            </xsl:when>
            <xsl:when test="$resource-type='text-collections'">
                <xsl:copy-of select="$labels-text-collections"/>
            </xsl:when>
            <xsl:when test="$resource-type='tools'">
                <xsl:copy-of select="$labels-tools"/>
            </xsl:when>
        </xsl:choose>
    </xsl:variable>
    <xsl:variable name="selects">
        <xsl:choose>
            <xsl:when test="$resource-type='editions'">
                <xsl:copy-of select="$selects-editions"/>
            </xsl:when>
            <xsl:when test="$resource-type='text-collections'">
                <xsl:copy-of select="$selects-text-collections"/>
            </xsl:when>
            <xsl:when test="$resource-type='tools'">
                <xsl:copy-of select="$selects-tools"/>
            </xsl:when>
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
    
    <xsl:function name="local:get-label">
        <xsl:param name="id" />
        <xsl:value-of select="$labels//local:cat[matches($id, concat('^(rev\d-)?', local:id, '$'))]/local:label" />
    </xsl:function>
    
    <xsl:function name="local:get-cat-desc-cols">
        <xsl:param name="cat" />
        <xsl:param name="mode" />
        <th><xsl:if test="$cat/category and not($cat/catDesc) and not(exists($selects//local:select[matches($cat/@xml:id, concat('^(rev\d-)?',.,'$'))]))">
            <xsl:attribute name="colspan">2</xsl:attribute>
        </xsl:if>
            <xsl:choose>
                <xsl:when test="$mode = 'indent'">
                    <span class="indent"><xsl:value-of select="local:get-label($cat/@xml:id)" /></span>
                </xsl:when>
                <xsl:when test="$mode = 'indent2'">
                    <span class="indent2"><xsl:value-of select="local:get-label($cat/@xml:id)" /></span>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="local:get-label($cat/@xml:id)" />
                </xsl:otherwise>
            </xsl:choose></th>
        <td><xsl:if test="$cat/category and $cat/catDesc and not(exists($selects//local:select[matches($cat/@xml:id, concat('^(rev\d-)?',.,'$'))]))">
            <xsl:attribute name="colspan">2</xsl:attribute>
        </xsl:if>
            <div><xsl:value-of select="$cat/catDesc[not(num) and not(ref)]" /></div>
            <xsl:if test="$cat/catDesc[ref]">
                <xsl:choose>
                    <xsl:when test="contains($cat/catDesc/ref,'and')">
                        <div>(<a href="{$base}{$cat/catDesc[ref]/ref/substring-before(@target,' ')}"><xsl:value-of select="$cat/catDesc[ref]/ref/substring-before(.,' and')" /></a>
                            and <a href="{$base}{$cat/catDesc[ref]/ref/substring-after(@target,' ')}"><xsl:value-of select="$cat/catDesc[ref]/ref/substring-after(.,'and ')" /></a>)</div>
                    </xsl:when>
                    <xsl:otherwise>
                        <div>(<a href="{$base}{$cat/catDesc[ref]/ref/@target}"><xsl:value-of select="$cat/catDesc[ref]/ref" /></a>)</div>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:if>
        </td>
    </xsl:function>
    
    <xsl:function name="local:get-booleans">
        <xsl:param name="cat" />
        <xsl:choose>
            <xsl:when test="$cat/catDesc[num]/num/@value='1'">yes</xsl:when>
            <xsl:when test="$cat/catDesc[num]/num/@value='2'">not applicable</xsl:when>
            <xsl:when test="$cat/catDesc[num]/num/@value='3'">unknown</xsl:when>
            <xsl:when test="$cat/catDesc[num]/num/@value='0'">no</xsl:when>
        </xsl:choose>
    </xsl:function>
    
    <xsl:function name="local:get-select-values">
        <xsl:param name="cat" />
        <xsl:for-each select="$cat/category[.//num/@value = '1'][not(@corresp = '#other')]">
            <xsl:value-of select="local:get-label(@xml:id)" />
            <xsl:if test="position() != last()">, </xsl:if>
        </xsl:for-each>
        <xsl:if test="$cat/category[@corresp='#other'][.//num/@value = '1']">
            <xsl:if test="$cat/category[.//num/@value = '1'][not(@corresp = '#other')]">, </xsl:if>
            other<xsl:if test="$cat/category[@corresp='#other']/category[@corresp='#free'] != ''">:<xsl:text> </xsl:text>
                <xsl:value-of select="$cat/category[@corresp='#other']/category[@corresp='#free']/desc" />
            </xsl:if>
        </xsl:if>
        <xsl:if test="$cat/category[@corresp='#none'][.//num/@value = '1']">
            none
        </xsl:if>
        <xsl:if test="$cat/category[@corresp='#unknown'][.//num/@value = '1']">
            unknown
        </xsl:if>
        <xsl:if test="$cat/category[@corresp='#not_applicable'][.//num/@value = '1']">
            not applicable
        </xsl:if>
    </xsl:function>
    
    <xsl:function name="local:get-resp-row">
        <xsl:param name="context" />
        <xsl:param name="role" />
        <tr>
            <th><xsl:value-of select="$role" />s</th>
            <td colspan="2">
                <xsl:for-each select="$context//respStmt[resp=$role]">
                    <xsl:sort select="resp" />
                    <xsl:value-of select=".//persName" />
                    <xsl:if test="position() != last()"><br /></xsl:if>
                </xsl:for-each>
            </td>
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
    font-size: 1.2em;
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

p.code-example {
    text-align: left;
    font-size: 0.9em;
}
span.code-caption {
    display: block;
    text-align: center;
    font-size: 0.9em;
    page-break-before: avoid;
    margin-top: 0.5em;
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
                        <h2><a href="https://ride.i-d-e.de/">ride. A review journal for digital editions and resources</a></h2>
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
        <div><xsl:apply-templates/></div>
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
                        <td><xsl:value-of select="$source/bibl/title" /></td>
                    </tr>
                    <tr>
                        <th>Editors</th>
                        <td><xsl:value-of select="$source/bibl/editor" /></td>
                    </tr>
                    <tr>
                        <xsl:variable name="res_URI" select="$source//idno[@type='URI']" />
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
                            <th>Surname</th>
                            <td><xsl:value-of select=".//surname" /></td>
                        </tr>
                        <tr>
                            <th>First Name</th>
                            <td><xsl:value-of select=".//forename" /></td>
                        </tr>
                        <xsl:if test=".//orgName/text()">
                            <tr>
                                <th>Organization</th>
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
                            <th colspan="3">
                                <xsl:choose>
                                    <xsl:when test="$resource-type='tools'">
                                        <xsl:if test="matches(@xml:id,'^(rev\d-)?methods$')">
                                            <xsl:text>Methods and implementation</xsl:text>
                                        </xsl:if>
                                        <xsl:if test="matches(@xml:id,'^(rev\d-)?general_information$')">
                                            <xsl:text>General information</xsl:text>
                                        </xsl:if>
                                        <xsl:if test="matches(@xml:id,'^(rev\d-)?usability$')">
                                            <xsl:text>Usability, sustainability and maintainability</xsl:text>
                                        </xsl:if>
                                        <xsl:if test="matches(@xml:id,'^(rev\d-)?interaction$')">
                                            <xsl:text>User interaction, GUI and visualization</xsl:text>
                                        </xsl:if> 
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:value-of select="for $part in tokenize(@xml:id, '_') return concat(upper-case(substring($part,1,1)), substring($part,2))" />
                                    </xsl:otherwise>
                                </xsl:choose>
                            </th>
                        </tr>
                        <!-- category on the second level -->
                        <xsl:for-each select="category">
                            <tr>
                                <xsl:choose>
                                    <xsl:when test="not(catDesc)">
                                        <td colspan="3">
                                            <strong><xsl:value-of select="local:get-label(@xml:id)" /></strong>
                                        </td>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:copy-of select="local:get-cat-desc-cols(current(), 'left')" />
                                    </xsl:otherwise>
                                </xsl:choose>
                                <xsl:choose>
                                    <xsl:when test="not(category)">
                                        <!-- no further child categories -->
                                        <td><xsl:copy-of select="local:get-booleans(current())" /></td>
                                    </xsl:when>
                                    <xsl:when test="category and exists($selects//local:select[matches(current()/@xml:id, concat('^(rev\d-)?',.,'$'))])">
                                        <!-- child categories which are select options -->
                                        <td><xsl:copy-of select="local:get-select-values(current())" /></td>
                                    </xsl:when>
                                </xsl:choose>
                            </tr>
                            <!-- child categories which are not select options -->
                            <xsl:if test="category and not(exists($selects//local:select[matches(current()/@xml:id, concat('^(rev\d-)?',.,'$'))]))">
                                <xsl:for-each select="category">
                                    <tr>
                                        <xsl:copy-of select="local:get-cat-desc-cols(current(), 'indent')" />
                                        <xsl:choose>
                                            <!-- no further child categories -->
                                            <xsl:when test="not(category)">
                                                <td><xsl:copy-of select="local:get-booleans(current())" /></td>
                                            </xsl:when>
                                            <!-- child categories which are select options -->
                                            <xsl:when test="category and exists($selects//local:select[matches(current()/@xml:id, concat('^(rev\d-)?',.,'$'))])">
                                                <td><xsl:copy-of select="local:get-select-values(current())" /></td>
                                            </xsl:when>
                                        </xsl:choose>
                                    </tr>
                                    <xsl:if test="category and not(exists($selects//local:select[matches(current()/@xml:id, concat('^(rev\d-)?',.,'$'))]))">
                                        <xsl:for-each select="category">
                                            <tr>
                                                <xsl:copy-of select="local:get-cat-desc-cols(current(), 'indent2')" />
                                                <!-- no further child categories -->
                                                <xsl:if test="not(category)">
                                                    <td><xsl:copy-of select="local:get-booleans(current())" /></td>
                                                </xsl:if>
                                                <!-- child category which are select options -->
                                                <xsl:if test="category and exists($selects//local:select[matches(current()/@xml:id, concat('^(rev\d-)?',.,'$'))])">
                                                    <td><xsl:copy-of select="local:get-select-values(current())" /></td>
                                                </xsl:if>
                                            </tr>
                                        </xsl:for-each>
                                    </xsl:if>
                                </xsl:for-each>
                            </xsl:if>
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
