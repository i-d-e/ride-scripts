# TEI2PDF for RIDE

## What does it do?

The script takes TEI files of RIDE reviews as input and generates PDF files for them.

## How to use it?

### Software you need:
* an installation of Python 3 (minimum 3.6)
* installation of the Python module weasyprint (and its dependencies, see https://weasyprint.readthedocs.io/en/latest/install.html)
* installation of saxon for XSLT transformation

(the script was tested on Ubuntu 20.04.2 LTS)

### Data you need:
* TEI files of the reviews
* an output directory (needs to be there)
* some image files (logos/icons; included here in the img subfolder)

### How to call the script:
* open the file reviews_to_pdf.py in an editor
* change the variables in the upper part so that they conform to your settings, e.g.:
	
```python
#general working directory:
wdir = "/home/ulrike/Dokumente/IDE/Reviews/PDF-Export"

#directory with the TEI input files:
inpath = "/home/ulrike/Git/ride-update/13"

#directory for outputs (relative to the working directory):
outpath = join(wdir, "out")

#path to the saxon installation (to the .jar file):
saxon_path = "/home/ulrike/Programme/saxon/saxon9he.jar"

#path to the XSLT file to use for transformation (relative to the working directory, does not need to be changed):
xsl_path = join(wdir, "review-to-pdf.xsl")
```
* open the file review-to-pdf.xsl in an editor
* change the variable 'wdir'

```xml
* <xsl:variable name="wdir">/home/ulrike/Git/ride-scripts/tei2pdf/</xsl:variable><!-- absolute path to the working directory -->
```

* navigate to this repository (/Git/ride-scripts/tei2pdf)
* type: python3 reviews_to_pdf.py

### See the results:
* wait for the script to finish
* look into the subfolder "out". There you should find the output PDF files. There are other files (*.xml, *.html, *.css)  which are temporary and can be deleted.

## License
The code is published under the GNU General Public License v3.0.

## Contact
Ulrike Henny-Krahmer, ulrike.henny@web.de
