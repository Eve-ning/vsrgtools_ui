# -*- coding: utf-8 -*-
"""
Created on Sun May 19 18:18:57 2019

@author: johnc
"""

import osu_api
import pandas as pd, feather

api = osu_api.OsuAPI()

beatmap_id = 646681
user = 7919724

# Maniera - Jupiter -
def get_replay():
    rep, status_code = api.get_replay(beatmap_id=beatmap_id,
                                      mode=3,
                                      user=user)
    
    if (status_code != 200):
        raise Exception("Status: {}".format(status_code))
    
    return rep

df = pd.DataFrame(get_replay(), columns=('offsets', 'actions'))
feather.write_dataframe(df, '../feather/replay/manieraJupiter.feather')