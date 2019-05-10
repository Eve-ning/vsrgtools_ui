# -*- coding: utf-8 -*-
"""
Created on Fri May 10 19:06:18 2019

@author: johnc
"""

import numpy as np

class ChartColumn:
    def __init__(self, offset_list: list):
        # Map all into float
        offset_list = list(map(float, offset_list))
        
        self.offset_list = np.array(offset_list)
        
        self._auto_sort = True
        
    def _sort(self):
        '''Sorts the offset_list if _auto_reorder is True'''
        if (self._auto_sort):
            self.offset_list = np.sort(self.offset_list)
            
    def __getitem__(self, key):
        return self.offset_list[key]
    
    def __setitem__(self, key, item):
        self.offset_list[key] = item
        self._sort()
    
    def append(self, offset):
        np.append(self.offset_list, float(offset))