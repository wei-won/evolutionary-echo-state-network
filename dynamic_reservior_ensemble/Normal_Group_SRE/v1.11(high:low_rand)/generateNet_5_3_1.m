% Create a ESN network. Call of this script returns: 
% 1. intWM0, sparse weight matrix of reservoir scaled to spectral radius 1, 
% 2. inWM random matrix of input-to-reservoir weights, 
% 3. ofbWM, output feedback weight matrix, 
% 4. initialOutWM all-zero initial weight matrix of reservoir-to-output units (is replaced
% by learnt weights as result of learning)

% note that variables netDim, inputLength, outputLength, connectivity must
% be set before this script is run (preferably by calling headers.m)


totalDim = reservoirNum * netDim + inputLength + outputLength;

disp('Creating network ............');


% minusPoint5 is a little helper
% function that subtracts 0.5 from entries of a sparse matrix.


success = 0;
while not(success)
    try
        
intWM0 = sprand(netDim, netDim, connectivity);
intWM0 = spfun(@minusPoint5,intWM0);
opts.disp = 0;
SR0 = abs(eigs(intWM0,1, 'lm', opts));
intWM0 = intWM0/SR0;

intWM1 = sprand(netDim, netDim, connectivity);
intWM1 = spfun(@minusPoint5,intWM1);
opts.disp = 0;
SR1 = abs(eigs(intWM1,1, 'lm', opts));
intWM1 = intWM1/SR1;

intWM2 = sprand(netDim, netDim, connectivity);
intWM2 = spfun(@minusPoint5,intWM2);
opts.disp = 0;
SR2 = abs(eigs(intWM2,1, 'lm', opts));
intWM2 = intWM2/SR2;

% intWM3 = sprand(netDim, netDim, connectivity);
% intWM3 = spfun(@minusPoint5,intWM3);
% opts.disp = 0;
% SR3 = abs(eigs(intWM3,1, 'lm', opts));
% intWM3 = intWM3/SR3;
% 
% intWM4 = sprand(netDim, netDim, connectivity);
% intWM4 = spfun(@minusPoint5,intWM4);
% opts.disp = 0;
% SR4 = abs(eigs(intWM4,1, 'lm', opts));
% intWM4 = intWM4/SR4;

success = 1;
    catch
        ;
    end
end



% input weight matrix has weight vectors per input unit in colums
inWM0 = 2.0 * rand(netDim, 15)- 1.0;
inWM1 = 2.0 * rand(netDim, 15)- 1.0;
inWM2 = 2.0 * rand(netDim, 15)- 1.0;
inWM3 = 2.0 * rand(netDim, 15)- 1.0;
inWM4 = 2.0 * rand(netDim, 15)- 1.0;
inWMzero = zeros(netDim,15);
inWM = [inWM0,inWMzero,inWMzero,inWM3,inWM4;inWMzero,inWM1,inWMzero,inWMzero,inWMzero;inWMzero,inWMzero,inWM2,inWMzero,inWMzero];

% output weight matrix has weights for output units in rows
% includes weights for input-to-output connections
initialOutWM = zeros(outputLength, reservoirNum * netDim + inputLength);

%output feedback weight matrix has weights in columns
ofbWM0 = (2.0 * rand(netDim, outputLength)- 1.0);
ofbWM1 = (2.0 * rand(netDim, outputLength)- 1.0);
ofbWM2 = (2.0 * rand(netDim, outputLength)- 1.0);
% ofbWM3 = (2.0 * rand(netDim, outputLength)- 1.0);
% ofbWM4 = (2.0 * rand(netDim, outputLength)- 1.0);