# -*- coding: utf-8 -*-
"""
Created on Mon May 13 13:28:14 2019

@author: johnc
"""

''' This is the main test file '''

from chart_parser import ChartParser
from stress_mapper import StressMapper
import pandas as pd

file_path = "../osu/stargazer - dreamer (Evening) [wander].osu"
chart = ChartParser(file_path)
chart = chart.parse_auto()

# StressMapping DataFrame
sm_df = pd.DataFrame([['note',   10, 1.1],
                      ['lnoteh', 5,  1.1],
                      ['lnotet', 5,  1.1]], columns = ['types', 'add', 'mult'])

sm = StressMapper(sm_df)

chart = sm.map_over(chart)