
%%%%%%%%%%%%%% IMPORTANT %%%%%%%%%%%%%%%%%%%
% learning performance critically depends on spectral radius, and the
% input/output shifts and scalings, and outputFeedbackScaling
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% set spectral radius of reservoir weight matrix and scaling of output
% feedback weights. The latter is column vector
% specRad = 0.8; ofbSC = [1;1];

% noislevel: noise added to reservoir update during learning. Important for
% networks that have to actively generate dynamic patters (for instance,
% periodic signals, chaotic attractors), that is, networks where output
% feedback weights are present. In such cases, adding noise increases
% stability and decreases precision.
% noiselevel = 0.000;
% linearOutputUnits = 0; % 1 = use linear output units, 0 = sigmoid output units
% linearNetwork = 0; % 1 = use liner units in DR, 0 = use tanh units

% 1 = compute linear regression directly by solving Wiener Hopf equation
% with inverting covariance matrix; 0 = compute linear regression via
% pseudoinverse. 1 is faster and more space-economical, but less accurate. 
% WienerHopf = 1; 
% initialRunlength: initial update cycles where network is driven by
% teacher data; internal signals obtained here are discarded before
% learning (= washout of initial transients)
% initialRunlength = 100;
% number of update steps used for computing output weights
% sampleRunlength = 1000;
% freeRunlength is number of steps the trained network is left 
% running freely before plotting and testing starts. Mostly set to 0, 
% sometimes useful if trained network may be unstable and one wants to 
% check whether it stably runs for a long time
% freeRunlength = 0;
% plotRunlength is the length of the testing sequence. Data from this 
% sequence are used for generating various result plots and for computing
% test performance statistics
% plotRunlength = 100;

plotStates = [1 2 3 4]; % plot internal network states of ...
% units indicated in row vector; maximally 4 are plotted. Data from
% plotRunlength are plotted

% inputscaling is column vector of dimension of input
% inputscaling = [0.1;0.5];
% % inputshift is column vector of dimension of input
% inputshift = [0;1];
% % teacherscaling is column vector of dimension of output
% teacherscaling = [0.3;0.3];
% % teacherscaling is column vector of dimension of output
% teachershift = [-.2;-0.2];

