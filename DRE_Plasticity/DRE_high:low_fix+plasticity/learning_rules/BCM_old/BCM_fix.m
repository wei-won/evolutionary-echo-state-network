inmask = connectMat(:,1:inputVarNum);
maskMat = cell(reservoirNum,inputVarNum);
for mskindex = 1:reservoirNum*inputVarNum
    maskMat{mskindex} = ones(netDim,inputLengthVar)*inmask(mskindex);
end
maskMat=cell2mat(maskMat);

Wkj = full(intWM);
[row,col] = find(Wkj~=0);



for i = 102:201
    crntState = stateCollectMat(i-100,1:netDim*reservoirNum)';
    prevState = stateCollectMat(i-101,1:netDim*reservoirNum)';
    input = sampleinput(:,i);
    theta = sum(1/(netDim*reservoirNum)*crntState.^2);
    
    for j = 1:netDim*reservoirNum
        
%         postSynAct = stateCollectMat(1:i-101,j);
%         theta = sum(1/size(postSynAct,1)*postSynAct.^2);
        
        nW = Wkj(j,:)';
        inW = inWM(j,:)';
        nIndex = find(row==j);
        sIndex = col(nIndex);
        stateIn = prevState(sIndex);
        nWint = nW(sIndex);
        xj = [input; stateIn];
%         xj = [input;prevState];
        yk = crntState(j);
        W = [inW;nWint];
%         W = [inW;nW];
        dW = yk*(yk-theta)*xj/theta;
        Wkj(j,sIndex) = Wkj(j,sIndex)+dW(inputLength+1:inputLength+size(nWint,1))';
        inWM(j,:) = (inWM(j,:) + dW(1:inputLength)').*maskMat(j,:);
        
    end
end


intWM = sparse(Wkj);



% normc(intWM);


