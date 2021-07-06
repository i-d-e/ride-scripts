xquery version "3.0";
            
import module namespace oaiinterface="http://ride.i-d-e.de/NS/oai-interface" at "xmldb:exist:///db/apps/ride-oai/oai.xqm"; 


declare variable $exist:path external;
declare variable $exist:resource external;
declare variable $exist:controller external;
declare variable $exist:prefix external;
declare variable $exist:root external;

if (starts-with($exist:path, "/api"))
then oaiinterface:service()
else

(: everything is passed through :)
<dispatch xmlns="http://exist.sourceforge.net/NS/exist">
    <cache-control cache="yes"/>
</dispatch>