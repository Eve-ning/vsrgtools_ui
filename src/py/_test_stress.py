# -*- coding: utf-8 -*-
"""
Created on Sat May 11 00:41:41 2019

@author: johnc
"""
import os,sys,inspect

currentdir = os.path.dirname(os.path.abspath(inspect.getfile(inspect.currentframe())))
parentdir = os.path.dirname(currentdir)
sys.path.insert(0,parentdir) 

import unittest

from stress import Stress
import numpy as np

_oflist_1 = (10,9,8,7,6,4,3,2,1) # 5 is intentionally missing
_oflist_2 = (10,5,1)
_oflist_1_sorted = np.array((1,2,3,4,6,7,8,9,10))
_oflist_2_sorted = np.array((1,5,10))

class TestStress(unittest.TestCase):
    def setUp(self):
        Stress()
    
    def test_init(self):
        '''Initialization'''
        
        

if __name__ == '__main__':
    unittest.main()
    