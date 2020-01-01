% cell = mat2cell(intWM,[100,100,100],[100,100,100]);
% for i = 1:reservoirNum
%     for j = 1:reservoirNum
%         if i~=j
%             cell(i,j) = sprand(netDim, netDim, 0.01);
%             cell(i,j) = spfun(@minusPoint5,cell(i,j));
%             opts.disp = 0;
%             SR = abs(eigs(cell(i,j),1, 'lm', opts));
%             cell(i,j) = cell(i,j)/SR;
%         end
%     end
% end
% intWM = cell2mat(cell);

intWM3 = sprand(netDim, netDim, 0.01);
intWM3 = spfun(@minusPoint5,intWM3);
opts.disp = 0;
SR3 = abs(eigs(intWM3,1, 'lm', opts));
intWM3 = intWM3/SR3;
intWM3 = intWM3 * specRad;

intWM4 = sprand(netDim, netDim, 0.01);
intWM4 = spfun(@minusPoint5,intWM4);
opts.disp = 0;
SR4 = abs(eigs(intWM4,1, 'lm', opts));
intWM4 = intWM4/SR4;
intWM4 = intWM4 * specRad;

% intWM5 = sprand(netDim, netDim, 0.01);
% intWM5 = spfun(@minusPoint5,intWM5);
% opts.disp = 0;
% SR5 = abs(eigs(intWM5,1, 'lm', opts));
% intWM5 = intWM5/SR5;
% intWM5 = intWM5 * specRad;
% 
% intWM6 = sprand(netDim, netDim, 0.01);
% intWM6 = spfun(@minusPoint5,intWM6);
% opts.disp = 0;
% SR6 = abs(eigs(intWM6,1, 'lm', opts));
% intWM6 = intWM6/SR6;
% intWM6 = intWM6 * specRad;
% 
% intWM7 = sprand(netDim, netDim, 0.01);
% intWM7 = spfun(@minusPoint5,intWM7);
% opts.disp = 0;
% SR7 = abs(eigs(intWM7,1, 'lm', opts));
% intWM7 = intWM7/SR7;
% intWM7 = intWM7 * specRad;
% 
% intWM8 = sprand(netDim, netDim, 0.01);
% intWM8 = spfun(@minusPoint5,intWM8);
% opts.disp = 0;
% SR8 = abs(eigs(intWM8,1, 'lm', opts));
% intWM8 = intWM8/SR8;
% intWM8 = intWM8 * specRad;

intWM = [intWM0 intWM3; intWM4 intWM1];
% intWM = [intWM0 intWM3 intWM4;intWM5 intWM1 intWM6;intWM7 intWM8 intWM2];

ofbWM0 = ofbWM0 * diag(ofbSC);
ofbWM1 = ofbWM1 * diag(ofbSC);
ofbWM = [ofbWM0',ofbWM1']';
outWM = initialOutWM;
stateCollectMat = zeros(sampleRunlength, reservoirNum * netDim + inputLength);
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
        totalstate(reservoirNum*netDim+1:reservoirNum*netDim+inputLength) = in; 
    end
    %update totalstate except at input positions  
    if linearNetwork
        if noiselevel == 0 | noiselevel == 0.0 | i > initialRunlength + sampleRunlength
            internalState = ([intWM, inWM, ofbWM]*totalstate);  
        else
            internalState = ([intWM, inWM, ofbWM]*totalstate + ...
                noiselevel * 2.0 * (rand(reservoirNum*netDim,1)-0.5));
            %             internalState = ([intWM, inWM, ofbWM]*totalstate + ...
            %              noiselevel * 2.0 * (randn(netDim,1)));
        end
    else
        if noiselevel == 0 | noiselevel == 0.0 | i > initialRunlength + sampleRunlength
            internalState = f([intWM, inWM, ofbWM]*totalstate);  
        else
            internalState = f([intWM, inWM, ofbWM]*totalstate + ...
                noiselevel * 2.0 * (rand(reservoirNum*netDim,1)-0.5));
            %             internalState = f([intWM, inWM, ofbWM]*totalstate + ...
            %              noiselevel * 2.0 * (randn(netDim,1)));
        end
    end
    
    if linearOutputUnits
        netOut = outWM *[internalState;in];
    else
        netOut = f(outWM *[internalState;in]);
    end
    totalstate = [internalState;in;netOut];    
    
    %collect states and results for later use in learning procedure
    if (i > initialRunlength) & (i <= initialRunlength + sampleRunlength) 
        collectIndex = i - initialRunlength;
        stateCollectMat(collectIndex,:) = [internalState' in']; %fill a row
        if linearOutputUnits
            teachCollectMat(collectIndex,:) = teach';
        else
            teachCollectMat(collectIndex,:) = (fInverse(teach))'; %fill a row
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
    if i == initialRunlength + sampleRunlength
        if WienerHopf
            covMat = stateCollectMat' * stateCollectMat / sampleRunlength;
            pVec = stateCollectMat' * teachCollectMat / sampleRunlength;
            outWM = (inv(covMat) * pVec)';
        else
            outWM = (pinv(stateCollectMat) * teachCollectMat)'; 
        end
        %compute mean square errors on the training data using the newly
        %computed weights
        for j = 1:outputLength
            if linearOutputUnits
                msetrain(1,j) = sum((teachCollectMat(:,j) - ...
                    (stateCollectMat * outWM(j,:)')).^2);
            else
                msetrain(1,j) = sum((f(teachCollectMat(:,j)) - ...
                    f(stateCollectMat * outWM(j,:)')).^2);
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
disp(sprintf('train NRMSE = %s', num2str(sqrt(msetrain ./ teacherVariance))));
disp(sprintf('test NRMSE = %s', num2str(sqrt(msetestresult ./ teacherVariance))));
disp(sprintf('average output weights = %s', num2str(mean(abs(outWM')))));


% input plot
figure(fig2);
subplot(inputLength,1,1);
plot(inputPL(1,:));
title('final effective inputs','FontSize',8);
for k = 2:inputLength
    subplot(inputLength,1,k);
    plot(inputPL(k,:));
end


% plot first 4 (maximally) of internal states listed in plotStates
if length(plotStates) > 0 
    figure(fig3);
    subplot(2,2,1);
    plot(statePL(1,:));
    title('internal states','FontSize',8);
    for k = 2:length(plotStates)
        subplot(2,2,k);
        plot(statePL(k,:));
    end    
end

% plot weights
 
    figure(fig4);
    subplot(outputLength,1,1);   
    plot(outWM(1,:));
    title('output weights','FontSize',8);
    for k = 2:outputLength
        subplot(outputLength,1,k);
        plot(outWM(k,:));
    end  


% plot overlay of network output and teacher  
figure(fig5);
subplot(outputLength,1,1);   
plot(1:plotRunlength,teacherPL(1,:), 1:plotRunlength,netOutPL(1,:));
title('teacher (blue) vs. net output (green)','FontSize',8);
for k = 2:outputLength
    subplot(outputLength,1,k);
    plot(1:plotRunlength,teacherPL(k,:), 1:plotRunlength,netOutPL(k,:));
end  
