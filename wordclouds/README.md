# Word clouds for RIDE reviews

Python script to generate word clouds for RIDE issues.

## What does it do?

The script takes TEI files of RIDE reviews as input and generates a word cloud for each one.

## How to use it?

### Software you need:
* an installation of Python 3
* installation of Python modules: lxml, matplotlib, numpy, PIL, wordcloud

### Data you need:
* TEI files of the reviews

### Decisions to make (parameters for the script):
* the script needs 4 positional parameters (they have to be indicated in that order when calling the script from the command line). These are:
* (1) which "mask" to use for the form of the word clouds. Masks are png images with a white background and e.g. a black foreground. The cloud will only be placed inside of the foregrounded form. You can use the default mask file "cloud_mask.png". Mask files are stored in the subfolder "masks". The size of the clouds is determined by the size of the mask image. The script needs the name of the mask file as a parameter.
* (2) which font to use for the words in the clouds. You can use the default font file "MKorsair.ttf" which you find in the subfolder "fonts" or you can place your own font file there. The script needs the name of the font file as a parameter.
* (3) which stopword list to use. Two lists are prepared: "stopwords_en.txt" and "stopwords_de.txt". Which stopword list you use, depends on the language of the reviews. For each call of the script you can only use one stopword list. The prepared lists are in the subfolder "stopwords". You are free to edit them and remove or add words. Or you can add a new file for a new language. The script needs the name of the stopword list file as a parameter.
* (4) which colormap to use. Matplotlib colormaps are supported. See for example: https://matplotlib.org/3.1.1/gallery/color/colormap_reference.html Choose the name of the colormap and use it as the fourth parameter for the script. E.g. "summer".
* more parameters could be changed directly in the python script, if needed.

### Preparation of data:
* put the TEI files into the subfolder "tei"
* observe that the script generating the word clouds cannot recognize the language of the reviews, so you will have to generate clouds for the reviews in each language separately so the right stopwords can be used

### How to call the script:
* open a command line
* navigate to this repository (/Git/ride-scripts/wordclouds)
* type: python3 wordclouds.py "cloud_mask.png" "MKorsair.ttf", "stopwords_en.txt", "summer" (replace the parameter values with your own choices)

### See the results:
* wait for the script to finish
* look into the subfolder "wc_out". There you should find the word cloud images produced.
* note: the resolution of the resulting images is 72 dpi by default. If you need a higher resolution, you can for example use a mask with the double size as the one intended for the final word cloud images and then increase the resolution of the output files e.g. to 150dpi.

## License
The code is published under the GNU General Public License v3.0.

## Contact
Ulrike Henny-Krahmer, ulrike.henny@web.de
