# -*- coding: utf-8 -*-
"""
Created on Sat May 11 00:41:41 2019

@author: johnc
"""
import unittest

from stress import Stress
import numpy as np

class TestStress(unittest.TestCase):
    def setUp(self):
        def decay(stress, duration):
            '''Stress decreases by 1 every ms'''
            return stress - (duration * 1)
        
        def spike(stress, add, mult):
            '''Stress will increase by add and multiply by mult every trigger'''
            return (stress + add) * mult
            
        self.stress = Stress(decay_func = decay,
                             spike_func = spike,
                             val = 0.0)
    
    def test_init(self):
        '''Initialization'''
        
        

if __name__ == '__main__':
    unittest.main()
    