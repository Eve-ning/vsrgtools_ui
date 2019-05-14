# -*- coding: utf-8 -*-
"""
Created on Sun May 12 00:38:03 2019

@author: johnc
"""

from stress_model import StressModel 
import pandas as pd
import copy

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
                 interval = 1000,
                 spike_columns = None,
                 offsets_column = "offsets") -> pd.DataFrame:
        '''Simulates the StressModel and appends results to the df
        
        Args:
            df (DataFrame): Import the mapped DataFrame here.
                The DataFrame must have the offsets and parameters column.
            interval (int): In ms, the time span used to calculate points in
                decay. Lower values mean more intermediate points.
            spike_columns (list): If there are specific columns to be 
                passed into the StressModel.spike() function, list them here.
                
                If None, columns are automatically detected.
            offsets_column (str): In the event that the column names are
                not the same as the defaults, specify them here.
            
        '''
        
        # Automatically detect new columns
        if (not spike_columns):
            ignore = ['offsets', 'columns', 'types']
            spike_columns = list(filter(lambda x: x not in ignore, list(df)))
           
        # Group by columns to simulate separately
        df = df.sort_values(by = 'offsets')
        dfg = df.groupby(by = 'columns')
        
        stress_l = []
        
        for i, g in dfg:
            [stress_l.append(i) for
             i in self._simulate_group(g, interval, i, spike_columns)]
        
        # Empty DataFrame to hold results
        simdf = pd.DataFrame(stress_l,
                             columns=['offsets', 'stress', 'columns'])
        return simdf
    
    def _simulate_group(self,
                        group: pd.DataFrame,
                        interval,
                        column,
                        spike_columns):
        '''Simulates for a particular group
        
        Args:
            group (DataFrame): A DataFrame
            column (int): Column name/key
            ... : Refer to help(StressSim.simulate)
        '''
        
        smd_ = copy.deepcopy(self.smd) 
        prev_offset = 0
        
        stress_l= []
        
        # For each row, we will:
        # Append rows to simdf by specified interval if no notes are hit
        # Append rows before and after the spike
        for r in group.itertuples():
            # Increase offsets by interval until next note is in range
            _offset = prev_offset # This _offset is only used in interval
            while (_offset + interval < r.offsets):
                _offset += interval
                smd_.decay(_offset - prev_offset, apply=False)
                
            ## Decay first
            smd_.decay(r.offsets - prev_offset,
                       apply=True)
            
            stress_l.append((r.offsets, smd_.stress, column))
    
            ## Spike next
            ### This extracts columns from r that match spike_columns
            rdict = {k:v for k,v in r._asdict().items() if k in spike_columns}
            
            smd_.spike(**rdict, # Unpack r dictionary
                       apply=True)
            stress_l.append((r.offsets, smd_.stress, column))
            
            # Update prev_offset with current one
            prev_offset = r.offsets
        
        # end for
        
        return stress_l
        
        
        
      
