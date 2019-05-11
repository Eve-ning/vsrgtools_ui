# -*- coding: utf-8 -*-
"""
Created on Fri May 10 19:06:18 2019

@author: johnc
"""

import numpy as np

class ChartColumn:
    
    def _sort(self):
        '''Sorts the offset_list if _auto_reorder is True'''
        self._offsets = np.sort(self._offsets)
           
    def _convert(self, offset_list):
        '''Converts any input into valid offset_list then returns it'''
        # Map all into float
        offset_list = list(map(float, offset_list))
        return np.array(offset_list)
    
    def __init__(self, offset_list: list):
        '''
        Args:
           offset_list (list(float convertable)): Offset list to be used in the
           column
        '''
        self._offsets = self._convert(offset_list)
        
        self._sort()
        
    def __getitem__(self, key):
        return self._offsets[key]
    
    def __setitem__(self, key, item):
        self._offsets[key] = item
        self._sort()
    
    def append(self, offset):
        np.append(self._offsets, float(offset))
        
    @property
    def offset_list(self):
        return self._offsets
    
    @offset_list.setter
    def offset_list(self, offset_list):
        self._offsets = self._convert(offset_list)
        self._sort()
        