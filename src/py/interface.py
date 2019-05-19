# -*- coding: utf-8 -*-
"""
Created on Sun May 19 23:14:19 2019

@author: johnc
"""

from osu_api import OsuAPI
from osu_downloader import OsuDownloader
from create_simulation import Simulator
import pandas as pd
import feather

class Interface:
    def __init__(self, beatmap_id, file_name):
        
        self.file_name = file_name
        self.beatmap_id = beatmap_id
        self.save_dir = '../'
        self.save_osu_dir = self.save_dir + 'osu/' + self.file_name + '.osu'

        
        self.api = OsuAPI()
        self.down = OsuDownloader()
        self.sim = Simulator(self.save_osu_dir)
        
    def grab_replay(self, user_id):
        data, _ = self.api.get_replay(self.beatmap_id,
                                      3,
                                      user_id)
        self.save_replay(data, user_id)
        
    def save_replay(self, replay_data, user_id):
        df = pd.DataFrame(replay_data, columns=('offsets', 'actions'))
        feather.write_dataframe(df,
                                self.save_dir + 'feather/replay/' +\
                                str(user_id) + "_" +\
                                self.file_name + '.feather')
        
    def grab_beatmap(self):
        data = self.down.osu_diff_get(self.beatmap_id)
        with open(self.save_dir + 'osu/' + self.file_name + '.osu', 'wb+') as f:
            f.write(data.encode("UTF-8"))
            
        self._simulate_beatmap()
        
    def _simulate_beatmap(self):
        self.sim.run()
        self.sim.export_self(self.file_name)
        
def user_interface():
    print("osu! Api and .osu downloader interface")
    print("Type 'quit' anytime to quit")

    try:
        while (True):
            beatmap_id = int(input("Input Beatmap ID to grab: "))
            file_name = input("Input File Name: ")
            if (file_name == 'quit'):
                return
            
            it = Interface(beatmap_id, file_name)
            
            it.grab_beatmap()
            
            print("Beatmap Grabbed as {}".format("file_name"))
            print("Grab Replays by adding user IDs below, enter nothing to stop.")
    
            while (True):
                user_id = int(input(">"))
                it.grab_replay(user_id)
                print("Replay {} grabbed".format(user_id))
                
                if (user_id == ""):
                    break
    

    except:
        print("Quitting.")
        input("Type anything to quit...")
                
            
if (__name__ == "__main__"):
    user_interface()

    
    
    
        