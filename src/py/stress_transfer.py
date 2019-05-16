# -*- coding: utf-8 -*-
"""
Created on Wed May 15 21:48:39 2019

@author: johnc
"""

'''Stress Transfer Primer

Stress Transfer is when stress from one finger transmits to the others.

It is important to note that these are configurable settings, not absolutes.
This is because different players have different playstyles and personal
configurations.
This also means that we will not be able to account for all of these anomalies,
we can only estimate the mean.

Output:
    Contrast to the input, which is a long table for column + offset + type    

Stress Transfer (ST) is dependent on these things:
    
-   Hand Bias

    ST is heavier on the same hand, hence we will transfer a higher amount of
    stress over to the fingers of the same hand.
    
    Note that the fingers on the other hand will still gain stress, but not as
    much.
    
-   Pattern Bias/Controller Bias

    Some patterns generate more ST when done together:
        12-3-12-3-12-3 is easier than
        13-2-13-2-13-2 on keyboard
        
        However, they are both arguably easy on an IIDX controller



'''