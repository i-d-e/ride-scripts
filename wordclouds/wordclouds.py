#!/usr/bin/env python
# -*- coding: utf-8 -*-
#
#  wordclouds.py
#
#  Generates word clouds for RIDE reviews
#  
#  @author: Ulrike Henny-Krahmer
#  
#  

import sys
from os.path import join
from os.path import basename
import glob
import re
import numpy as np
import matplotlib.pyplot as plt
from PIL import Image
from wordcloud import WordCloud
from lxml import etree


def create_wordclouds(mask_file, font_file, stopwords_file, colormap):
	"""
	Create wordclouds for RIDE reviews.
	
	Arguments:
	
	mask_file (str): filename of the mask image to use
	font_file (str): filename of the font file to use
	stopwords_file (str): filename of the stopword list to use
	colormap (str): name of the matplotlib colormap to use
	
	TO DO: once the language of the review is included in the TEI, use that information to choose the right 
	stopword list. Right now it is necessary to generate the wordclouds for the different languages separately.
	
	Example call: create_wordclouds("cloud_mask.png", "MKorsair.ttf", "stopwords_en.txt", "summer")
	From the command line: wordclouds.py "cloud_mask.png", "MKorsair.ttf", "stopwords_en.txt", "summer"
	"""

	# read TEI input files, generate a cloud for each one

	print("creating wordclouds...")

	for file in glob.glob("tei/*.xml"):
		
		# get the filename without -tei.xml extension
		filename_in = basename(file)[0:-8] 
		filename_out = filename_in + "-wc.png"
		
		# read text from TEI file
		xml = etree.parse(file)
		
		namespace = {'tei':'http://www.tei-c.org/ns/1.0'}
		# OBS: maybe we will need to adapt the XPath for the new TEI model...
		fulltext = xml.xpath("//tei:body//text()", namespaces=namespace)
		fulltext = "\n".join(fulltext)
		fulltext = str(fulltext).lower()
		fulltext = re.sub("\s+", " ", fulltext)
		
		#with open(join("txt_out", filename_in + ".txt"), "w", encoding="UTF-8") as output:
		#	output.write(fulltext)
		
		# generate word cloud image
		"""
		parameters for wordcloud (with example values):
			background_color="white"
			font_path="/home/ulrike/Git/ride-tech/MKorsair.ttf" # path to the font file to use
			prefer_horizontal=1.0
			colormap="hot" # matplotlib colormap, see e.g. https://matplotlib.org/3.1.1/gallery/color/colormap_reference.html
			mask= ... # the form of the wordcloud can be determined with the help of a "mask" image
			stopwords= ("der", "die", "das") # set of stopwords
			collocations=False # ignore collocations (default: True)
			max_words=500
			
			max_font_size=40 # not necessary
			min_font_size=8 # default: 4
			repeat=True # default: False
			width=800 # not needed if there is a mask image
			height=520 # not needed if there is a mask image
		"""
		
		## SET SOME PARAMETERS FOR THE WORDCLOUD:
		
		# read the mask image which determines the form of the wordcloud
		mask = np.array(Image.open(join("masks", mask_file)))
		
		# read the stopword list
		with open(join("stopwords", stopwords_file), encoding="UTF-8") as infile:
			lines = infile.read().splitlines()
			stopwords = set(lines)
			
		# choose the font file
		font_path = join("fonts", font_file)
		
		# set the colormap
		colormap=colormap


		# GENERATE THE WORDCLOUD
		wordcloud = WordCloud(background_color="white", font_path=font_path, prefer_horizontal=1.0, colormap=colormap, mask=mask, stopwords=stopwords, collocations=False, max_words=500, min_font_size=4, repeat=True).generate(fulltext)
		wordcloud.to_file(join("wc_out", filename_out))

		#plt.imshow(wordcloud, interpolation="bilinear")
		#plt.axis("off")
		#plt.show()

		print("created " + filename_out + "...")
		
	print("all done!")
	
	



if __name__ == "__main__":
	create_wordclouds(sys.argv[1], sys.argv[2], sys.argv[3], sys.argv[4])
