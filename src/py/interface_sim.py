# -*- coding: utf-8 -*-
"""
Created on Mon May 20 11:54:24 2019

@author: johnc
"""

'''Interface Sim is used for simulation of the data gathered'''

from create_simulation import Simulator
import pandas as pd

# Firstly we define what kind of Spike & Decay Function we want
def spike(stress, adds, mults):
    return (stress + adds) * mults
    
def decay(stress, duration):
    return stress / pow(2, (duration / 1000))

sim = Simulator("../osu/D(ABE3) - MANIERA (iJinjin) [Masterpiece].osu")

# Grab the template DF
sm_df = sim.sm_df
sm_df['adds'] = (1,2,3)

print(sm_df)



#sim.run()
#sim.export_self(file_name)