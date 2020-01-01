%% setup BCM parameters
initialRun = 100;
T = 500; % number of pattern presentations
tau = 10;
eta = 0.005;
plasticity = true;
learnTarget = 'intWeights'; % intWeights, allWeights, intinWeights

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
    

% 

% y = stateCollectMat(:,1:100)';
% x = sampleinput;

% creat mask 0/1 matrix
WMmask = zeros(size(W));
WMmask(find(W)) = 1;

% % 2nd approach
% WMmask = W & 1;
% 
% % 3rd approach
% WMmask = W~=0;
% 
% % 4th approach
% WMmask = W;
% WMmask(WMmask ~= 0) = 1;
% 
% % 5th approach
% WMmask = WMmask(find(W)) = 1;
% WMmask = reshape(WMmask,size(W));

%% learn
learnAndTest_withBCM