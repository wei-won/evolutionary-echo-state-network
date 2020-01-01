initialRun = 100;
T = 500; % number of pattern presentations
tau = 10;
eta = 0.001;

Theta = zeros(100,T);
Theta(:,1) = 0.01*ones(100,1);

W = intWM0';
y = stateCollectMat(:,1:100)';
x = stateCollectMat(:,1:100)';

% creat mask 0/1 matrix
WMmask = zeros(size(W));
WMmask(find(W))=1;

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

for ti = initialRun+12:initialRun+T+10
%     [W(:,ti),Theta(:,ti)] = ...
%         BCM(W(:,ti-1),Theta(:,ti-1),y(:,ti-1),x(:,ti-1),eta,tau);
%     y(:,ti) = f(W(:,ti)' * x(:,ti));
    
%     y = stateCollectMat(ti-1,1:100)';
%     x = stateCollectMat(ti-2,1:100)';
    
    deltaTheta = 1/tau * ( y(:,ti-initialRun-1).^2 - Theta(:,ti-initialRun-11) );
    deltaW = eta * x(:,ti-initialRun-2) * (y(:,ti-initialRun-1) .* ( y(:,ti-initialRun-1) - Theta(:,ti-initialRun-11)))';
    
    Theta(:,ti-initialRun-10) = Theta(:,ti-initialRun-11) + deltaTheta;
%     W(:,ti) = W(:,ti-1) + deltaW;
    W = (W + deltaW).*WMmask;
    
    x(:,ti-initialRun-1) = y(:,ti-initialRun-1);
%     y(:,ti) = f(W(:,ti)' * x(:,ti));
    y(:,ti-initialRun) = f(W' * x(:,ti-initialRun-1));
    
end

intWM0 = W';

learnAndTest