clear;
addpath('../');
% addpath(genpath('../genes_and_weight_mats_old'));
% load('../../genes_new/gene_40(2)_WMs3.mat');

% load('sampleinput.mat');
% load('sampleoutput.mat');

nrmse = [];
avg_nrmse = [];

%% setup BCM parameters

ruleOpt = 'BCM';
initialRun = 100;
synapTrainOpt = 'online'; % Can be 'online' or 'offline'
tau = 260;
learnTarget = 'intWeights'; % Can choose from 'intWeights', 'allWeights', 'intinWeights'

getSR = 'true';
getWeights = 'false';

% seqeta = 0.0005:0.0005:0.01; % For learning target "intWeights"
% seqeta = 0.0105:0.0005:0.02;
seqeta = 0.007;
% seqeta = 0.000025:0.000025:0.0005; % For learning target "allWeights"
% seqeta = 0.0001:0.0001:0.001;
seqT = 50:50:900;

Leta = length(seqeta);
LT = length(seqT);
steps = Leta * LT;

if getSR
    sr = [];
end
if getWeights
    weightCollection = struct('inW',[],'outW',[],'ofbW',[],'intW',[]);
end

%% Test Begin

h = waitbar(0,'Please wait...');
step = 0;
for ieta = 1:Leta
    eta = seqeta(ieta);
    for iT = 1:LT
        T = seqT(iT);
        step = step + 1;
        
        run_individual;
        
        plasticity = true;
        Theta = zeros(ensembleDim,T);
        Theta(:,1) = 0.01*ones(ensembleDim,1);
      
        switch(learnTarget)    
            case 'intWeights'
                W = intWM'; % learn only internal weights
            case 'allWeights'
                W = [intWM';inWM';ofbWM']; % learn input weights and internal weights and out
            case 'intinWeights'
                W = [intWM';inWM']; % learn input weights and internal weights
            otherwise
                error(['Unknown learning target' learnTarget]);
        end
      
        % creat mask 0/1 matrix
        WMmask = zeros(size(W));
        WMmask(find(W)) = 1;

        % % 2nd approach % WMmask = W & 1;
        % 
        % % 3rd approach % WMmask = W~=0;
        % 
        % % 4th approach % WMmask = W; WMmask(WMmask ~= 0) = 1;
        % 
        % % 5th approach % WMmask = WMmask(find(W)) = 1; WMmask = reshape(WMmask,size(W));
        
%         learnAndTest_withBCM;        
        switch(synapTrainOpt)    
            case 'online' % online synaptic learning
                learnAndTest_withBCM;
            case 'offline' % offline synaptic learning
                pretrainSynap;
                learnAndTest;
            otherwise
                error(['Unknown learning option' synapTrainOpt]);
        end
        
        nrmse=[nrmse;NRMSE];
        avg_nrmse = [avg_nrmse;avg_NRMSE];
        if getSR 
            sr = [sr;SR];
        end
        waitbar(step/steps,h,['Please wait...(' num2str(step) '/' num2str(steps) ')'])
    end
end
close(h)

%% reshape result mats
nrmseReshape = zeros(Leta*2,LT);
for i = 1:Leta
    nrmseReshape((i-1)*2+1,:) = nrmse((i-1)*LT+1:i*LT,1);
    nrmseReshape((i-1)*2+2,:) = nrmse((i-1)*LT+1:i*LT,2);
end

avg_nrmseReshape = reshape(avg_nrmse,LT,Leta)';

%% save results

% save('BCM_optTest_results_gene40(2)WMs3.mat','avg_nrmse','nrmse','avg_nrmseReshape','nrmseReshape','gene','initialRun','tau','learnTarget','seqT','seqeta');