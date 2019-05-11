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
from chart import Chart
import numpy as np

_oflist_1 = (10,9,8,7,6,4,3,2,1) # 5 is intentionally missing
_oflist_2 = (10,5,1)
_oflist_1_sorted = np.array((1,2,3,4,6,7,8,9,10))
_oflist_2_sorted = np.array((1,5,10))

class TestChartColumn(unittest.TestCase):
    def setUp(self):
        self.chart_column = ChartColumn(_oflist_1)
    
    def test_init(self):
        '''Check if sorting worked'''
        
        self.assertTrue(np.array_equal(self.chart_column.offset_list,
                                       _oflist_1_sorted))
        
    def test_setter(self):
        '''Test setting new offsets'''
        self.chart_column.offset_list = _oflist_2
        
        self.assertTrue(np.array_equal(self.chart_column.offset_list,
                                       _oflist_2_sorted))
        
        self.chart_column.offset_list = _oflist_1
        
    def test_indexing(self):
        '''Test indexing of column offsets'''
        self.assertEqual(self.chart_column.offset_list[0],
                         min(_oflist_1)) 
      
class TestChart(unittest.TestCase):
    def setUp(self):
        self.chart_col_1 = ChartColumn(_oflist_1)
        self.chart_col_2 = ChartColumn(_oflist_2)
        self.chart = Chart(chart_cols = (self.chart_col_1,
                                         self.chart_col_2))
        
    def test_indexing(self):
        '''Check if indexing works for Chart'''
        self.assertTrue(np.array_equal(self.chart[0].offset_list,
                                       _oflist_1_sorted))
        
    def test_ordering(self):
        '''Test ordering arg in Chart.__init__'''
        _chart = Chart(chart_cols = (self.chart_col_1,self.chart_col_2),
                       ordering = (1,0)) # We reverse the ordering
        
        self.assertTrue(np.array_equal(_chart[0].offset_list,
                                       _oflist_2_sorted))
        
        

if __name__ == '__main__':
    unittest.main()