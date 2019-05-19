# -*- coding: utf-8 -*-
"""
Created on Sun May 19 23:14:19 2019

@author: johnc
"""

from osu_api import OsuAPI
from osu_downloader import OsuDownloader
import pandas as pd
import feather

class Interface:
    def __init__(self, beatmap_id, file_name):
        self.api = OsuAPI()
        self.down = OsuDownloader()
        self.beatmap_id = beatmap_id
        self.save_dir = '../'
        self.file_name = file_name
    
    def grab_replay(self, user_id):
        data = self.api.get_replay(self.beatmap_id,
                                   3,
                                   user_id)
        self.save_replay(data)
        
    def save_replay(self, replay_data):
        df = pd.DataFrame(replay_data, columns=('offsets', 'actions'))
        feather.write_dataframe(df,
                                self.save_dir + 'feather/replay/' +\
                                self.file_name + '.feather')
        
    def grab_beatmap(self):
        data = self.down.osu_diff_get(self.beatmap_id)
        with open(self.save_dir + 'osu/' + self.file_name + '.osu', 'wb+') as f:
            f.write(data.encode("UTF-8"))
            


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
                print("Replay {} grabbed".format(user_id))
                
                if (user_id == ""):
                    break
    except:
        print("Quitting.")
        input("Type anything to quit...")
                
            
if (__name__ == "__main__"):
    user_interface()
        
    
    
    
        