# -*- coding: utf-8 -*-
"""
Created on Sat May 11 00:41:41 2019

@author: johnc
"""
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
        '''Initialization'''
        
        self.assertTrue(np.array_equal(self.chart_column.offsets,
                                       _oflist_1_sorted))
        
    def test_setter(self):
        '''Offset Setting'''
        self.chart_column.offsets = _oflist_2
        
        self.assertTrue(np.array_equal(self.chart_column.offsets,
                                       _oflist_2_sorted))
        
        self.chart_column.offsets = _oflist_1
        
    def test_indexing(self):
        '''Offset Indexing'''
        self.assertEqual(self.chart_column.offsets[0],
                         min(_oflist_1)) 
      
class TestChart(unittest.TestCase):
    def setUp(self):
        self.chart_col_1 = ChartColumn(_oflist_1)
        self.chart_col_2 = ChartColumn(_oflist_2)
        self.chart = Chart(cols = (self.chart_col_1,
                                   self.chart_col_2))
        
    def test_indexing(self):
        '''Dataframe Indexing'''
        self.assertTrue(np.array_equal(self.chart[0]['offsets'],
                                       _oflist_1_sorted))
        
    def test_ordering(self):
        '''Test ordering arg in Chart.__init__'''
        _chart = Chart(cols = (self.chart_col_1, 
                               self.chart_col_2),
                       keys = (1,0)) # We reverse the ordering
        
        self.assertTrue(np.array_equal(_chart[0]['offsets'],
                                       _oflist_2_sorted))
       
        

if __name__ == '__main__':
    unittest.main()
    