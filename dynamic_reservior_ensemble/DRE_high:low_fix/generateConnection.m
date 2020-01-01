% input weight matrix has weight vectors per input unit in colums
inWM0 = ones(reservoirNum * netDim, inputLength);
inWM0 = mat2cell(inWM0, netDim*ones(1,reservoirNum), inputLengthVar*ones(1,inputVarNum));
for i = 1:reservoirNum
    for j =1:inputVarNum
        inWM0{i,j} = connectMat(i,j) * (2.0 * rand(netDim, inputLengthVar)- 1.0);
    end
end
inWM = cell2mat(inWM0);

% output weight matrix has weights for output units in rows
% includes weights for input-to-output connections

initialOutWM = zeros(outputLength, reservoirNum * netDim);
% initialOutWM = zeros(outputLength, reservoirNum * netDim + inputLength);

%output feedback weight matrix has weights in columns

ofbWM0 = zeros(reservoirNum * netDim, outputLength);
ofbWM0 = mat2cell(ofbWM0, netDim*ones(1,reservoirNum), ones(1,outputLength));

for i = 1:reservoirNum
    for j = 1:outputLength
        ofbWM0{i,j} = connectMat(i,inputVarNum+j) * (2.0 * rand(netDim, 1)- 1.0) ...
            * ofbSC(j);
    end
end
ofbWM = cell2mat(ofbWM0);

% ofbWM0 = (2.0 * rand(netDim, outputLength)- 1.0);
% ofbWM1 = (2.0 * rand(netDim, outputLength)- 1.0);
