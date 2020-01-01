clear;
% addpath(genpath('../genes_and_weight_mats_old'));
% load('../../genes_new/gene_40(2)_WMs3.mat');

% load('sampleinput.mat');
% load('sampleoutput.mat');

nrmse = [];
avg_nrmse = [];

%% setup BCM parameters
initialRun = 100;
% T = 500; % number of pattern presentations
tau = 300;
% eta = 0.0001;
% plasticity = true;
learnTarget = 'intWeights'; % intWeights, allWeights, intinWeights

%% Test Begin
h = waitbar(0,'Please wait...');
% seqeta = 0.0005:0.0005:0.01; % For learning target "intWeights"
seqeta = 0.000025:0.000025:0.0005; % For learning target "allWeights"
% seqeta = 0.0055; % Optimal eta after opt test
Leta = length(seqeta);
seqT = 50:50:900;
% seqT = 600; % Optimal T after opt test
LT = length(seqT);
steps = Leta * LT;
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
        
        learnAndTest_withBCM;
        nrmse=[nrmse;NRMSE];
        avg_nrmse = [avg_nrmse;avg_NRMSE];
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

%% save weight mats after BCM
 
% save('BCM_first_no_GA_tau300_eta0055_T600.mat','intWM','inWM','inWM0','learnTarget','NRMSE','ofbWM','ofbWM0','outWM','outWM0','seqeta','seqT','tau');