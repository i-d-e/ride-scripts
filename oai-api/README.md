# RIDE OAI-PMH interface

The metadata about all the reviews published in RIDE can be retrieved via an OAI-PMH interface (Open Archives Initiative Protocol for Metadata Harvesting). The interface can be reached at https://ride.i-d-e.de/apis/oai.

## What does it do?

The script takes TEI files of RIDE reviews as input and generates metadata output following the standard of the Open Archives Initiative Protocol for Metadata Harvesting.

At the interface, the RIDE metadata is offered in two XML-based formats:

* OAI Dublin Core (Dublin Core Metadata Element Set; schema: http://www.openarchives.org/OAI/2.0/oai_dc.xsd)
* MARC 21-XML (XML variant of MARC 21; schema: http://www.loc.gov/standards/marcxml/schema/MARC21slim.xsd)

The interface does not support sets and deleted objects are not sustained.

Examples for queries:

* https://ride.i-d-e.de/apis/oai?verb=Identify
* https://ride.i-d-e.de/apis/oai?verb=ListMetadataFormats
* https://ride.i-d-e.de/apis/oai?verb=ListIdentifiers&metadataPrefix=oai_dc
* https://ride.i-d-e.de/apis/oai?verb=ListRecords&metadataPrefix=oai_dc
* https://ride.i-d-e.de/apis/oai?verb=GetRecord&metadataPrefix=oai_dc&identifier=ride.4.2

## Software you need:
* an instance of eXist-db (version 5.2.0)

## License
The code is published under the GNU General Public License v3.0.

## Contact
Ulrike Henny-Krahmer, ulrike.henny@web.de
