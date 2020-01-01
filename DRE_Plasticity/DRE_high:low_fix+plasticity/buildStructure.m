
% Import data from files
% load('intWM.mat');
% load('inWM.mat');
% load('ofbWM.mat');


% input weight matrix has weight vectors per input unit in colums

inWM0 = mat2cell(inWM, netDim*ones(1,reservoirNum), inputLengthVar*ones(1,inputVarNum));
for i = 1:reservoirNum
    for j =1:inputVarNum
        inWM0{i,j} = connectMat(i,j) * inWM0{i,j};
    end
end
inWM = cell2mat(inWM0);


% output weight matrix has weights for output units in rows
% includes weights for input-to-output connections

initialOutWM = zeros(outputLength, reservoirNum * netDim + inputLength);


%output feedback weight matrix has weights in columns

ofbWM0 = mat2cell(ofbWM0, netDim*ones(1,reservoirNum), ones(1,outputLength));

for i = 1:reservoirNum
    for j = 1:outputLength
        ofbWM0{i,j} = connectMat(i,inputVarNum+j) * ofbWM0{i,j} ...
            * ofbSC(j);
    end
end
ofbWM = cell2mat(ofbWM0);