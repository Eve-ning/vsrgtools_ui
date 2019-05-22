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
        
    @property
    def stress(self):
        '''Value of stress
        
        stress will not go below 0.0'''
        return self._stress
    
    @stress.setter
    def stress(self, new):
        new = max((new, 0.0))
        self._stress = new
        
    def spike(self, apply=True, echo=False, *args, **kwargs):
        '''Spikes stress by defined functions and args'''
        _old_stress = self._stress
        _new_stress = self.spike_func(self._stress, *args, **kwargs)
        if (echo):
            print("spike\t{a:.1f}\t{b:.1f}".format(
                    a = _old_stress, b = _new_stress))
        
        if (apply):
            self.stress = _new_stress
        
        return _new_stress
        
    def decay(self, duration, apply=True, echo=False, *args, **kwargs):
        '''Decays stress after specified duration'''
        _old_stress = self._stress
        _new_stress = self.decay_func(self._stress, duration, *args, **kwargs)
        if (echo):
            print("decay\t{a:.1f}\t{b:.1f}\t{d:.1f}ms".format(
                    a = _old_stress, b = _new_stress, d = duration))
        
        if (apply):
            self.stress = _new_stress
            
        return _new_stress
        
