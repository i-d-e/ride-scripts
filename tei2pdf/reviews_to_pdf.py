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
from os import listdir
from os import remove
from weasyprint import HTML
import glob
import re
import subprocess




"""
THIS DOES (PROBABLY) NOT NEED TO BE CHANGED:
"""
def transform_tei2pdf(inpath, outpath, saxon_path, xsl_path):
    """
    Convert RIDE TEI files to PDF. Takes all XML files found in the input directory.
    
    Arguments:
    inpath (str): path to the directory with TEI input files
    outpath (str): path to the directory for PDF output files
    saxon_path (str): path to the saxon installation (to the .jar file)
    xsl_path (str): path to the XSLT file to use for transformation
    """
    for infile_path in glob.glob(join(inpath,"*tei.xml")):
    	
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
    		outfile_name = infile_name[:-4] + "-temp.xml"
    		outfile_path = join(outpath, outfile_name)
    		
    		with open(outfile_path, "w", encoding="UTF-8") as outfile:
    			
    			outfile.write(newtext)
    		
    			
    		# run XSLT on TEI file to produce HTML and CSS file
    		subprocess.run("java -jar " + saxon_path + " " + outfile_path + " " + xsl_path + " outfolder=" + outpath, shell=True)
		
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



def transform_all_reviews(inpath, saxon_path, xsl_path):
	"""
	Convert all ride reviews in Git/ride/issues from TEI to PDF
	
	Arguments:
    inpath (str): path to the directory which contains the RIDE issues
    saxon_path (str): path to the saxon installation (to the .jar file)
    xsl_path (str): path to the XSLT file to use for transformation
	"""
	for issue_dir in listdir(inpath):
		for review_dir in listdir(join(inpath, issue_dir)):
			# transform TEI-XML file of the review to PDF
			review_dir_abs = join(inpath, issue_dir, review_dir)
			transform_tei2pdf(review_dir_abs, review_dir_abs, saxon_path, xsl_path)
			
			# delete temporary HTML + CCS  + XML files
			HTML_files = glob.glob(join(review_dir_abs, "*.html"))
			CSS_files = glob.glob(join(review_dir_abs, "*.css"))
			XML_files = glob.glob(join(review_dir_abs, "*temp.xml"))
			
			
			for file_path in HTML_files + CSS_files + XML_files:
				remove(file_path)
	
	print("done: transformed all reviews")

"""
ADAPT THESE VARIABLES:
"""
# general working directory:
wdir = "/home/ulrike/Git/ride-scripts/tei2pdf/"
# directory with the TEI input files:
inpath = "/home/ulrike/Git/ride-scripts/tei2pdf/in/"
# directory for outputs (relative to the working directory):
outpath = join(wdir, "out")
# path to the saxon installation (to the .jar file):
saxon_path = "/home/ulrike/Programs/saxon-he-12.0.jar"
# path to the XSLT file to use for transformation (relative to the working directory, does not need to be changed):
xsl_path = join(wdir, "review-to-pdf.xsl")


if __name__ == "__main__":
	# transform TEI files from one directory to PDF
	transform_tei2pdf(inpath, outpath, saxon_path, xsl_path)
	# transform all ride reviews in /Git/ride/issues to PDF
	#transform_all_reviews("/home/ulrike/Git/ride/issues", saxon_path, xsl_path)
