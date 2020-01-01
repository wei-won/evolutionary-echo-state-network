% currentFolder = pwd;
addpath(genpath('./learning_rules'));
addpath(genpath('./genes_and_weight_mats_old'));
addpath('../gene_mats/genes_new');

plasticity = false;

load('intWM_3.mat');
load('inWM_3.mat');
load('ofbWM_3.mat');

% load('gene_40(1).mat');
load('gene_40(2)_WMs3.mat');

% load('intWM_100(1).mat');
% load('inWM_100(1).mat');
% load('ofbWM_100(1).mat');

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