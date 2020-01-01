gene = [0,0,1,0,1,0,1,0,0,1,1,1,1,1,1,0,1,1,0,1,0,1,0,1,1,0,1,0,1,0,0,1,1,0,0]; % declare the gene here in the form of 35 binary values
load('intWM_3.mat');
load('inWM_3.mat');
load('ofbWM_3.mat');
load('sampleinput.mat');
load('sampleoutput.mat');
headers;
connectMat = reshape(gene,inputVarNum+outputLength,reservoirNum).';
buildStructure;
learnAndTest;

mse(1) = msetest(1);
mse(2) = msetest(2);