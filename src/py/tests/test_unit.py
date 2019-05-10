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

from chart_column import ChartColumn
import numpy as np

class TestChartColumn(unittest.TestCase):
    def setUp(self):
        self.offset_list = (10,9,8,7,6,4,3,2,1) # 5 is intentionally missing
        self.offset_list_2 = (10,5,1)
        self.chart_column = ChartColumn(self.offset_list)
    
    def test_init(self):
        '''Check if sorting worked'''
        t = np.array((1,2,3,4,6,7,8,9,10))
        t = t.astype(float)
        
        self.assertTrue(np.array_equal(self.chart_column.offset_list, t))
        
    def test_setter(self):
        '''Test setting new offsets'''
        self.chart_column.offset_list = self.offset_list_2
        t = np.array((1,5,10))
        t = t.astype(float)
        
        self.assertTrue(np.array_equal(self.chart_column.offset_list, t))
        
        self.chart_column.offset_list = self.offset_list
        
    def test_indexing(self):
        '''Test indexing of column offsets'''
        self.assertEqual(self.chart_column.offset_list[0], 1.0) 
        
        

if __name__ == '__main__':
    unittest.main()