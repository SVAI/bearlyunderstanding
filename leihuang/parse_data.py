"""Parsing the data file from mhcflurry
(https://github.com/hammerlab/mhcflurry). 
"""

import pandas as pd
import numpy as np
import matplotlib.pyplot as plt


import mhcflurry


peptides = pd.read_table('Onno_protein_chopped.pep', header=None)[0]

predictor = mhcflurry.Class1AffinityPredictor.load()
out_mhcflurry = predictor.predict_to_dataframe(allele='A0201',
	peptides=peptides)


out_netmhcpan = pd.read_csv('NetMHCpanOut.csv', header=None)


def plot_scatter(dat1, dat2, xlabel, ylabel, filepath):
	fig = plt.figure(figsize=(4,4))
	ax = fig.add_subplot(111)
	ax.plot([0,0], [5e4,5e4], '-r')
	ax.scatter(dat1, dat2, s=0.5, edgecolors='none')
	ax.set_xlim(0, 5e4)
	ax.set_ylim(0, 5e4)
	ax.set_xticklabels(['0']+['%de4'%i for i in range(1,6)], fontsize=8)
	ax.set_yticklabels(['0']+['%de4'%i for i in range(1,6)], fontsize=8)
	ax.set_xlabel(xlabel)
	ax.set_ylabel(ylabel)	
	plt.subplots_adjust(left=0.2, bottom=0.2)
	plt.savefig(filepath)

"""
plot_scatter(out_netmhcpan.iloc[:,-4], out_mhcflurry.prediction, 
			 'NetMHCpan prediction', 'MHCflurry prediction', 
		     'scatter_netmhcpan_mhcflurry.pdf')
"""


def plot_hist(dat, bins, xlabel, filepath):
	fig = plt.figure(figsize=(4,3))
	ax = fig.add_subplot(111)
	ax.hist(list(dat), bins=bins, histtype='stepfilled')
	ax.set_xlim(0, bins[-1])
	ax.set_xlabel(xlabel)
	ax.set_ylabel('Count')
	plt.savefig(filepath)


out_netmhcpan = pd.read_csv('NetMHCpanOut.csv', header=None)

plot_hist(out_netmhcpan.iloc[:,-4], np.linspace(0,5e4,101), 
		  'NetMHCpan prediction', 'hist_netmhcpan_all.pdf')
plot_hist(out_mhcflurry.prediction, np.linspace(0,5e4,101), 
		  'MHCflurry prediction', 'hist_mhcflurry_all.pdf')

plot_hist(out_netmhcpan.iloc[:,-4], np.linspace(0,5e2,101), 
		  'NetMHCpan prediction', 'hist_netmhcpan_zoomin.pdf')
plot_hist(out_mhcflurry.prediction, np.linspace(0,5e2,101), 
		  'MHCflurry prediction', 'hist_mhcflurry_zoomin.pdf')


