#!/usr/bin/env python3
# -*- coding: utf-8 -*-
# Filename: reviews_to_pdf.py

"""

Convert ride reviews from TEI to PDF.

This is a component file of the RIDE scripts.
RIDE scripts is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version, see http://www.gnu.org/licenses/.

  
@author: Ulrike Henny-Krahmer
  
"""


from os.path import join
from os.path import basename
from weasyprint import HTML
import glob
import re
import subprocess

"""
ADAPT THESE VARIABLES:
"""
# general working directory:
wdir = "/home/ulrike/Git/ride-tech/tei2pdf/"
# directory with the TEI input files:
inpath = "/home/ulrike/Git/ride-tech/tei2pdf/in/"
# directory for outputs (relative to the working directory):
outpath = join(wdir, "out")
# path to the saxon installation (to the .jar file):
saxon_path = "/home/ulrike/Programme/saxon/saxon9he.jar"
# path to the XSLT file to use for transformation (relative to the working directory, does not need to be changed):
xsl_path = join(wdir, "review-to-pdf.xsl")


"""
THIS DOES (PROBABLY) NOT NEED TO BE CHANGED:
"""
for infile_path in glob.glob(join(inpath,"*.xml")):
	
	print("doing " + infile_path + "...")
	
	
	# prepare the TEI file
	"""
	Some TEI structures are changed here with regular expressions to prepare for the PDF output:
	- lists, block quotes, figures, and tables are moved out of paragraphs
	- footnote numbers are wrapped in segments together with preceding text
	- the last link in each bibliographic entry is wrapped in a segment
	"""
	with open(infile_path, "r", encoding="UTF-8") as infile:
		
		intext = infile.read()
		newtext = re.sub(r"<cit>", r"</p><cit>", intext)
		newtext = re.sub(r"</cit>", r"</cit><p>", newtext)
		newtext = re.sub(r"<body>[\s\n]+</p>", r"<body>", newtext, flags=re.MULTILINE)
		newtext = re.sub(r"<p>[\s\n]+<div", r"<div", newtext, flags=re.MULTILINE)
		newtext = re.sub(r"<list\s", r"</p><list ", newtext)
		newtext = re.sub(r"</list>", r"</list><p>", newtext)
		newtext = re.sub(r"(<item>[^<]*?(<ref[^<]*?</ref>)?[^<]*?)</p>", r"\1", newtext, flags=re.DOTALL|re.MULTILINE)
		newtext = re.sub(r"<p>[\s\n]+</item>", r"</item>", newtext)
		newtext = re.sub(r"<cell>[\s\n]*</p>", r"<cell>", newtext, flags=re.MULTILINE)
		newtext = re.sub(r"<p>[\s\n]*</cell>", r"</cell>", newtext, flags=re.MULTILINE)
		newtext = re.sub(r'(<figure[\s\n]+xml:id="code\d+">.*?</figure>)', r"</p>\1<p>", newtext, flags=re.DOTALL|re.MULTILINE)
		newtext = re.sub(r"<p>[\s\n]*</p>", r"", newtext)
		newtext = re.sub(r'<p xml:id="(p\d+)">[\s\n]*</p>(.*?)<p>', r'\2 <p xml:id="\1">', newtext, flags=re.DOTALL|re.MULTILINE)
		newtext = re.sub(r"(<ref[^<]*?</ref>\.?)[\n\s]*</bibl>", r"<seg type='bibl-ref'>\1</seg></bibl>", newtext,flags=re.DOTALL|re.MULTILINE)
		newtext = re.sub(r"([\w\)]+[\.;]<note.*?</note>)", r"<seg type='ftn'>\1</seg>", newtext, flags=re.DOTALL|re.MULTILINE)
		
		infile_name = basename(infile_path)
		outfile_path = join(outpath, infile_name)
		
		with open(outfile_path, "w", encoding="UTF-8") as outfile:
			
			outfile.write(newtext)
		
			
	# run XSLT on TEI file to produce HTML and CSS file
	subprocess.run("java -jar " + saxon_path + " " + outfile_path + " " + xsl_path, shell=True)
	
	
	# clean the HTML file
	review_id = infile_name[:-8]
	htmlfile_path = join(outpath, review_id + ".html")
	with open(htmlfile_path, "r", encoding="UTF-8") as html_in:
		inhtml = html_in.read()
		newhtml = re.sub(r"<br></br>", r"<br/>", inhtml)
		
		with open(htmlfile_path, "w", encoding="UTF-8") as html_out:
			 
			 html_out.write(newhtml)
	
	# transform HTML + CSS to PDF
	HTML(htmlfile_path).write_pdf(join(outpath, review_id + ".pdf"))
	
print("done")	

