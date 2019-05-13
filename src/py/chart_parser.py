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
        self._chart_format = self.chart_path.split(".")[1]
    
    def parse_osu(self):
        '''Parses osu file formats'''
        f = open(self.chart_path, 'r')
        
        # Locate keys
        keys = list(filter(lambda x: x.startswith('CircleSize:')))[0]
        keys = int(keys.split(':')[1])
        
        # Lambda Function to calculate the actual column
        clm = lambda value: round((int(value) * keys - 256) / 512)
            
        # Gets the chart and splits it into LNs and NNs
        chart = list(filter(lambda x: x.count(':') > 4, f))
        notes_l = list(filter(lambda x: x.count(':') == 4, chart))
        lnotes_l = list(filter(lambda x: x.count(':') == 5, chart))
        
        # Convert the lines to values for the notes
        # Values are in a tuple (Column, Offset)
        notes = [(clm(x.split(',')[0]), # Gets column
                        int(x.split(',')[2])) for # Gets offset
                       x in notes_l]
        
        lnotes_h = [(clm(int(x.split(',')[0])), # Gets column
                           int(x.split(',')[2])) for # Gets offset
                          x in lnotes_l]
        
        lnotes_t = [(clm(int(x.split(',')[0])), # Gets column
                           int(x.split(',')[5])) for # Gets offset
                          x in lnotes_l]
        
        # Coerce to DataFrames
        notes_df = pd.DataFrame(notes, columns = ['columns', 'offsets'])
        notes_df['types'] = 'note'
        
        lnotes_h_df = pd.DataFrame(lnotes_h, columns = ['columns', 'offsets'])
        lnotes_h_df['types'] = 'lnoteh'
        
        lnotes_t_df = pd.DataFrame(lnotes_t, columns = ['columns', 'offsets'])
        lnotes_t_df['types'] = 'lnotet'
        
        # Join all together
        chart_df = notes_df.append([lnotes_h_df, lnotes_t_df])
        
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
            raise Exception("Auto Parsing Error.\
                            Use specific functions instead.")
