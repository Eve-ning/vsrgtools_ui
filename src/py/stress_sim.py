# -*- coding: utf-8 -*-
"""
Created on Sun May 12 00:38:03 2019

@author: johnc
"""

from stress_model import StressModel as SM

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
      
