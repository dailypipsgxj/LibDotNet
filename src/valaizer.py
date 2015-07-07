# this script scans the src directory for files with the .cs extension and
# changes it to the .vala extension as well as strips the BOM from the file
# it then adds the filename to the list of files to be compiled (not yet implemented)

import os, sys, codecs
import re, mmap

BUFSIZE = 4096
BOMLEN = len(codecs.BOM_UTF8)

def listFiles (dir):
	for root, subFolders, files in os.walk(dir):
		for file in files:
			yield os.path.join(root,file)
	return
    
def stripBOM (path) :
	with open(path, "r+b") as fp:
		chunk = fp.read(BUFSIZE)
		if chunk.startswith(codecs.BOM_UTF8):
			i = 0
			chunk = chunk[BOMLEN:]
			while chunk:
				fp.seek(i)
				fp.write(chunk)
				i += len(chunk)
				fp.seek(BOMLEN, os.SEEK_CUR)
				chunk = fp.read(BUFSIZE)
			fp.seek(-BOMLEN, os.SEEK_CUR)
			fp.truncate()

def processFile (path):
	data = ""
	with open (path, "r+") as f:
		data = mmap.mmap(f.fileno(), 0)
		data = re.sub('unsafe ', "", data)
		data = re.sub('explicit ', "", data)
		data = re.sub('implicit ', "", data)
		data = re.sub('readonly ', "", data)
		data = re.sub('sealed ', "", data)
		data = re.sub('\#region ', "", data)
		data = re.sub('\#endregion ', "", data)
		data = re.sub(ur'\s*: base\s*\(([\w\s,<>\[\].=&\':/*]*?)\)\s*?\s*(?={){', baseReplace, data)
		data = re.sub(ur'\n\s*(\[[a-zA-Z0-9()"=\{\}\s.]*\])', attrReplace, data)
		f.close()

	print data
	
	with open (path, "w") as f:
		f.write (data)
		
def baseReplace (matchobj):
	return "{\n\t\t\tbase(" + matchobj.group (1) + ");"

def attrReplace (matchobj):
	return "\n// " + matchobj.group (1) + "\n"


def main ():
	path = os.path.dirname(os.path.realpath(__file__))
	for f in listFiles (path):
		if (f.endswith ('cs')) :
			newname = f.replace('.cs', '.vala')
			output = os.rename(f, newname)
			stripBOM (newname)
			processFile (newname)
		elif (f.endswith ('vala')) :
			print f.replace(path + "/", '\t') + " \\"
			processFile (f)

		
if __name__ == "__main__":
	main()

# Strip from files:
# unsafe
# explicit
# implicit
# readonly

# preprocessor directives
# #region
# #endregion

# Convert doc tags to Valadoc format
# Mangel attributes
# Overloaded constructors
# base calls
