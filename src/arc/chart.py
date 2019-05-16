# -*- coding: utf-8 -*-
"""
Created on Fri May 10 19:02:37 2019

@author: johnc
"""

import pandas as pd
from chart_column import ChartColumn

class Chart:
    """ Creates a VSRG Chart.
    
    Attributes:
        chart_cols (dict): Access columns with the key being the index.
    Args:
            cols (list(ChartColumn)): list of chart columns
            keys (list(int)): list of integers to indicate keys

    """
    def __init__(self,
                 cols,
                 keys = None):

        
        self._cols = pd.DataFrame(data = (),
                                  columns = ['offsets', 'keys'])
        
        for idx, col in enumerate(cols):
            _col = pd.DataFrame(data = col.offsets,
                                columns = ['offsets'])
            
            # If keys is not specified, we will use the enumerated value
            _col['keys'] = int(keys[idx]) if keys else idx
            
            self._cols = self._cols.append(_col)
        
    def __getitem__(self, key):
        return self._cols.query('keys == {}'.format(str(key)))
        
    def __setitem__(self, key, item):
        self._cols[key] = item


