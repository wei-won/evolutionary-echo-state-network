load('intWM_3.mat');
load('inWM_3.mat');
load('ofbWM_3.mat');
load('sampleinput.mat');
load('sampleoutput.mat');
f = @(gene)passFunc(gene,sampleinput,sampleout,intWM,inWM,ofbWM0);