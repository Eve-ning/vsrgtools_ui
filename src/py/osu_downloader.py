# -*- coding: utf-8 -*-
"""
Created on Sun May 19 23:30:38 2019

@author: johnc
"""

import requests
from time import sleep

# ---

class OsuDownloader:
    
    def __init__(self):
        self.session = self._osu_auth()
        
    def __del__(self):
        self.session.close()
        
    def _osu_auth(self):
        s = requests.Session()
    
        headers = {
            'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:65.0) Gecko/20100101 Firefox/65.0',
            'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8',
            'Accept-Language': 'en-US,en;q=0.5',
            'Accept-Encoding': 'gzip, deflate, br',
            'Referer': 'https://osu.ppy.sh/forum/',
            'DNT': '1',
            'Connection': 'keep-alive',
            'Upgrade-Insecure-Requests': '1',
            'TE': 'Trailers'
                }
        
        auth_file = open('D:/All/Documents/Authorization Keys/osu_full.txt', 'r')
        auth_r = auth_file.read().splitlines()
        usr = auth_r[0]
        sec = auth_r[1]
        
        auth_file.close()
        
        form_data = {
            'username': usr,
            'password': sec,
            'login': 'login'
                }
        
        s.post('https://osu.ppy.sh/', data=form_data, headers=headers)
        
        return s
    
    def osu_diff_get(self, beatmap_id: int):
        
        sleep(1)
        r = self.session.get("https://osu.ppy.sh/osu/" + str(beatmap_id))
        r.raise_for_status()
        return r.text