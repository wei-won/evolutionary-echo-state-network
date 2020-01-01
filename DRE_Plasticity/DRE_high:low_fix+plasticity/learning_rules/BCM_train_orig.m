T = 100;
tau = 100;
eta = 0.1;
Theta = zeros(100,T);
Theta(:,1) = 0.01;

for i = 102:201
    crntState = stateCollectMat(i-100,1:netDim*reservoirNum)';
    prevState = stateCollectMat(i-101,1:netDim*reservoirNum)';
    input = sampleinput(:,i);
%     input = stateCollectMat(i,netDim+1:netDim+inputLength)';
    for j = 1:netDim*reservoirNum
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
        dW = ep*yk*(xj-W*yk);
        Wkj(j,sIndex) = Wkj(j,sIndex)+dW(inputLength+1:inputLength+size(nWint,1))';
        inWM(j,:) = (inWM(j,:) + dW(1:inputLength)').*maskMat(j,:);
    end
end