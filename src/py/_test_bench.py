"""
Created on Mon May 13 13:28:14 2019

@author: johnc
"""

''' This is the main test file '''

from chart_parser import ChartParser
from stress_mapper import StressMapper
from stress_sim import StressSim
from stress_model import StressModel
import pandas as pd
from datetime import datetime

def benchmark(f):
    def wrapper(*args, **kwargs):
        start = datetime.now()
        f(*args, **kwargs)
        end = datetime.now()
        elapsed = end - start
        print("{n} \t {t}".format(n = f.__name__, t = elapsed))
    return wrapper
    
class main:
    
    def __init__(self, chart_path):
        self.chart_path = chart_path
        self.chart = None
    

    @benchmark
    def _chart_parser(self):
        # Read the map into a DataFrame
        self.chart = ChartParser(self.chart_path)
        self.chart = self.chart.parse_auto()
    
    @benchmark
    def _stress_mapper(self):
        # Create StressMapping with a DataFrame
        sm_df = pd.DataFrame([['note',   50, 1],
                              ['lnoteh', 50, 1],
                              ['lnotet', 50, 1]],
                             columns = ['types', 'adds', 'mults'])
        
        smp = StressMapper(sm_df)
        
        # Map over to the chart
        self.chart = smp.map_over(self.chart)

    @benchmark
    def _stress_model(self):
        # Specify Decay and Spike Functions
        def decay(stress, duration):
            return(stress / (2 ** (duration / 1000)))
        def spike(stress, adds, mults):
            return (stress + adds) * mults
    
        # Create StressModel
        self.smd = StressModel(decay_func = decay,
                               spike_func = spike,
                               stress = 0.0)
    
    @benchmark
    def _stress_sim(self):
        # Integrate into Stress Simulator
        ss = StressSim(self.smd)
    
        # Run the Simulation and assign new dataframe to chart.stress
        self.chart_stress = ss.simulate(self.chart, 1000)
        
    @benchmark
    def _stress_plot(self):
        pass
    # Plot out chart
#    ggplot(chart.stress) +
#      aes(x = offsets,
#          y = stress) +
#      geom_smooth(aes(group = columns, color = factor(columns)),
#                  se = F)
    
    def run(self):
        self._chart_parser()
        self._stress_mapper()
        self._stress_model()
        self._stress_sim()
        self._stress_plot()
        
c = main("../osu/Camellia VS. lapix - Hypnotize (Evening) [bool worldwpdrive(const Entity &user);].osu")
c.run()