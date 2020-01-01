*************************************************
         What Is Played In This Version?
*************************************************

This Version is developed from SRE under temperature prediction.
Contains more variables as input. 
Serves as control group to dynamic reservoir ensemble model.

***Structures Involved***

 1.1 Prediction of High/Low Temperature
     (v1.11 is the version with random weights;
      v1.12 is the version with fixed weights)
     (1_Input - 1_Reservoir - 1_Output)*2
     5_Input - 1_Reservoir - 1_Output (2 nuerons)
     5_Input - 5_Reservoir - 1_Output (2 nuerons)
     5_Input - 3_Reservoir - 1_Output (2 nuerons)

 1.2 Prediction of Avg. Temperature
     2_Input - 2_Reservoir - 1_Avg._Output
     HighTemp_Input - 1_Reservoir - 1_Avg._Output
     LowTemp_Input - 1_Reservoir - 1_Avg._Output

***Input Variables Involved***

DEWP + STP + WDSP + MAX + MIN