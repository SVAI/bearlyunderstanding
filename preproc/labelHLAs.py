import csv
import numpy as np 

HLA_STRING = 'hello'
newrows = []

with open('pracmat.csv') as csvfile:
	filereader = csv.reader(csvfile)
	for row in filereader:
		newrow = row
		if row[0] == HLA_STRING:
		    newrow[181] = 1
		newrows.append(newrow)


with open('pracmat.csv', 'w') as csvfile:
	writer = csv.writer(csvfile)
	writer.writerows(newrows)
