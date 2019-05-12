# -*- coding: utf-8 -*-
"""
Created on Sun May 12 00:38:03 2019

@author: johnc
"""

from stress_model import StressModel as SM
import pandas as pd

class StressSim:
    '''Creates a simulation of stress
    
    class Stress only works as a basic interface for the value, class StressSim
    will interact with a pd.DataFrame to generate StressModel.stress results
    '''

    def __init__(self,
                 sm: SM):
        '''Initialize the StressSim
        
        Args:
            sm (StressModel): Import the Stress Model here.
        '''
        self.sm = sm
        
    def simulate(self,
                 df,
                 offsets_column_name = "offsets",
                 events_column_name = "events") -> pd.DataFrame:
        '''Simulates the StressModel and appends results to the df
        
        Args:
            df (DataFrame): Import the DataFrame here.
                The DataFrame must have the offsets and events column.
            offsets_column_name (str): In the event that the column names are
                not the same as the defaults, specify them here.
            events_column_name (str): ^
        '''
        
        pass
        
        
        
      