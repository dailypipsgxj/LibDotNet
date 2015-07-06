# this script scans the src directory for files with the .cs extension and
# changes it to the .vala extension as well as strips the BOM from the file
# it then adds the filename to the list of files to be compiled

import os, sys, codecs

BUFSIZE = 4096
BOMLEN = len(codecs.BOM_UTF8)

def listFiles (dir):
	for root, subFolders, files in os.walk(dir):
		for file in files:
			yield os.path.join(root,file)
	return
    
def main ():
	path = os.path.dirname(os.path.realpath(__file__))
	for f in listFiles (path):
		if (f.endswith ('cs')) :
			newname = f.replace('.cs', '.vala')
			output = os.rename(f, newname)
			removeBOM (newname)
		elif (f.endswith ('vala')) :
			print f.replace(path + "/", '\t') + " \\"

def removeBOM (path) :
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


if __name__ == "__main__":
	main()
