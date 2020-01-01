% Create a ESN network. Call of this script returns: 
% 1. intWM0, sparse weight matrix of reservoir scaled to spectral radius 1, 
% 2. inWM random matrix of input-to-reservoir weights, 
% 3. ofbWM, output feedback weight matrix, 
% 4. initialOutWM all-zero initial weight matrix of reservoir-to-output units (is replaced
% by learnt weights as result of learning)

% note that variables netDim, inputLength, outputLength, connectivity must
% be set before this script is run (preferably by calling headers.m)


totalDim = reservoirNum * netDim + inputLength + outputLength;

% disp('Creating network ............');


% minusPoint5 is a little helper
% function that subtracts 0.5 from entries of a sparse matrix.


success = 0;
while not(success)
    try
        
    intWM0 = sprand(reservoirNum * netDim, reservoirNum * netDim, interConnectivity);
    intWM0 = spfun(@minusPoint5,intWM0);
    opts.disp = 0;
    SR0 = abs(eigs(intWM0,1, 'lm', opts));
    intWM0 = intWM0/SR0;

    intWM0 = mat2cell(intWM0, netDim*ones(1,reservoirNum), netDim*ones(1,reservoirNum));
    
    for i = 1:reservoirNum;
        intWM0{i,i} = sprand(netDim, netDim, connectivity);
        intWM0{i,i} = spfun(@minusPoint5,intWM0{i,i});
        opts.disp = 0;
        SR = abs(eigs(intWM0{i,i},1, 'lm', opts));
        intWM0{i,i} = intWM0{i,i}/SR * specRad;
    end

    intWM = cell2mat(intWM0);

    success = 1;
    catch
        ;
    end
end

inWM = 2.0 * rand(reservoirNum * netDim, inputLength) - 1.0;

% % input weight matrix has weight vectors per input unit in colums
% inWM0 = ones(reservoirNum * netDim, inputLength);
% inWM0 = mat2cell(inWM0, netDim*ones(1,reservoirNum), inputLengthVar*ones(1,inputVarNum));
% for i = 1:reservoirNum
%     for j =1:inputVarNum
%         inWM0{i,j} = connectMat(i,j) * (2.0 * rand(netDim, inputLengthVar)- 1.0);
%     end
% end
% inWM = cell2mat(inWM0);

% output weight matrix has weights for output units in rows
% includes weights for input-to-output connections

% initialOutWM = zeros(outputLength, reservoirNum * netDim);
initialOutWM = zeros(outputLength, reservoirNum * netDim + inputLength);

ofbWM0 = 2.0 * rand(reservoirNum * netDim, outputLength)- 1.0;

% % output feedback weight matrix has weights in columns

% ofbWM0 = zeros(reservoirNum * netDim, outputLength);
% ofbWM0 = mat2cell(ofbWM0, netDim*ones(1,reservoirNum), ones(1,outputLength));
% 
% for i = 1:reservoirNum
%     for j = 1:outputLength
%         ofbWM0{i,j} = connectMat(i,inputVarNum+j) * (2.0 * rand(netDim, 1)- 1.0) ...
%             * ofbSC(j);
%     end
% end
% ofbWM = cell2mat(ofbWM0);


% ofbWM0 = (2.0 * rand(netDim, outputLength)- 1.0);
% ofbWM1 = (2.0 * rand(netDim, outputLength)- 1.0);

% Save weight matrices to files
save('intWM_200(3).mat','intWM');
save('inWM_200(3).mat','inWM');
save('ofbWM_200(3).mat','ofbWM0');

