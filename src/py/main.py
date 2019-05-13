# -*- coding: utf-8 -*-
"""
Created on Mon May 13 13:28:14 2019

@author: johnc
"""

''' This is the main test file '''

from chart_parser import ChartParser
from stress_mapper import StressMapper
from stress_sim import StressSim
from stress_model import StressModel
import pandas as pd

def run_simulation(file_path):
    chart = ChartParser(file_path)
    chart = chart.parse_auto()
    
    # StressMapping DataFrame
    sm_df = pd.DataFrame([['note',   50, 1],
                          ['lnoteh', 50, 1],
                          ['lnotet', 50, 1]], columns = ['types', 'adds', 'mults'])
    
    smp = StressMapper(sm_df)
    chart = smp.map_over(chart)
    
    # Create Decay and Spike Functions
    def decay(stress, duration):
        return stress / (2 ** (duration / 1000))
    
    def spike(stress, adds, mults):
        return (stress + adds) * mults
    
    smd = StressModel(decay_func = decay,
                      spike_func = spike,
                      stress = 0.0)
    
    ss = StressSim(smd)
    
    chart = ss.simulate(chart)

    return chart

