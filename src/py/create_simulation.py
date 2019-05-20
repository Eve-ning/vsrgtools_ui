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
import feather

def benchmark(f):
    def wrapper(*args, **kwargs):
        start = datetime.now()
        f(*args, **kwargs)
        end = datetime.now()
        elapsed = end - start
        print("{n} \t {t}".format(n = f.__name__, t = elapsed))
    return wrapper
    
class Simulator:
    '''Creates a Simulation Wrapper Class
    
    This class contains all the functions required to start the simulation
    
    Args:
        chart_path: Specify chart path to be simulated
        sm_df: Stress Mapping DataFrame, this is optional. Details below
        spike_func: Spike Function for the Stress Model. Details below
        decay_func: Decay Function for the Stress Model. Details below
        
    Stress Mapping DataFrame Requirements:
        If None is specified, a template self.sm_df is generated automatically.
        Before 'run()'-ing, grab that variable and modify it.
        
        The DataFrame must still contain the column for types. For other
        columns, it must exactly match requirements for your spike function.
        
        E.g.
        
        types | <kwarg name 1> | <kwarg name 2>
        ------+----------------+---------------
        note    <kwarg val A1>   <kwarg val A2>
        lnoteh  <kwarg val B1>   <kwarg val B2>
        lnotet  <kwarg val C1>   <kwarg val C2>
        
        Read Spike Function Requirements for kwarg details
        
    Spike Function Requirements:
        This is where you should specify how the value would change.
        'stress' as an argument is required.
        
        E.g.
        
        def spike_func(stress, adds, mults):
            (stress + adds) * mults
            
        (Refer to Stress Mapping DataFrame Requirements)
        During a Note:
            
        stress = (stress + <kwarg val A1>) * <kwarg val A2>
        
        To reiterate, kwargs used in the function must match ones used in the
        Stress Mapping DataFrame.
        
    Decay Function Requirements:
        Similar to Spike Function, but this occurs whenever there's nothing
        happening.
        'stress' and 'duration' are required arguments. Note that 'duration'
        is in ms.
        
        E.g.
        
        def decay_func(stress, duration):
            return stress / (2 ** (duration / 1000))
        
        Decay is entirely dependent on duration only.
        
        stress = stress / (2 ** (duration / 1000))
    '''
    
    def __init__(self,
                 chart_path,
                 sm_df = None,
                 spike_func = None,
                 decay_func = None):
        
        self.chart_path = chart_path
        
        if (not spike_func):
            self.spike_func =\
                lambda stress, adds, mults: (stress + adds) * mults
        else: self.spike_func = spike_func       
            
        if (not decay_func):
            self.decay_func =\
                lambda stress, duration: stress / (2 ** (duration / 1000))
        else: self.decay_func = decay_func

        if (not sm_df):
           self.sm_df =\
               pd.DataFrame([['note'],['lnoteh'],['lnotet']],
                            columns = ['types'])
        else: self.sm_df = sm_df
    
        self.chart = None
        
    def _load_default_stress_mapper(self):
        '''Loads a Default Mapping Dataframe for Stress Mapper'''
        self.note_add = 50
        self.note_mult = 1
        self.lnoteh_add = 50
        self.lnoteh_mult = 1
        self.lnotet_add = 50
        self.lnotet_mult = 1
        self.sm_df = pd.DataFrame([['note', self.note_add, self.note_mult],
                                  ['lnoteh', self.lnoteh_add, self.lnoteh_mult],
                                  ['lnotet', self.lnotet_add, self.lnotet_mult]],
                                 columns = ['types', 'adds', 'mults'])
    
    @benchmark
    def export_self(self, name):
        feather.write_dataframe(self.chart, "../feather/map/{}.feather".format(name))
        feather.write_dataframe(self.chart_stress, "../feather/map/{}_stress.feather".format(name))

    @benchmark
    def _chart_parser(self):
        # Read the map into a DataFrame
        self.chart = ChartParser(self.chart_path)
        self.chart = self.chart.parse_auto()
    
    @benchmark
    def _stress_mapper(self):
        # Create StressMapping with a DataFrame
        if (self.sm_df == None): # Means it's not defined
            self._load_default_stress_mapper()
        
        smp = StressMapper(self.sm_df)
        
        # Map over to the chart
        self.chart = smp.map_over(self.chart)

    @benchmark
    def _stress_model(self):
        # Specify Decay and Spike Functions, default if None
        if (not self.decay_func):
            def decay(stress, duration):
                return stress / (2 ** (duration / 1000))
        else:
            decay = self.decay_func
        
        if (not self.spike_func):
            def spike(stress, adds, mults):
                return (stress + adds) * mults
        else:
            spike = self.spike_func
    
        # Create StressModel
        self.smd = StressModel(decay_func = decay,
                               spike_func = spike,
                               stress = 0.0)
    
    @benchmark
    def _stress_sim(self):
        # Integrate into Stress Simulator
        ss = StressSim(self.smd)
    
        # Run the Simulation and assign new dataframe to chart.stress
        self.chart_stress = ss.simulate(self.chart)
    
    @benchmark
    def run(self):
        self._chart_parser()
        self._stress_mapper()
        self._stress_model()
        self._stress_sim()
        