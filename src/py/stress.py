# -*- coding: utf-8 -*-
"""
Created on Sun May 12 00:38:03 2019

@author: johnc
"""

class Stress:
    '''Creates a simulated stress value tracker'''

    def __init__(self,
                 decay_func,
                 grow_func,
                 val = 0.0):
        '''Initialize the Stress
        
        Stress will decay by specified decay parameters,
        decay_perc will act first before decay if perc_first is True.
        
        Args:
            decay_func (function(val)):
                Output the result after 1 ms.
                e.g. decay_func = lambda s: s - 1; decay_func(s) == s - 1
                function should always decrease val.
            
            grow_func (function(val, *args, **kwargs)):
                Output the result after trigger.
                
            val (float): val value for that particular Stress, cannot go
            below 0, anything below will be clipped.
        '''
        self._val = val
        self.decay_func = decay_func
        self.grow_func = grow_func
        
    def grow(self, *args, **kwargs):
        '''Increases the val by defined functions and args'''
        _temp_val = self._val
        self._val = self.grow_func(self._val, *args, **kwargs)
        print("Grew val from {a} to {b}".format(a = _temp_val,
                                                b = self._val))
        
    @property
    def val(self):
        return self._val
    
    @val.setter
    def val(self, new):
        new = min((new, 0.0))
        self._val = new

def decay(val):
    return val - 1

def grow(val, add, mult):
    return (val + add) * mult

f = Stress(decay_func = decay,
       grow_func = grow,
       val = 0.0)

f.grow(add = 1,
       mult = 2)

