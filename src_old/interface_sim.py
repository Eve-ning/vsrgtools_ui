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

sim = Simulator("../osu/tldne.osu",
                spike_func=spike,
                decay_func=decay)

# Grab the template DF
sm_df = sim.sm_df
#                 NOTE LNOTEH LNOTEL
sm_df['adds']  = (50,  35,    35)
sm_df['mults'] = (1.1, 1.05,  1.05)

sim.sm_df = sm_df

sim.run()
sim.export_self("tldne")



#sim.run()
#sim.export_self(file_name)