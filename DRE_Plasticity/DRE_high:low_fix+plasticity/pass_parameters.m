addpath(genpath('./genes_and_weight_mats_old'));

% load('BCM_first_no_GA_tau300_eta0055_T600.mat'); % For GA after synaptic plasticity

load('intWM_3.mat');
load('inWM_3.mat');
load('ofbWM_3.mat');

% load('intWM_200(3).mat');
% load('inWM_200(3).mat');
% load('ofbWM_200(3).mat');

load('sampleinput.mat');
load('sampleoutput.mat');
% sampleout = (sampleout*0.8)+0.5;
% sampleinput = (sampleinput*0.8)+0.5;

fitnessFunc = @(gene)passFunc(gene,sampleinput,sampleout,intWM,inWM,ofbWM0);