% disp('Learning and testing.........');
% disp(sprintf('netDim = %g   specRad =  %g   noise = %g    ',...
%     netDim, specRad, noiselevel));
% disp(sprintf('output feedback Scaling = %s', num2str(ofbSC')));
% disp(sprintf('inSC = %s', num2str(inputscaling')));
% disp(sprintf('inShift = %s', num2str(inputshift')));
% disp(sprintf('teacherSC = %s', num2str(teacherscaling')));
% disp(sprintf('teachershift = %s', num2str(teachershift')));
% disp(sprintf('WienerHopf = %g   linearOuts = %g   linearNet = %g',...
%     WienerHopf,linearOutputUnits, linearNetwork));
% disp(sprintf('initRL = %g  sampleRL = %g  plotRL = %g  ',...
%     initialRunlength, sampleRunlength, plotRunlength));

%% learn
totalstate =  zeros(totalDim,1);
for i = 1:reservoirNum;
    eval(['internalState',num2str(i),'= totalstate((i-1)*netDim+1:i*netDim);']);
end
% internalState0 = totalstate(1:netDim);
% internalState1 = totalstate(netDim + 1:2 * netDim);

% intWM0 = intWM0 * specRad;
% intWM1 = intWM1 * specRad;
% intWM = blkdiag(intWM0,intWM1);

% ofbWM0 = ofbWM0 * diag(ofbSC);
% ofbWM1 = ofbWM1 * diag(ofbSC);
% ofbWM = [ofbWM0',ofbWM1']';

outWM = initialOutWM;
stateCollectMat = zeros(sampleRunlength, reservoirNum * netDim + inputLength);
stateSeqFull = zeros(initialRunlength + sampleRunlength + freeRunlength + plotRunlength,ensembleDim+inputLength);
outCollectMat = zeros(sampleRunlength, outputLength);

teachCollectMat = zeros(sampleRunlength, outputLength);
teacherPL = zeros(outputLength, plotRunlength);
netOutPL = zeros(outputLength, plotRunlength);
if inputLength > 0
    inputPL = zeros(inputLength, plotRunlength);
end
statePL = zeros(length(plotStates),plotRunlength);
plotindex = 0;
msetest = zeros(1,outputLength); 
msetrain = zeros(1,outputLength); 


for i = 1:initialRunlength + sampleRunlength + freeRunlength + plotRunlength 
    
    if inputLength > 0
        in = [diag(inputscaling) * sampleinput(:,i) + inputshift];  % in is column vector  
    else in = [];
    end
    teach = [diag(teacherscaling) * sampleout(:,i) + teachershift];    % teach is column vector     
    
    %write input into totalstate
    if inputLength > 0
        totalstate(reservoirNum * netDim + 1:reservoirNum * netDim + inputLength) = in; 
    end
    
    % Hebbian learning if applicable
    if plasticity & (i > initialRunlength+11) & (i <= initialRunlength + T +10)
%         prevY = internalState;  % stateCollectMat(i-101,1:netDim*reservoirNum)';
%         prevX = stateSeqFull(i-2,:)';

        prevY = stateCollectMat(i-initialRun-1,1:ensembleDim)';
        
        switch(learnTarget)
            case 'intWeights'
                prevX = stateCollectMat(i-initialRun-2,1:ensembleDim)'; % learn only internal weights
            case 'allWeights'
                % learn input weights and internal weights and out
                prevX = [stateCollectMat(i-initialRun-2,1:ensembleDim+inputLength),outCollectMat(i-initialRun-2,:)]';
            case 'intinWeights'
                % learn input weights and internal weights
                prevX = stateCollectMat(i-initialRun-2,1:ensembleDim+inputLength)';
            otherwise
                error(['Unknown learning target' learnTarget]);
        end
        
        % Hebbian learning rule
        deltaW = lr*prevY*prevX';
        
        W = W + deltaW.*WMmask;
        
        switch(learnTarget)
            case 'intWeights'
                intWM = W'; % learn only internal weights
            case 'allWeights'
                % learn input weights and internal weights and out
                intWM = W(1:ensembleDim,:)';
                inWM = W(ensembleDim+1:ensembleDim+inputLength,:)';
                ofbWM = W(ensembleDim+inputLength+1:end,:)';
            case 'intinWeights'
                % learn input weights and internal weights
                intWM = W(1:ensembleDim,:)';
                inWM = W(ensembleDim+1:ensembleDim+inputLength,:)';
            otherwise
                error(['Unknown learning target' learnTarget]);
        end
        
    end
    
    %update totalstate except at input positions  
    if linearNetwork
        if noiselevel == 0 | noiselevel == 0.0 | i > initialRunlength + sampleRunlength
            internalState = ([intWM, inWM, ofbWM]*totalstate);  
        else
%             internalState = ([intWM, inWM, ofbWM]*totalstate + ...
%                 noiselevel * 2.0 * (rand(reservoirNum*netDim,1)-0.5));
                        internalState = ([intWM, inWM, ofbWM]*totalstate + ...
                         noiselevel * 2.0 * (randn(netDim,1)));
        end
    else
        if noiselevel == 0 | noiselevel == 0.0 | i > initialRunlength + sampleRunlength
            internalState = f([intWM, inWM, ofbWM]*totalstate,neuronType);  
        else
%             internalState = f([intWM, inWM, ofbWM]*totalstate + ...
%                 noiselevel * 2.0 * (rand(reservoirNum*netDim,1)-0.5),neuronType);
                        internalState = f([intWM, inWM, ofbWM]*totalstate + ...
                         noiselevel * 2.0 * (randn(netDim,1)),neuronType);
        end
    end
    
    if linearOutputUnits
        netOut = outWM *[internalState;in];
%         netOut = outWM *[internalState];        
    else
        netOut = f(outWM *[internalState;in],neuronType);
%         netOut = f(outWM *[internalState],neuronType);
    end
    totalstate = [internalState;in;netOut];    
    
    % collect full sequence of neuron states for learning rule
    stateSeqFull(i,:) = [internalState' in'];
    
    %collect states and results for later use in learning procedure
    if (i > initialRunlength) & (i <= initialRunlength + sampleRunlength) 
        collectIndex = i - initialRunlength;
        stateCollectMat(collectIndex,:) = [internalState' in']; %fill a row
        outCollectMat(collectIndex,:) = netOut';
        if linearOutputUnits
            teachCollectMat(collectIndex,:) = teach';
        else
            teachCollectMat(collectIndex,:) = (fInverse(teach,neuronType))'; %fill a row
        end
    end
    %force teacher output 
    if i <= initialRunlength + sampleRunlength
        totalstate(reservoirNum*netDim+inputLength+1:reservoirNum*netDim+inputLength+outputLength) = teach; 
    end
    %update msetest
    if i > initialRunlength + sampleRunlength + freeRunlength
        for j = 1:outputLength
            msetest(1,j) = msetest(1,j) + (teach(j,1)- netOut(j,1))^2;
        end
    end
    %compute new model
    outWM0 = outWM;
    
%     outWM0 = mat2cell(outWM,ones(1,outputLength),netDim*ones(1,reservoirNum));    
%     outWM0 = mat2cell(outWM,ones(1,outputLength),[netDim*ones(1,reservoirNum),inputLength]);
    
    if i == initialRunlength + sampleRunlength
        if WienerHopf
            covMat = stateCollectMat' * stateCollectMat / sampleRunlength;
            pVec = stateCollectMat' * teachCollectMat / sampleRunlength;
            outWM = (inv(covMat) * pVec)';
        else
            for m = 1:outputLength
%                 matIndex = [];
                outReservoirRange = [];
                for n = 1:reservoirNum
                    if connectMat(n,m+inputVarNum) == 1
%                         matIndex = [matIndex,n];
                        outReservoirRange = [outReservoirRange,netDim*(n-1)+1:netDim*n];
                    end
                end
                outWM0(m,outReservoirRange) = (pinv(stateCollectMat(:,outReservoirRange)) * teachCollectMat(:,m))';
%                 for k = 1:size(matIndex,2)
%                     
%                 end

%                 outInputRange = reservoirNum*netDim+1:reservoirNum*netDim+inputLength;
%                 outWM0{m,reservoirNum+1} = (pinv(stateCollectMat(:,outInputRange)) * teachCollectMat(:,m))';
            end
            outWM = outWM0;
%             outWM = cell2mat(outWM0);
            
% % Update outWM by each cell
% %             outWM = (pinv(stateCollectMat) * teachCollectMat)';
%             for m = 1:outputLength
%                 for n = 1:reservoirNum
%                     outReservoirRange = netDim*(n-1)+1:netDim*n;
%                     outWM0{m,n} = connectMat(n,m) * ...
%                         (pinv(stateCollectMat(:,outReservoirRange)) * teachCollectMat(:,m))';
%                 end
% %                 outInputRange = reservoirNum*netDim+1:reservoirNum*netDim+inputLength;
% %                 outWM0{m,reservoirNum+1} = (pinv(stateCollectMat(:,outInputRange)) * teachCollectMat(:,m))';
%             end
%             outWM = cell2mat(outWM0);

        end
        %compute mean square errors on the training data using the newly
        %computed weights
        for j = 1:outputLength
            if linearOutputUnits
                msetrain(1,j) = sum((teachCollectMat(:,j) - ...
                    (stateCollectMat * outWM(j,:)')).^2);
%                 msetrain(1,j) = sum((teachCollectMat(:,j) - ...
%                     (stateCollectMat(1:sampleRunlength, 1:reservoirNum * netDim) * outWM(j,:)')).^2);
            else
                msetrain(1,j) = sum((f(teachCollectMat(:,j),neuronType) - ...
                    f(stateCollectMat * outWM(j,:)',neuronType)).^2);
%                 msetrain(1,j) = sum((f(teachCollectMat(:,j),neuronType) - ...
%                     f(stateCollectMat(1:sampleRunlength, 1:reservoirNum * netDim) * outWM(j,:)',neuronType)).^2);
            end
            msetrain(1,j) = msetrain(1,j) / sampleRunlength;
        end
    end    
    %write plotting data into various plotfiles
    if i > initialRunlength + sampleRunlength + freeRunlength 
        plotindex = plotindex + 1;
        if inputLength > 0
            inputPL(:,plotindex) = in;
        end
        teacherPL(:,plotindex) = teach; 
        netOutPL(:,plotindex) = netOut;
        for j = 1:length(plotStates)
            statePL(j,plotindex) = totalstate(plotStates(j),1);
        end
    end
end
%end of the great do-loop




% print diagnostics in terms of normalized RMSE (root mean square error)

msetestresult = msetest / plotRunlength;
teacherVariance = var(teacherPL');
NRMSE = sqrt(msetestresult ./ teacherVariance);

avg_NRMSE = mean(NRMSE);

%% Display result

% disp(sprintf('train NRMSE = %s', num2str(sqrt(msetrain ./ teacherVariance))));
% disp(sprintf('test NRMSE = %s', num2str(sqrt(msetestresult ./ teacherVariance))));
% disp(sprintf('average output weights = %s', num2str(mean(abs(outWM')))));
% 
% 
% % input plot
% figure(fig2);
% subplot(inputLength,1,1);
% plot(inputPL(1,:));
% title('final effective inputs','FontSize',8);
% for k = 2:inputLength
%     subplot(inputLength,1,k);
%     plot(inputPL(k,:));
% end
% 
% 
% % plot first 4 (maximally) of internal states listed in plotStates
% if length(plotStates) > 0 
%     figure(fig3);
%     subplot(2,2,1);
%     plot(statePL(1,:));
%     title('internal states','FontSize',8);
%     for k = 2:length(plotStates)
%         subplot(2,2,k);
%         plot(statePL(k,:));
%     end    
% end
% 
% % plot weights
%  
%     figure(fig4);
%     subplot(outputLength,1,1);   
%     plot(outWM(1,:));
%     title('output weights','FontSize',8);
%     for k = 2:outputLength
%         subplot(outputLength,1,k);
%         plot(outWM(k,:));
%     end  
% 
% 
% % plot overlay of network output and teacher  
% figure(fig5);
% subplot(outputLength,1,1);   
% plot(1:plotRunlength,teacherPL(1,:), 1:plotRunlength,netOutPL(1,:));
% title('teacher (blue) vs. net output (red)','FontSize',8);
% for k = 2:outputLength
%     subplot(outputLength,1,k);
%     plot(1:plotRunlength,teacherPL(k,:), 1:plotRunlength,netOutPL(k,:));
% end