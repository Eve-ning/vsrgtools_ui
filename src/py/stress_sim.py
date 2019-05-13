# -*- coding: utf-8 -*-
"""
Created on Sun May 12 00:38:03 2019

@author: johnc
"""

from stress_model import StressModel 
import pandas as pd

class StressSim:
    '''Creates a simulation of stress
    
    class Stress only works as a basic interface for the value, class StressSim
    will interact with a pd.DataFrame to generate StressModel.stress results
    
    Args:
        sm (StressModel): Import the Stress Model here.
    '''

    def __init__(self,
                 smd: StressModel):
        self.smd = smd
        
    def simulate(self,
                 df: pd.DataFrame,
                 spike_column_names = None,
                 offsets_column_name = "offsets") -> pd.DataFrame:
        '''Simulates the StressModel and appends results to the df
        
        Args:
            df (DataFrame): Import the mapped DataFrame here.
                The DataFrame must have the offsets and parameters column.
            spike_column_names (list): If there are specific columns to be 
                passed into the StressModel.spike() function, list them here.
                
                If None, all columns except 'offset' passed into the function.
            offsets_column_name (str): In the event that the column names are
                not the same as the defaults, specify them here.
            
        '''
        pass
        
        
        
      
