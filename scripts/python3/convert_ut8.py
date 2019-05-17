# -*- coding: utf-8 -*-
import sys
from os import path
sys.path.append(path.join(path.dirname(__file__), '../../bin/'))
from pycore import get_options
import csv

OPT = get_options()

def extract_and_transform_utf8(file, new_file):
	with open(file, 'r', encoding='utf-8') as infile, open(new_file, 'w') as outfile:
		inputs = csv.reader(infile)
		output = csv.writer(outfile)
		
		for index, row in enumerate(inputs):
			output.writerow(row)

extract_and_transform_utf8(OPT.from_path, OPT.to_path)