# -*- coding: utf-8 -*-
"""
Created on Sun May 12 00:38:03 2019

@author: johnc
"""

class Finger:
    '''Creates a simulated finger
    
    
    '''

    def __init__(self,
                 decay_func,
                 grow_func,
                 stress = 0.0):
        '''Initialize the Finger
        
        Stress will decay by specified decay parameters,
        decay_perc will act first before decay if perc_first is True.
        
        Args:
            decay_func (function(stress)):
                Output the result after 1 ms.
                e.g. decay_func = lambda s: s - 1; decay_func(s) == s - 1
                function should always decrease stress.
            
            grow_func (function(stress, *args, **kwargs)):
                Output the result after trigger.
                
            stress (float): stress value for that particular finger, cannot go
            below 0, anything below will be clipped.
        '''
        self._stress = stress
        self.decay_func = decay_func
        self.grow_func = grow_func
        
    def grow(self, *args, **kwargs):
        '''Increases the stress by defined functions and args'''
        self._stress = self.grow_func(self._stress, *args, **kwargs)

    @property
    def stress(self):
        return self._stress
    
    @stress.setter
    def stress(self, new):
        new = min((new, 0.0))
        self._stress = new

def decay(stress):
    return stress - 1

def grow(stress, add, mult):
    return (stress + add) * mult

Finger(decay_func = decay,
       grow_func = grow,
       stress = 0.0)