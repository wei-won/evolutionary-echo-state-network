%% pre-train synaptic weights for offline synaptic plasticity learning

totalstate =  zeros(totalDim,1);

outWM = initialOutWM;
stateCollectMat = zeros(sampleRunlength, reservoirNum * netDim + inputLength);
stateSeqFull = zeros(initialRunlength + sampleRunlength + freeRunlength + plotRunlength,ensembleDim+inputLength);
outCollectMat = zeros(sampleRunlength, outputLength);
teachCollectMat = zeros(sampleRunlength, outputLength);


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
    
    % AntiOja learning if applicable
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
        
        switch(ruleOpt)
            case 'Oja'
                prevYsq = prevY' .* prevY';
                deltaW = ep * (prevX * prevY' - W .* repmat(prevYsq,size(W,1),1));
                W = W + deltaW.*WMmask;
            case 'BCM'
                Theta_in = Theta(:,i-initialRunlength-11);
                % Theta = <y^2>
                deltaTheta = 1/tau * ( prevY.^2 - Theta_in );
                % BCM rule
                deltaW = eta * prevX * (prevY .* ( prevY - Theta_in))';
                Theta(:,i-initialRunlength-10) = Theta_in + deltaTheta;
                W = (W + deltaW).*WMmask;
            case 'Hebb'
                deltaW = lr*prevX*prevY';
                W = W + deltaW.*WMmask;
            case 'HebbDecay'
                deltaW = lr*prevX*prevY' - dr*W;
                W = W + deltaW.*WMmask;
            otherwise
                error(['Unknown learning rule' ruleOpt]);
        end
        
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
%         if linearOutputUnits
%             teachCollectMat(collectIndex,:) = teach';
%         else
%             teachCollectMat(collectIndex,:) = (fInverse(teach,neuronType))'; %fill a row
%         end
    end
    %force teacher output 
    if i <= initialRunlength + sampleRunlength
        totalstate(reservoirNum*netDim+inputLength+1:reservoirNum*netDim+inputLength+outputLength) = teach; 
    end
    
end