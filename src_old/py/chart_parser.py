# -*- coding: utf-8 -*-
"""
Created on Mon May 13 12:16:56 2019

@author: johnc
"""

import pandas as pd

class ChartParser:
    '''Parses Charts from various formats

    Use parse_auto for automatic detection of parsing.
    There are also specific parses if the extension is incorrect.
    Args:
        chart_path(str): File Path
    '''

    def __init__(self, chart_path, custom_format = None):
        self.chart_path = chart_path
        self._parse_path()
        
    def _parse_path(self):
        print(self.chart_path)
        self._chart_format = self.chart_path.split(".")[-1]
    
    def parse_osu(self):
        '''Parses osu file formats'''
        f = open(self.chart_path, 'r', errors='replace')
        fr = f.readlines()
        f.close()
        
        # Locate keys
        keys = list(filter(lambda x: x.startswith('CircleSize:'), fr))[0]
        keys = int(keys.split(':')[1])
        
        # Lambda Function to calculate the actual column
        clm = lambda value: round((int(value) * keys - 256) / 512)
            
        # Gets the chart and filters it into LNs and Ns
        chart = list(filter(lambda x: x.count(':') >= 4, fr))
        
        ns = list(filter(lambda x: x.count(':') == 4, chart))
        lns = list(filter(lambda x: x.count(':') == 5, chart))
        
        # Remove the trailing colon data
        # 256,192,8307,128,0,8423[:0:0:0:0:]
        ns = [n.split(':')[0] for n in ns] 
        lns = [ln.split(':')[0] for ln in lns]
        
        # Split by Comma
        # 256 192 8307 128 0 8423
        ns = [n.split(',') for n in ns]
        lns = [ln.split(',') for ln in lns]
        
        # Convert the lines to values for the notes
        # Values are in a tuple (Offset, Column)
        ns = [(int(n[2]), clm(n[0])) for n in ns]
        lnhs = [(int(ln[2]), clm(ln[0])) for ln in lns]
        lnts = [(int(ln[5]), clm(ln[0])) for ln in lns]
        
        # Coerce to DataFrames
        n_df = pd.DataFrame(ns, columns = ['offsets', 'columns'])
        n_df['types'] = 'note'
        
        lnh_df = pd.DataFrame(lnhs, columns = ['offsets', 'columns'])
        lnh_df['types'] = 'lnoteh'
        
        lnt_df = pd.DataFrame(lnts, columns = ['offsets', 'columns'])
        lnt_df['types'] = 'lnotet'
        
        # Join all together
        chart_df = n_df.append([lnh_df, lnt_df], sort=True)
        
        return chart_df
        
    def parse_sm(self):
        '''Parses sm file formats
        
        Not Implemented'''
        pass
    
    def parse_bms(self):
        '''Parses bms file formats
        
        Not Implemented'''
        pass
    
    def parse_auto(self):
        '''Automatically determines the correct parsing method from extension
        '''
        
        f = self._chart_format
        if (f == "osu"):
            return self.parse_osu()
        elif (f == "sm"):
            return self.parse_sm()
        elif (f == "bms"):
            return self.parse_bms()
        else:
            raise Exception("Unsupported Extension .{ext} Error.\
                            Use specific functions instead.".format(ext = f))
