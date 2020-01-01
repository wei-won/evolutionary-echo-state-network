% header infos for controller learning

%%%%%%% createEmptyFigs
%%%%%%% generateNetold
netDim = 40; connectivity = 0.1;
inputVarNum = 5; inputLengthVar = 15;
inputLength = inputVarNum * inputLengthVar; outputLength = 2;
reservoirNum = 5;
ensembleDim = netDim * reservoirNum;
interConnectivity = 0.01;

totalDim = reservoirNum * netDim + inputLength + outputLength;

neuronType = 'sigmoid'; % sigmoid, relu, tanh, linear, etc.
%%%%%%% generateTrainTestData
samplelength = 1200;
%%%%%%% learnAndTest
specRad = 0.8; ofbSC = [1,1]; noiselevel = 0.0000; 
linearOutputUnits = 0; linearNetwork = 0; WienerHopf = 0; 
initialRunlength = 100; sampleRunlength = 1000; freeRunlength = 0; plotRunlength = 100;
inputscaling = 0.8*ones(inputLength,1);inputshift = 0.5*ones(inputLength,1); % inputshift = zeros(inputLength,1);
teacherscaling = 0.8*ones(outputLength,1); teachershift = 0.5*ones(outputLength,1);% teachershift = zeros(outputLength,1);
%%%%%%% connectionCoding

% connectMat = reshape(gene,inputVarNum+outputLength,reservoirNum).';

%connectMat = ones(reservoirNum,inputVarNum+outputLength);
%gene = reshape(connectMat.',1,numel(connectMat));
