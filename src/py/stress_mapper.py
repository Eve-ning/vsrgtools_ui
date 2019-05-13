# -*- coding: utf-8 -*-
"""
Created on Sun May 12 00:38:03 2019

@author: johnc
"""

''' Stress Mapper takes in info from the map parser

Stress Mapper looks at the note type, and assigns the spike parameters
'''
import pandas as pd

class StressMapper:
    '''This class maps types to specified parameters'''

    def __init__(self):
        self._mapping = pd.DataFrame(data=None,
                                     columns=["types"])
    
    def map_over(self,
                 df):
        '''Maps over the DataFrame, appending new columns for joined columns
        
        Args:
            df (DataFrame): DataFrame to map to.
        '''
    
    @property
    def mapping(self):
        '''Maps must have 'types' column
        
        Columns:
            types (str): This defines the type name to be referenced during 
                mapping.
            *args: The other columns are used to designate user-defined 
                columns. This must also be in-line with the function arguments
                in StressModel.
        '''
        return self._mapping
    
    @mapping.setter
    def mapping(self, new):
        if (not "types" in list(new)):
            raise Exception("Column 'types' must be included in the\
                            DataFrame.")
        else:
            self._mapping = new

help(StressMapper)