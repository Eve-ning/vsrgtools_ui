# -*- coding: utf-8 -*-
"""
Created on Sun May 19 18:18:57 2019

@author: johnc
"""

import osu_api
import pandas as pd, feather

api = osu_api.OsuAPI()

# Maniera - Jupiter -
rep, status_code = api.get_replay(beatmap_id=646681,
                                  mode=3,
                                  user=7919724)

print(status_code)

df = pd.DataFrame(rep, columns=('offset', 'action'))
feather.write_dataframe(df, '../feather/replay/manieraJupiter.feather')