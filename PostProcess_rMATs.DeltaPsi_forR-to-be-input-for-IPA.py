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

def concat_pivot_writeout(df_sig_list, index, col, values, ext):
    dpsi=pd.concat(df_sig_list)
    sig_dpsi=dpsi.pivot_table(index=index, columns=col, values=values)
    sig_dpsi=sig_dpsi.fillna(0)
    #return sig_dpsi_list
    out_name=pheno+ext
    # print(out_name)
    output_sig=os.path.join(output_loc, out_name)
    # print(output_sig)
    sig_dpsi.to_csv(output_sig, sep=',', header=True)

AS_events='/home/seyfim/isilon/NGS_Working/Stetson_Thacker/AlternativeSplicing_M3M4/rMATS/data/v.4.0.2/P14/MutHet/JCEC.Only'
output_loc='/home/seyfim/isilon/NGS_Working/Stetson_Thacker/AlternativeSplicing_M3M4/rMATS/data/v.4.0.2/PostProcessed-and-Significant/For.IPA/working/P14MutHet'
pheno='P14_MutHet'
# colnames=['ID', 'GeneID', 'geneSymbol', 'chr', 'strand', 'longExonStart_0base', 'longExonEnd', 'shortES', 'shortEE', 'flankingES', 'flankingEE', 'ID.1', 'IJC_SAMPLE_1', 'SJC_SAMPLE_1', 'IJC_SAMPLE_2', 'SJC_SAMPLE_2', 'IncFormLen', 'SkipFormLen', 'PValue', 'FDR', 'IncLevel1', 'IncLevel2', 'IncLevelDifference']
sig_dpsi_list=[]
sig_fdr_list=[]
sig_pvalue_list=[]

all_AS_events=sorted(glob.glob(AS_events + '/*.txt'))

for a in all_AS_events:
    df = pd.read_table(a, sep='\t', engine='python')
#-create group name (AS event type)
    samplename_working=Path(a).stem
    samplename_working2=os.path.splitext(samplename_working)[0]
    samplename_final=os.path.splitext(samplename_working2)[0]
#     # print(df.head())
#-add group name to df
    df['Group']=samplename_final
    # print(df.head())
#-select columns we are interested in
    df_working=df[['Group','GeneID','geneSymbol','FDR','IncLevelDifference','PValue']]
    # print(df_working.head())
#-select significant dPSI values (FDR <=0.05)
    df_sig2=df_working[df_working['FDR']<= 0.05]
#-break down into mini dfs so we can format correctly for Rscript
    df_sig_dpsi=df_sig2[['Group','geneSymbol','GeneID','IncLevelDifference']]
    df_sig_fdr=df_sig2[['Group', 'GeneID' ,'geneSymbol', 'FDR']]
    df_sig_pvalue=df_sig2[['Group', 'GeneID', 'PValue']]
    # print(df_sig.head())
#-append the current dataframe to the corresponding list
    # all_events_list.append(df_working)
    sig_dpsi_list.append(df_sig_dpsi)
    sig_fdr_list.append(df_sig_fdr)
    sig_pvalue_list.append(df_sig_pvalue)

#-concat dfs in list and pivot resulting table
dpsi_id=concat_pivot_writeout(sig_dpsi_list,'GeneID','Group','IncLevelDifference','.IDs.txt')
dpsi_symbol=concat_pivot_writeout(sig_dpsi_list,'geneSymbol','Group','IncLevelDifference','.Symbols.txt')
dpsi_fdr=concat_pivot_writeout(sig_fdr_list,'GeneID','Group','FDR','.FDR.txt')
dpsi_pvalue=concat_pivot_writeout(sig_pvalue_list,'GeneID','Group','PValue','.pvalue.txt')
