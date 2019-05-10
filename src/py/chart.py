# -*- coding: utf-8 -*-
"""
Created on Fri May 10 19:02:37 2019

@author: johnc
"""

from chart_column import ChartColumn

class Chart:
    """ Creates a VSRG Chart.
    
    Attributes:
        chart_cols (dict): Access columns with the key being the index.
    """
    def __init__(self,
                 chart_cols,
                 ordering: list = None):
        """
        Args:
            chart_cols (list(ChartColumn)): list of chart columns
            ordering (list(int)): list of integers to indicate column ordering
        """
        
        if (ordering):
            chart_cols = \
                [chart_cols[x] for x in ordering]
        
        self.chart_cols = dict(enumerate(chart_cols))
        
    def __getitem__(self, key):
        return self.chart_cols[key]
        
    def __setitem__(self, key, item):
        self.chart_cols[key] = item


ch = Chart([ChartColumn(1,2,3), ChartColumn(3,2,1)], ordering=(1,0))
print(ch[0])