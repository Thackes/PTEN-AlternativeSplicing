#!/bin/bash/usr
import glob
import pandas as pd
import numpy as np
import functools
import os
from glob import iglob
import csv
from os.path import basename
from pathlib import Path
import itertools
from os import listdir
import sys



AS_events='/home/seyfim/isilon/NGS_Working/Stetson_Thacker/AlternativeSplicing_M3M4/rMATS/data/v.4.0.2/P14/WtMut/JCEC.Only'
output_loc='/home/seyfim/isilon/NGS_Working/Stetson_Thacker/AlternativeSplicing_M3M4/rMATS/data/v.4.0.2/PostProcessed-and-Significant/PSI'
wt='P14_WT_'
mut='P14_MUT_'
origin_of_comparison='wtmut'
# colnames=['ID', 'GeneID', 'geneSymbol', 'chr', 'strand', 'longExonStart_0base', 'longExonEnd', 'shortES', 'shortEE', 'flankingES', 'flankingEE', 'ID.1', 'IJC_SAMPLE_1', 'SJC_SAMPLE_1', 'IJC_SAMPLE_2', 'SJC_SAMPLE_2', 'IncFormLen', 'SkipFormLen', 'PValue', 'FDR', 'IncLevel1', 'IncLevel2', 'IncLevelDifference']
w_events_list=[]
m_events_list=[]
all_AS_events=sorted(glob.glob(AS_events + '/*.txt'))

for a in all_AS_events:
    df = pd.read_table(a, sep='\t', engine='python')
    # print(df.head())

    samplename_working=Path(a).stem
    samplename_working2=os.path.splitext(samplename_working)[0]
    samplename_final=os.path.splitext(samplename_working2)[0]
#     # print(df.head())
    df['Group']=samplename_final

#
    df_wt=df[['Group','GeneID','FDR','IncLevel1']]
    df_mut=df[['Group','GeneID','FDR','IncLevel2']]



    df_sigw=df_wt[df_wt['FDR']<= 0.05]
    df_sigm=df_mut[df_mut['FDR']<= 0.05]

    # print(df_sig.head())
#
    w_events_list.append(df_sigw)
    m_events_list.append(df_sigm)
# #
# #
WT=pd.concat(w_events_list)
MUT=pd.concat(m_events_list)


# print(WT.head())

# #
# WT=WT.pivot_table(index='GeneID', columns='Group', values='IncLevel1')
# MUT=MUT.pivot_table(index='GeneID', columns='Group', values='IncLevel2')

# print(all.head())
# print(sig.head())
# #
WT=WT.fillna(0)
MUT=MUT.fillna(0)
#
WT[['d1','d2','d3']]=WT['IncLevel1'].str.split(',', expand=True)
MUT[['d1','d2','d3']]=MUT['IncLevel2'].str.split(',', expand=True)

# print(WT.head())



#
#
#
#
WT_sig=wt+origin_of_comparison+'.significant.psi.csv'
output_wtsig=os.path.join(output_loc, WT_sig)



MUT_sig=mut+origin_of_comparison+'.significant.psi.csv'
output_mutsig=os.path.join(output_loc, MUT_sig)
# print(MUT_sig)
#
# #
WT.to_csv(output_wtsig, sep=',', header=True)
MUT.to_csv(output_mutsig, sep=',', header=True)
