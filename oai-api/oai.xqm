xquery version "3.0";

(:~
:This is a component file of the RIDE scripts.
:RIDE scripts is free software: you can redistribute it and/or modify
:it under the terms of the GNU General Public License as published by
:the Free Software Foundation, either version 3 of the License, or
:(at your option) any later version, see &lt;http://www.gnu.org/licenses/&gt;.
:)
module namespace oaiinterface="http://ride.i-d-e.de/NS/oai-interface";

declare namespace oai="http://www.openarchives.org/OAI/2.0/";
declare namespace xsl="http://www.w3.org/1999/XSL/Transform";
declare namespace util="http://exist-db.org/xquery/util";
declare namespace tei="http://www.tei-c.org/ns/1.0";

(:  XML-Output :)
declare option exist:serialize "method=xml media-type=text/xml omit-xml-declaration=no";

(: URIs for DB - platform-base-uri is only used for headerXSL and contentXSL :)
declare variable $oaiinterface:db-base-uri := "/db/apps/ride-oai";
declare variable $oaiinterface:db-base-collection := "/reviews";
declare variable $oaiinterface:base-uri := "http://ride.i-d-e.de/apis/oai";
declare variable $oaiinterface:xslt-uri := concat($oaiinterface:db-base-uri, "/xslt");


(: ############################################################################ service ############################################################################################ 
http://ride.i-d-e.de/apis/oai
:)
declare function oaiinterface:service(){
      let $function-pointer := function-lookup(xs:QName('oaiinterface:transform'), 3)
	  (: get OAI- data :)
	  let $oai-response := oaiinterface:main($oaiinterface:db-base-collection, $oaiinterface:base-uri, $function-pointer)
	  let $return-option := util:declare-option("exist:serialize", "method=xml media-type=text/xml omit-xml-declaration=no")
	  return
	  	$oai-response
};


