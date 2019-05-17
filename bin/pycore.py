import os
from optparse import OptionParser
import yaml

def get_options():
	stream = open(f'{os.path.dirname(os.path.dirname(os.path.abspath(__file__)))}/config/parameters.yaml', "r")
	docs = yaml.load_all(stream)
	parser = OptionParser()
	parser.add_option("-s", "--script", dest="script",help="scriptname", metavar="SCRIPT")
	for doc in docs:
	    for k,v in doc.items():
	        for p in v:
	        	parser.add_option(f"{p['opt']}", f"--{p['name']}", dest=f"{p['name']}", help=f"{p['description']}", metavar=f"{p['name'].upper()}")
	(options, args) = parser.parse_args()
	return options