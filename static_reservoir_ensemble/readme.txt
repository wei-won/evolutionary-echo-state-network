*************************************************
           Static Reservoir Ensemble
*************************************************
This part includes the contents below:

- sre_high/low_temp 
  Prediction of High/Low Temperature (3 structures):
    1_1_1: (1_Input - 1_Reservoir - 1_Output)*2
           HighTemp_Input - 1_Reservoir - 1_Avg._Output
           LowTemp_Input - 1_Reservoir - 1_Avg._Output
    2_1_1: 2_Input - 1_Reservoir - 1_Output (2 nuerons)
    2_2_1: 2_Input - 2_Reservoir - 1_Output (2 nuerons)

- sre_avg_temp 
  Prediction of Avg. Temperature (3 structures):
    1_1_1: (1_Input - 1_Reservoir - 1_Output)*2
           HighTemp_Input - 1_Reservoir - 1_Avg._Output
           LowTemp_Input - 1_Reservoir - 1_Avg._Output
    2_1_1: 2_Input - 1_Reservoir - 1_Output (1 nueron)
    2_2_1: 2_Input - 2_Reservoir - 1_Output (1 nueron)


Run the codes following this order:
- headers_***.m
- generate_data.m
- generate_weather.m
- createEmptyFigs.m
- generateNet_***.m
- learnAndTest_***.m
