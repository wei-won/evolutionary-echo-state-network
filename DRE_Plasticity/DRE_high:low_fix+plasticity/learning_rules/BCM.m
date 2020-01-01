%%% implementation of the BCM learning rule
%
% INPUT
% W_in : NxM dimensional weight vector ( N being the dimension of x and M
%        being the dimension of y)
% Theta_in : Mx1 dimensional threshold
% y :    Mx1 vector of output firing rates
% x :    Nx1 vector of input firing rates
% eta:   scalar denoting learning rate
% tau:   scalar denoting time constant
%
% OUTPUT
% W :    NxM dimensional weight vector
% Theta: Mx1 dimensional threshold

function [W,Theta] = BCM(W_in,Theta_in,y,x,eta,tau)

% Theta = <y^2>
deltaTheta = 1/tau * ( y.^2 - Theta_in );

% BCM rule
deltaW = eta * x * (y .* ( y - Theta_in))';

Theta = Theta_in + deltaTheta;
W = W_in + deltaW;
    

end
