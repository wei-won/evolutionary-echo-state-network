This work was implemented and improved by Wei Wang and Hsiao-Tien Fan, under Prof. Zhanpeng Jin's supervision and guidance. The codes were built and heavily modified based on a standard ESN tool from Herbert Jaeger.

=================Contents=================
The provided codes implement Dynamic Ensembles of Reservoir Networks using different network structure and training strategy. Several models are introduced in different folders:

- static_reservoir_ensemble
  Implements RC ensemble network with fixed structural connection (input/output connection & connections between sub-reservoirs) and different structure configurations. Also referred to as SRE.

- dynamic_reservior_ensemble
  Implements RC ensemble network with adaptive structural connection (input/output connection & connections between sub-reservoirs). Genetic Algorithm is adopted for structural evolution. Also referred to as DRE.

- DRE_Plasticity
  RC ensemble network that utilizes both structural evolution and synaptic evolution. Synaptic evolution is applied on an evolved DRE network. 

- Plasticity_DRE
  RC ensemble network that utilizes both structural evolution and synaptic evolution. Synaptic plasticity is implemented FIRST on a fully connected SRE network, then dynamic structure evolution is carried out later by GA to adapt a DRE structure.

=================Usage====================
File description (see comments within files for more details):

Helper functions:

f.m, fInverse.m: the sigmoid functions used and their inverse

minusPoint5.m, myeigs.m: helper functions used in network generation

createEmptyFigs.m: should be run once at every session, creates 
empty figs in the left bottom screen corner (where I want to have them). 

The really important functions that do the work:

generateTrainTestData.m/generate_weather.m: as the name says. This is the file that produce (or import) the training and testing data.

generateNet.m: as the name says

buildStructure.m: generate the configured RC ensemble network.

learnAndTest.m: the main learning and testing script. It first runs 
a part of the training data through the network for training, then
computes the readout weights, then continues this run with the rest
of the training data and the learnt output weights to check performance
of the trained model on these "test" data (that is, we split the given
sequence into a training and a testing part). 

continueRun.m: when a network has been trained, use this
for testing it on novel data

=================Acknowledgement==========
The codes are built on the original "VerySimpleESNToolbox" codes provided by Herbert Jaeger.

Thanks for the authors' sharing!