(: ############################################################################ transformation function ############################################################################ :)

(: create OAI record (head and body) :)
declare function oaiinterface:transform($verb as xs:string, $document as node()*, $metadata-prefix as xs:string) as node()*{
    (: XSLT for the head :)
    let $header-xsl := collection($oaiinterface:xslt-uri)//xsl:stylesheet[@xml:id ='oai-header']
    (: XSLT for the body :)
    let $content-xsl := if(compare($metadata-prefix,"oai_dc") = 0) then
                            collection($oaiinterface:xslt-uri)//xsl:stylesheet[@xml:id ='oai-dc']
                        else if(compare($metadata-prefix,"oai_marcxml") = 0) then
                            collection($oaiinterface:xslt-uri)//xsl:stylesheet[@xml:id ='oai-marcxml']
                        else collection($oaiinterface:xslt-uri)//xsl:stylesheet[@xml:id ='oai-dc']
    
    (: XSLT parameters :)
    let $xsl-header-params := <parameters />
    let $xsl-content-params := <parameters />
    (: transformation to the metadata format :)
    let $transformed-object := if($verb = "ListRecords" or $verb = "GetRecord") then
                                <record xmlns="http://www.openarchives.org/OAI/2.0/">
                                    {(transform:transform($document, $header-xsl, $xsl-header-params),
                                     transform:transform($document, $content-xsl, $xsl-content-params))}
                                 </record>
                              else
                                 transform:transform($document, $header-xsl, $xsl-header-params)
    return $transformed-object   
};
    
(: ----- params from OAI-PMH spec ---------- :)
declare variable $oaiinterface:verb                := request:get-parameter("verb","0");
declare variable $oaiinterface:identifier          := request:get-parameter("identifier","0");
declare variable $oaiinterface:resumption-token     := request:get-parameter("resumptionToken","0");
declare variable $oaiinterface:metadata-prefix      := if(fn:compare($oaiinterface:resumption-token,"0")=0)then
                                                        request:get-parameter("metadataPrefix","0")
                                                      else
                                                        substring-before(substring-after($oaiinterface:resumption-token, "\"), "\"); 
declare variable $oaiinterface:set                 := request:get-parameter("set","0");
declare variable $oaiinterface:from                := request:get-parameter("from","0");
declare variable $oaiinterface:until               := request:get-parameter("until","0");
declare variable $oaiinterface:parameters          := request:get-parameter-names();
(: ---------------------------------------- :)

(: ------------- platform specific params ---------- :)
(: Variable to identify and validate resumptionToken :)
declare variable $oaiinterface:resumption-token-prefix := "oai:ride:";

(: platform specific variables for verb "Identify":)                                                            
declare variable $oaiinterface:admin-email := "ride-editor@i-d-e.de";
declare variable $oaiinterface:repository-name := "ride. A review journal for digital editions and resources";

declare variable $oaiinterface:delete-records := "no";
declare variable $oaiinterface:protocol-version := "2.0";
(: Date variables - datePattern is used to compare until/from- dates :)
declare variable $oaiinterface:granularity := "YYYY-MM-DD";
declare variable $oaiinterface:date-pattern := "^(\d{4}-\d{2}-\d{2})$";
(: available metadataFormats :)
declare variable $oaiinterface:metadata-formats :=
            <ListMetadataFormats xmlns="http://www.openarchives.org/OAI/2.0/">
                <metadataFormat>
                    <metadataPrefix>oai_marcxml</metadataPrefix>
                    <schema>http://www.loc.gov/MARC21/slim http://www.loc.gov/standards/marcxml/schema/MARC21slim.xsd</schema>
                    <metadataNamespace>http://www.loc.gov/MARC21/slim</metadataNamespace>
                </metadataFormat>
                <metadataFormat>
                    <metadataPrefix>oai_dc</metadataPrefix>
                    <schema>http://www.openarchives.org/OAI/2.0/oai_dc/ http://www.openarchives.org/OAI/2.0/oai_dc.xsd</schema>
                    <metadataNamespace>http://www.openarchives.org/OAI/2.0/oai_dc/</metadataNamespace>
                </metadataFormat>
            </ListMetadataFormats>;
(: Attribute of the document to compare the from/until parameters :)            
declare variable $oaiinterface:tag-to-compare-date := "when";
(: Attribute of the document to compare the identifier parameter :)
declare variable $oaiinterface:tag-to-compare-id := "xml:id";
(: XPath to the attribute of the document to compare the identifier parameter :)
declare variable $oaiinterface:path-to-compare-id := "//tei:TEI/@xml:id";
(: Maximum number of documents before resumptionToken is returned :)
declare variable $oaiinterface:number-to-export := 20;

(: platform specific function to determine the date of a document to compare, should return xs:date :)
declare function oaiinterface:get-date-to-compare($document as node()) as xs:date {
    (: get publication date and add -DD to it :)
    let $publication_date := $document//tei:publicationStmt/tei:date/@when/concat(.,"-01") cast as xs:date
    let $revision_dates := for $date in $document//tei:revisionDesc//tei:change/@when return xs:date($date)
    let $all_dates := ($publication_date, $revision_dates)
    (: get the latest of all the dates in the document :)
    let $latest_date := max($all_dates)[1]
    return $latest_date
};


(: ---------------------------------------- :)


(: validate both dates:)
declare function oaiinterface:validate-dates() {
    let $oaiinterface:from-len     := string-length($oaiinterface:from)
    let $oaiinterface:until-len    := string-length($oaiinterface:until)
    return
        if ($oaiinterface:from-len > 0 and $oaiinterface:until-len > 0 and $oaiinterface:from-len != $oaiinterface:until-len) then
            false()
        else
            matches($oaiinterface:from, $oaiinterface:date-pattern) and matches($oaiinterface:until, $oaiinterface:date-pattern)
};

(: validate 'from'- dates:)
declare function oaiinterface:validate-from-date() {
    let $oaiinterface:from-len     := string-length($oaiinterface:from)
    return
        if ($oaiinterface:from-len = 0) then
            false()
        else
            matches($oaiinterface:from, $oaiinterface:date-pattern)
};

(: validate 'until'- dates:)
declare function oaiinterface:validate-until-date() {
    let $oaiinterface:until-len     := string-length($oaiinterface:until)
    return
        if ($oaiinterface:until-len = 0) then
            false()
        else
            matches($oaiinterface:until, $oaiinterface:date-pattern)
};

(: validate metadataPrefix:)
declare function oaiinterface:validate-metadata-prefix() {
    let $formats-available := $oaiinterface:metadata-formats//oai:metadataPrefix/text()
    return
       if(empty(index-of($formats-available, $oaiinterface:metadata-prefix))) then
               true() 
       else false()
};

(: validate resumption token:)
declare function oaiinterface:validate-res-token() {
    let $res-tok-len   := string-length($oaiinterface:resumption-token)
    return
        if ($res-tok-len = 0) then
            false()
        else
            starts-with($oaiinterface:resumption-token, $oaiinterface:resumption-token-prefix) 
};

(: define earliest datestamp :)
declare function oaiinterface:find-earliest-datestamp($oai-collections as xs:string*) {
    (: collect all digital objects :)
    let $all-documents := 
                    for $oai-collection in $oai-collections
                    return
                        collection(concat($oaiinterface:db-base-uri, $oai-collection))
    let $all-dates := 
                        for $document in $all-documents
                            return
                                oaiinterface:get-date-to-compare($document)
    let $earliest-datestamp := min($all-dates)
        return
            $earliest-datestamp
};

(: validate parameters :)
declare function oaiinterface:validate-params($oai-collections as xs:string*, $base-url as xs:string, $function-pointer as function(item()*) as item()*) as node()*{

let $errors :=

if(not(fn:compare($oaiinterface:set,"0")=0)) then <error code="noSetHierarchy" xmlns="http://www.openarchives.org/OAI/2.0/">No set structure available</error> 

else if((fn:compare($oaiinterface:resumption-token,"0")!=0)) then
    if(not(oaiinterface:validate-res-token()))then 
        <error code="badResumptionToken" xmlns="http://www.openarchives.org/OAI/2.0/">Resumption Token is not valid</error>
    else()

else if($oaiinterface:verb  = "ListSets") then <error code="noSetHierarchy" xmlns="http://www.openarchives.org/OAI/2.0/">No set structure available</error>

else if($oaiinterface:verb  = "ListIdentifiers" or $oaiinterface:verb  ="ListRecords") then
      let $earliest-datestamp := oaiinterface:find-earliest-datestamp($oai-collections)
      return
        if(fn:compare($oaiinterface:metadata-prefix,"0")=0) then <error code="badArgument" xmlns="http://www.openarchives.org/OAI/2.0/">The parameter metadataPrefix is required</error>
        else if(oaiinterface:validate-metadata-prefix()) then <error code="cannotDisseminateFormat" xmlns="http://www.openarchives.org/OAI/2.0/">Metadata format is not available</error> 
        else if(fn:compare($oaiinterface:from,"0")!=0 and fn:compare($oaiinterface:until,"0")!=0) then
             if(not(oaiinterface:validate-dates())) then <error code="badArgument" xmlns="http://www.openarchives.org/OAI/2.0/">No valid date format</error>
             else if($oaiinterface:until cast as xs:date < $earliest-datestamp)
                  then <error code="noRecordsMatch" xmlns="http://www.openarchives.org/OAI/2.0/">date of until parameter is lower than the earliest datestamp</error>
             else if($oaiinterface:from cast as xs:date > current-dateTime() cast as xs:date)
                  then <error code="noRecordsMatch" xmlns="http://www.openarchives.org/OAI/2.0/">date of from- parameter is a future date</error>
             else()
        else if(fn:compare($oaiinterface:from,"0")!=0 and fn:compare($oaiinterface:until,"0")=0) then 
             if(not(oaiinterface:validate-from-date())) then <error code="badArgument" xmlns="http://www.openarchives.org/OAI/2.0/">No valid from- date format</error>
             else if($oaiinterface:from cast as xs:date > current-dateTime() cast as xs:date)
                  then <error code="noRecordsMatch" xmlns="http://www.openarchives.org/OAI/2.0/">date of from- parameter is a future date</error>
             else()
        else if(fn:compare($oaiinterface:from,"0")=0 and fn:compare($oaiinterface:until,"0")!=0) then 
             if(not(oaiinterface:validate-until-date())) then <error code="badArgument" xmlns="http://www.openarchives.org/OAI/2.0/">No valid until- date format</error>
             else if($oaiinterface:until cast as xs:date < $earliest-datestamp)
                  then <error code="noRecordsMatch" xmlns="http://www.openarchives.org/OAI/2.0/">date of until parameter is lower than the earliest datestamp</error>
             else()
        else ()
      
else if($oaiinterface:verb  ="Identify") then
        if(count($oaiinterface:parameters)>1) then <error code="badArgument" xmlns="http://www.openarchives.org/OAI/2.0/">No further arguments allowed</error> 
        else()
        
else if($oaiinterface:verb  ="ListMetadataFormats") then
         if (count($oaiinterface:parameters)>1)then 
                if(fn:compare($oaiinterface:identifier,"0")=0) then <error code="badArgument" xmlns="http://www.openarchives.org/OAI/2.0/">Argument is not allowed</error>
                else()
         else()

else if($oaiinterface:verb  ="GetRecord")then
      if(fn:compare($oaiinterface:metadata-prefix,"0")=0) then <error code="badArgument" xmlns="http://www.openarchives.org/OAI/2.0/">The parameter metadataPrefix is required</error>
      else if(oaiinterface:validate-metadata-prefix()) then <error code="cannotDisseminateFormat" xmlns="http://www.openarchives.org/OAI/2.0/">Metadata format is not available</error>
      else if(fn:compare($oaiinterface:identifier,"0")=0) then <error code="badArgument" xmlns="http://www.openarchives.org/OAI/2.0/">The parameter identifier is required</error>
      else()
      
else <error code="badVerb" xmlns="http://www.openarchives.org/OAI/2.0/">No valid request type</error>
return
    if(empty($errors)) then
         (: handle parameters to produce a response:)
         oaiinterface:response($oai-collections, $base-url, $function-pointer)
    else
        $errors
};

(: select and return documents according to oai-from/until parameters :)
declare function oaiinterface:select-documents($all-documents as node()*, $oai-from as xs:string, $oai-until as xs:string) as node()*{
    for $document in $all-documents
        return
        (: compare date variables :)
        if(fn:compare($oai-from,"0")!=0 or fn:compare($oai-until,"0")!=0) 
        then
            if(fn:compare($oai-from,"0")!=0 and fn:compare($oai-until,"0")!=0) 
            then
                let $oai-from := $oai-from cast as xs:date
                let $oai-until := $oai-until cast as xs:date
                return
                    if($oai-from <= oaiinterface:get-date-to-compare($document) and $oai-until >= oaiinterface:get-date-to-compare($document)) 
                    then
                        (: select document :)
                        $document
                    else()  
            else if(fn:compare($oai-from,"0")!=0 and fn:compare($oai-until,"0")=0)
            then
                let $oai-from := $oai-from cast as xs:date
                return 
                    if($oai-from <= oaiinterface:get-date-to-compare($document))
                    then
                        (: select document :)
                        $document
                    else()  
            else if(fn:compare($oai-from,"0")=0 and fn:compare($oai-until,"0")!=0)
            then
                let $oai-until := $oai-until cast as xs:date
                return    
                    if($oai-until >= oaiinterface:get-date-to-compare($document))
                    then
                        (: select document :)
                        $document
                    else()
            else()                                  
        else $document
};

(: transform digital objects to metadata prefix format :)
declare function oaiinterface:oai-transform($oai-from as xs:string, $oai-until as xs:string, $oai-collections as xs:string*, $function-pointer as function(item()*) as item()*) as node()*{
(: index for resumptionToken :)
let $index := 
              if(fn:compare($oaiinterface:resumption-token,"0")=0)then
                    0
              else oaiinterface:search-res-point($oai-collections, $oai-from, $oai-until)
let $index-to-compare := if ($index = 0) then 1 else $index
let $cursor := if ($index = 0) then 0 else $index - 1
(: collect all digital objects :)
let $all-documents := 
                    for $oai-collection in $oai-collections
                    return
                        collection(concat($oaiinterface:db-base-uri, $oai-collection))
let $selected-documents := oaiinterface:select-documents($all-documents, $oai-from, $oai-until)
let $num-documents := count($selected-documents)
return
    (: validate index of resumptionToken :)
    if(empty($index))then <error code="badResumptionToken" xmlns="http://www.openarchives.org/OAI/2.0/">Resumption Token is not valid</error>
    else
        for $document at $number in $selected-documents
        return
                (: export only defined number of documents :)
                if($number >= $index and $number < $index-to-compare+$oaiinterface:number-to-export)
                then 
                        (: call function to transform :)
                        (util:call($function-pointer, $oaiinterface:verb, $document, $oaiinterface:metadata-prefix),
                        (: last document? if there was a resumption token before, return an empty resumption token now :)
                        if ($number = $num-documents and $index != 0)
                            then <resumptionToken xmlns="http://www.openarchives.org/OAI/2.0/" completeListSize="{$num-documents}" cursor="{$cursor}"/>
                            else ())
                (: max number of exported objects reached and list not finished? - then produce a resumptionToken:)
                else if($number = ($index-to-compare+$oaiinterface:number-to-export)) then
                   let $compare_exp := concat("$document", $oaiinterface:path-to-compare-id)
                   return
                   <resumptionToken xmlns="http://www.openarchives.org/OAI/2.0/" completeListSize="{$num-documents}" cursor="{$cursor}">{$oaiinterface:resumption-token-prefix}\{$oaiinterface:metadata-prefix}\{util:eval($compare_exp)/xmldb:encode(data(.))}\{$oaiinterface:from}\{$oaiinterface:until}</resumptionToken>
                else()            
};

(: Search for identfier of the resumption token in the list of records:)
declare function oaiinterface:search-res-point($oai-collections as xs:string*, $oai-from as xs:string, $oai-until as xs:string) as xs:integer*{
    (: extract the identifier :)
    let $res-identity := xmldb:encode(substring-before(substring-after(substring-after($oaiinterface:resumption-token, "\"), "\"), "\"))
    (: collect all digital objects :)
    let $all-documents := 
                    for $oai-collection in $oai-collections
                    return
                        collection(concat($oaiinterface:db-base-uri, $oai-collection))
    let $selected-documents := oaiinterface:select-documents($all-documents, $oai-from, $oai-until)
    (: search for identifier :)
    for $document at $number in $selected-documents
    let $compare_exp := concat("$document", $oaiinterface:path-to-compare-id)
    return
       if (xmldb:encode(util:eval($compare_exp)) = $res-identity) then $number
       else()
};

(: handle parameters to produce a response:)
declare function oaiinterface:response($oai-collections as xs:string*, $base-url as xs:string, $function-pointer as function(item()*) as item()*) as node()*{ 
    if($oaiinterface:verb  ="Identify")
       then
            let $earliest-datestamp := oaiinterface:find-earliest-datestamp($oai-collections)
                return
                (: identify the data provider:)
                <Identify xmlns="http://www.openarchives.org/OAI/2.0/">
                    <repositoryName>{$oaiinterface:repository-name}</repositoryName>
                    <baseURL>{$base-url}</baseURL>
                    <protocolVersion>{$oaiinterface:protocol-version}</protocolVersion>
                    <adminEmail>{$oaiinterface:admin-email}</adminEmail>
                    <earliestDatestamp>{$earliest-datestamp}</earliestDatestamp>
                    <deletedRecord>{$oaiinterface:delete-records}</deletedRecord>
                    <granularity>{$oaiinterface:granularity}</granularity>
                </Identify>
            
    else if($oaiinterface:verb  ="ListMetadataFormats")
        then
        if (count($oaiinterface:parameters)=1)
            then
            (: list the metadata format, actually vdu/mom only uses the ese format :)
            $oaiinterface:metadata-formats
           (: placeholder for more metadata formats in database - check the identifier:) 
         else 
            let $record := oaiinterface:search-identifier($oai-collections)
            return
                if(not(empty($record)))then
                    $oaiinterface:metadata-formats
                else <error code="idDoesNotExist" xmlns="http://www.openarchives.org/OAI/2.0/">Identifier does not exist</error>

    else if($oaiinterface:verb  = "ListRecords" or $oaiinterface:verb  = "ListIdentifiers")
    then 
            (: List records (in addiction to the until/ from parameter) :)
            let $hits := 
                    if(fn:compare($oaiinterface:resumption-token,"0")=0) then
                        oaiinterface:oai-transform($oaiinterface:from, $oaiinterface:until, $oai-collections, $function-pointer)
                    else 
                         let $oaiinterface:metadata-prefix := substring-before(substring-after($oaiinterface:resumption-token, "\"), "\")
                         let $res-from := substring-before(substring-after(substring-after(substring-after($oaiinterface:resumption-token, "\"), "\"), "\"), "\")
                         let $res-until := substring-after(substring-after(substring-after(substring-after($oaiinterface:resumption-token, "\"), "\"), "\"), "\")
                         return
                         oaiinterface:oai-transform($res-from, $res-until, $oai-collections, $function-pointer)
             return
                  if(empty($hits/child::*))then 
                        if(fn:compare($oaiinterface:resumption-token,"0")=0) then
                            <error code="noRecordsMatch" xmlns="http://www.openarchives.org/OAI/2.0/">No records match</error>
                         else
                            <error code="badResumptionToken" xmlns="http://www.openarchives.org/OAI/2.0/">Resumption Token is not valid</error>
                  else
                        if($oaiinterface:verb  = "ListRecords")then
                            <ListRecords xmlns="http://www.openarchives.org/OAI/2.0/">{$hits}</ListRecords> 
                        else
                            <ListIdentifiers xmlns="http://www.openarchives.org/OAI/2.0/">{$hits}</ListIdentifiers>                        
                          
    else if($oaiinterface:verb  ="GetRecord")
    then
        let $record := oaiinterface:search-identifier($oai-collections)
        return
            (: Get a single record with the identifier parameter :)
            if(not(empty($record)))then
                <GetRecord xmlns="http://www.openarchives.org/OAI/2.0/">
                     {(: call function to transform :) util:call($function-pointer, $oaiinterface:verb, $record, $oaiinterface:metadata-prefix)}
               </GetRecord>
            else <error code="idDoesNotExist" xmlns="http://www.openarchives.org/OAI/2.0/">Identifier does not exist</error>
        else <error code="badVerb" xmlns="http://www.openarchives.org/OAI/2.0/">No valid request type</error>
};

(: search identifier in collections :)
declare function oaiinterface:search-identifier($oai-collections as xs:string*){
let $record := 
    for $oai-collection in $oai-collections
        return
            let $compare_exp := concat("collection(concat($oaiinterface:db-base-uri, $oai-collection))", $oaiinterface:path-to-compare-id, "[xmldb:encode(data(.)) = xmldb:encode($oaiinterface:identifier)]")
            return
                root(util:eval($compare_exp))
return
    $record
};

(: main function as starting point of the response- process :)
(: Param $oai-collection as specific path to recources in DB/ Param $base-url as baseURL of the OAI- Interface:)
declare function oaiinterface:main($oai-collections as xs:string*, $base-url as xs:string, $function-pointer as function(item()*) as item()*){
    (: OAI- PMH informations - have to be defined :)
    <OAI-PMH xmlns="http://www.openarchives.org/OAI/2.0/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.openarchives.org/OAI/2.0/ http://www.openarchives.org/OAI/2.0/OAI-PMH.xsd">
    <responseDate>{current-dateTime()}</responseDate>
    <request> {(for $parameter in $oaiinterface:parameters
                return
                    attribute {$parameter}{request:get-parameter(string($parameter),0)})
                ,$base-url}</request>
    {
    (: check parameters and produce a response:)
    oaiinterface:validate-params($oai-collections, $base-url, $function-pointer)
    }
     </OAI-PMH>
};
