*************************************************
                  Plasticity + DRE
*************************************************
This part implements the Dynamic RC Ensemble Network that enables both structural evolution using GA and synaptic plasticity using different learning rules. Contents include:

- DRE_high/low_fix+plasticity 
  Apply synaptic plasticity on evolved DRE structure. 
  
- StandardESN+plasticity
  Apply synaptic plasticity on standard ESN network.


***** Synaptic Learning Rules Used ********
- Hebb's Rule (with/without decay)
- Oja's Learning
- BCM
- Principal Neuron Reinforcement (PNR)


******* Run The Following for DRE *********
To implement synaptic plasticity on DRE and to find the optimal setting, run the files below in folder "learning_rules"

- Hebb_new_optTest.m
- Hebb_with_decay_new_optTest.m
- AntiOja_new_optTest.m
- BCM_optTest_slidingT.m OR BCM_optTest.m
- PNR_for_DRE.m


************ Other Features ***************
For all the learning rules different options are available for synaptic training. These can be set in the above files.

synapTrainOpt:
- online
- offline (with pre-training for synaptic connections embedded)

learnTarget:
- intWeights (learning only internal weights within each reservoir)
- intinWeights (learning internal weights + input weights)
- allWeights (learning input weights, internal weights and out)