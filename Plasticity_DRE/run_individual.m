% currentFolder = pwd;
addpath(genpath('./learning_rules'));
addpath(genpath('./genes_and_weight_mats_old'));
addpath('../DRE_Plasticity/gene_mats/genes_new');

plasticity = false;

load('intWM_3.mat');
load('inWM_3.mat');
load('ofbWM_3.mat');

% load('BCM_first_no_GA_tau300_eta0055_T600.mat'); % For GA after synaptic plasticity

gene = ones(1,35); % For synaptic plasticity first then GA
% gene = [1,0,1,1,1,0,1,0,1,0,1,0,1,1,1,1,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,0,0]; % For GA after synaptic plasticity

load('sampleinput.mat');
load('sampleoutput.mat');

% sampleout = (sampleout*0.8)+0.5;
% sampleinput = (sampleinput*0.8)+0.5;

headers;
connectMat = reshape(gene,inputVarNum+outputLength,reservoirNum).';
buildStructure;
learnAndTest;

mse(1) = msetest(1);
mse(2) = msetest(2);