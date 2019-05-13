# -*- coding: utf-8 -*-
"""
Created on Mon May 13 12:16:56 2019

@author: johnc
"""

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
        self.chart_format = self.chart_path.split(".")[1]
    
    def parse_osu(self):
        '''Parses osu file formats'''
        pass
    
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
        
        f = self.chart_format
        if (f == "osu"):
            return self.parse_osu()
        elif (f == "sm"):
            return self.parse_sm()
        elif (f == "bms"):
            return self.parse_bms()
        else:
            raise Exception("Auto Parsing Error.\
                            Use specific functions instead.")
