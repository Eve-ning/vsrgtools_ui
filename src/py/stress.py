# -*- coding: utf-8 -*-
"""
Created on Sun May 12 00:38:03 2019

@author: johnc
"""

class Stress:
    '''Creates a simulated stress value tracker'''

    def __init__(self,
                 decay_func,
                 spike_func,
                 val = 0.0):
        '''Initialize the Stress class
        
        val will decay by specified decay parameters,
        decay_perc will act first before decay if perc_first is True.
        
        Args:
            decay_func (function(val, duration, *args, **kwargs)):
                Output the result after {{duration}} ms.
                val and duration are required.
            
            spike_func (function(val, *args, **kwargs)):
                Output the result after trigger.
                val is required.
                
            val (float): value for stress, cannot go below 0, anything below
                will be clipped.
        '''
        self._val = val
        self.decay_func = decay_func
        self.spike_func = spike_func
        
    def spike(self, *args, **kwargs):
        '''Spikes val by defined functions and args'''
        _temp_val = self._val
        self._val = self.spike_func(self._val, *args, **kwargs)
        print("Grew val from {a} to {b}".format(a = _temp_val,
                                                b = self._val))
        
    def decay(self, duration, *args, **kwargs):
        '''Decays val after specified duration'''
        _temp_val = self._val
        self._val = self.decay_func(self._val, duration, *args, **kwargs)
        print("val decayed from {a} to {b} in {d} ms".format(a = _temp_val,
                                                             b = self._val,
                                                             d = duration))
        
    @property
    def val(self):
        return self._val
    
    @val.setter
    def val(self, new):
        new = min((new, 0.0))
        self._val = new
