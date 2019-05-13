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
    '''This class maps types to specified parameters
    
    Maps must have 'types' column
        
    Args:
        mapping (DataFrame): DataFrame used to merge with the provided 
            DataFrame in map_over.
        Columns:
        types (str): This defines the type name to be referenced during 
            mapping.
        *args: The other columns are used to designate user-defined 
            columns. This must also be in-line with the function arguments
            in StressModel.
    '''

    def __init__(self, mapping = None):
        if (not mapping):
            self._mapping = pd.DataFrame(data=None,
                                         columns=["types"])
        else:
            self._assert_mapping(mapping)
            self._mapping = mapping
    
    def _assert_mapping(self, new):
        '''Asserts if the new mapping DataFrame is valid
        
        Raises an Exception if invalid.'''
        
        if (not "types" in list(new)):
            raise Exception("Column 'types' must be included in the\
                            DataFrame.")
    
    def map_over(self,
                 df: pd.DataFrame):
        '''Maps over the DataFrame, appending new columns for joined columns
        
        Args:
            df (DataFrame): DataFrame to map to.
        '''
        
        return pd.merge(left = df, right = self._mapping,
                        how = 'inner', on = 'types')        
    @property
    def mapping(self):
        '''Sets and Gets the mapping DataFrame
        
        Specifications of DataFrame in help(StressMapper)'''
        return self._mapping
    
    @mapping.setter
    def mapping(self, new):
        self._assert_mapping(new)
        self._mapping = new
