%% load reservoir ensemble structure and input/teacher signal
addpath(genpath('./learning_rules'));
addpath(genpath('./genes_and_weight_mats_old'));

% load('gene_100(1).mat');
% 
% load('intWM_100(1).mat');
% load('inWM_100(1).mat');
% load('ofbWM_100(1).mat');
% 
% load('sampleinput.mat');
% load('sampleoutput.mat');
% 
% %% initialization
% headers;
% connectMat = reshape(gene,inputVarNum+outputLength,reservoirNum).';
% buildStructure;


%% setup BCM parameters
initialRun = 100;
T = 500; % number of pattern presentations
tau = 10;
eta = 0.0001;
plasticity = true;

Theta = zeros(ensembleDim,T);
Theta(:,1) = 0.01*ones(ensembleDim,1);

% W = [intWM';inWM']; % learn input weights and internal weights
W = intWM'; % learn only internal weights

y = stateCollectMat(:,1:ensembleDim)';
x = stateCollectMat(:,1:ensembleDim)';

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

%%
for ti = initialRunlength+12:initialRunlength+T+10
%     [W(:,ti),Theta(:,ti)] = ...
%         BCM(W(:,ti-1),Theta(:,ti-1),y(:,ti-1),x(:,ti-1),eta,tau);
%     y(:,ti) = f(W(:,ti)' * x(:,ti));
    
    deltaTheta = 1/tau * ( y(:,ti-initialRunlength-1).^2 - Theta(:,ti-initialRunlength-11) );
    deltaW = eta * x(:,ti-initialRunlength-2) * (y(:,ti-initialRunlength-1) .* ( y(:,ti-initialRunlength-1) - Theta(:,ti-initialRunlength-11)))';
    
    Theta(:,ti-initialRunlength-10) = Theta(:,ti-initialRunlength-11) + deltaTheta;
%     W(:,ti) = W(:,ti-1) + deltaW;
    W = (W + deltaW).*WMmask;
    
%     x(:,ti-initialRun-1) = y(:,ti-initialRun-1);
%     y(:,ti) = f(W(:,ti)' * x(:,ti));
    y(:,ti-initialRunlength) = f(W' * x(:,ti-initialRun-1),neuronType);

end

intWM = W';

%%
learnAndTest