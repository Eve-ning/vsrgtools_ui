# -*- coding: utf-8 -*-
"""
Created on Sun May 12 00:38:03 2019

@author: johnc
"""

'''StressModel acts as the interface for the StressSim, which will tabulate
the stress on a time line.

e.g.
#: Offset, Str: Stress

# | Str | Event |   Func   |
--+-----+-------+----------+
0 | 1.0 | Spike | spike(1) |
3 | 0.7 | Decay | decay(3) | # Take note of the offset
4 | 1.7 | Spike | spike(1) |
5 | 1.6 | Decay | decay(1) |
. | ... | ..... | ........ |

Spike
    Spike can represent any note, its interface allows configurable spike
    intensity, so different types of notes can have different impacts
    
Decay
    Decay represents the stamina regeneration of the player. Its interface 
    allows specification of duration, so longer duration can mean higher stress
    decay via custom curve functions.

'''

class StressModel:
    '''Creates a simulated stress tracker
        
    stress will decay by specified decay parameters,
    decay_perc will act first before decay if perc_first is True.
    
    Args:
        decay_func (function(stress, duration, *args, **kwargs)):
            Output the result after {{duration}} ms.
            stress and duration are required.
        
        spike_func (function(stress, *args, **kwargs)):
            Output the result after trigger.
            stress is required.
            
        stress (float): stressue for stress, cannot go below 0, anything below
            will be clipped.
    '''
    def __init__(self,
                 decay_func,
                 spike_func,
                 stress = 0.0):
        
        self._stress = stress
        self.decay_func = decay_func
        self.spike_func = spike_func
        
    def spike(self, *args, **kwargs):
        '''Spikes stress by defined functions and args'''
        _temp_stress = self._stress
        self._stress = self.spike_func(self._stress, *args, **kwargs)
        print("Grew stress from {a} to {b}".format(a = _temp_stress,
                                                b = self._stress))
        
    def decay(self, duration, *args, **kwargs):
        '''Decays stress after specified duration'''
        _temp_stress = self._stress
        self._stress = self.decay_func(self._stress, duration, *args, **kwargs)
        print("stress decayed from {a} to {b} in {d} ms".format(a = _temp_stress,
                                                             b = self._stress,
                                                             d = duration))
        
    @property
    def stress(self):
        '''Value of stress
        
        stress will not go below 0.0'''
        return self._stress
    
    @stress.setter
    def stress(self, new):
        new = min((new, 0.0))
        self._stress = new
