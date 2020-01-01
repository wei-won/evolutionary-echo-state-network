

totalstate =  zeros(totalDim,1);    
internalState = totalstate(1:netDim);
intWM = intWM0 * specRad;
ofbWM = ofbWM0 * diag(ofbSC);
outWM = initialOutWM;
stateCollectMat = zeros(sampleRunlength, netDim + inputLength);
teachCollectMat = zeros(sampleRunlength, outputLength);
teacherPL = zeros(outputLength, plotRunlength);
netOutPL = zeros(outputLength, plotRunlength);
if inputLength > 0
    inputPL = zeros(inputLength, plotRunlength);
end

Wkj = full(intWM);
[row,col] = find(Wkj~=0);
ep = 0.00001;



for i = 1:100
    
    if inputLength > 0
        in = [diag(inputscaling) * sampleinput(:,i) + inputshift];  % in is column vector  
    else in = [];
    end
    teach = [diag(teacherscaling) * sampleout(:,i) + teachershift];    % teach is column vector     
    
    %write input into totalstate
    if inputLength > 0
        totalstate(netDim+1:netDim+inputLength) = in; 
    end
    %update totalstate except at input positions  
    if linearNetwork
        if noiselevel == 0 | noiselevel == 0.0 | i > initialRunlength + sampleRunlength
            internalState = ([intWM, inWM, ofbWM]*totalstate);  
        else
            internalState = ([intWM, inWM, ofbWM]*totalstate + ...
                noiselevel * 2.0 * (rand(netDim,1)-0.5));
            %             internalState = ([intWM, inWM, ofbWM]*totalstate + ...
            %              noiselevel * 2.0 * (randn(netDim,1)));
        end
    else
        if noiselevel == 0 | noiselevel == 0.0 | i > initialRunlength + sampleRunlength
            internalState = f([intWM, inWM, ofbWM]*totalstate);  
        else
            internalState = f([intWM, inWM, ofbWM]*totalstate + ...
                noiselevel * 2.0 * (rand(netDim,1)-0.5));
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
    
end
%end of the great do-loop
 post = internalState;


for i = 101:201
 pre = post;
     if inputLength > 0
        in = [diag(inputscaling) * sampleinput(:,i) + inputshift];  % in is column vector  
    else in = [];
    end
    teach = [diag(teacherscaling) * sampleout(:,i) + teachershift];    % teach is column vector     
    
    %write input into totalstate
    if inputLength > 0
        totalstate(netDim+1:netDim+inputLength) = in; 
    end
    %update totalstate except at input positions  
    if linearNetwork
        if noiselevel == 0 | noiselevel == 0.0 | i > initialRunlength + sampleRunlength
            internalState = ([intWM, inWM, ofbWM]*totalstate);  
        else
            internalState = ([intWM, inWM, ofbWM]*totalstate + ...
                noiselevel * 2.0 * (rand(netDim,1)-0.5));
            %             internalState = ([intWM, inWM, ofbWM]*totalstate + ...
            %              noiselevel * 2.0 * (randn(netDim,1)));
        end
    else
        if noiselevel == 0 | noiselevel == 0.0 | i > initialRunlength + sampleRunlength
            internalState = f([intWM, inWM, ofbWM]*totalstate);  
        else
            internalState = f([intWM, inWM, ofbWM]*totalstate + ...
                noiselevel * 2.0 * (rand(netDim,1)-0.5));
            %             internalState = f([intWM, inWM, ofbWM]*totalstate + ...
            %              noiselevel * 2.0 * (randn(netDim,1)));
        end
    end
    
    
    post = internalState(1:netDim,1);
    
     
for j = 1:size(row,1)

xj = pre(row(j));
yk = pre(col(j));

Wd = ep*yk*(xj-yk*Wkj(row(j),col(j)));
Wkj(row(j),col(j)) = Wkj(row(j),col(j)) + Wd;

end 
    intWM = sparse(Wkj);
    
    
    
    
    
    
    
    
end


intWM0 = sparse(Wkj)/specRad;
learnAndTest
