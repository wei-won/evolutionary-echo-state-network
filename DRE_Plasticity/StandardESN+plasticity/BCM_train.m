initialRun = 100;
T = 500; % number of pattern presentations
tau = 100;
eta = 0.001;

Theta = zeros(100,T);
Theta(:,1) = 0.01*ones(100,1);

W = inWM';
y = stateCollectMat(:,1:100)';
x = sampleinput;

for ti = initialRun+11:initialRun+T+10
%     [W(:,ti),Theta(:,ti)] = ...
%         BCM(W(:,ti-1),Theta(:,ti-1),y(:,ti-1),x(:,ti-1),eta,tau);
%     y(:,ti) = f(W(:,ti)' * x(:,ti));
    
    deltaTheta = 1/tau * ( y(:,ti-initialRun-1).^2 - Theta(:,ti-initialRun-1) );
    deltaW = eta * x(:,ti-initialRun-1) * (y(:,ti-initialRun-1) .* ( y(:,ti-initialRun-1) - Theta(:,ti-initialRun-1)))';
    
    Theta(:,ti-initialRun) = Theta(:,ti-initialRun-1) + deltaTheta;
%     W(:,ti) = W(:,ti-1) + deltaW;
    W = W + deltaW;
    
%     y(:,ti) = f(W(:,ti)' * x(:,ti));
    y(:,ti-initialRun) = f(W' * x(:,ti-initialRun));

end

inWM = W';

learnAndTest