*************************************************
           Dynamic Reservoir Ensemble
*************************************************
This part implements the Dynamic RC Ensemble Network that enables the structural evolution using GA. Contents include:

- DRE_high/low_fix 
  Prediction of high/low temperature using DRE with fixed weights.
  5_5_2 Structure: 5_Input - 5_Reservoir - 2_Output

- DRE_avg_fix 
  Prediction of average temperature using DRE with fixed weights.
  5_5_1 Structure: 5_Input - 5_Reservoir - 1_Output

- Normal_Group_SRE
  Prediction of high/low and average temperature using SRE with fixed or random weights.
  Multiple structures used. Details can be found in the readme.txt within the folder.


To run the structure evolution from scratch, following this order:
- pass_parameters.m
- runga.m

To run on a evolved structure, declare the gene in run_individual.m and run the following:
- run_individual.m


Data and weights are stored in files below:
- sampleinput.mat
- sampleoutput.mat
- intWM.mat
- inWM.mat
- ofbWM.mat