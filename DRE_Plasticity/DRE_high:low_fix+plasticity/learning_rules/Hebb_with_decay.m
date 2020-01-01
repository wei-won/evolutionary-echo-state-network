inmask = connectMat(:,1:inputVarNum);
maskMat = cell(reservoirNum,inputVarNum);
for mskindex = 1:reservoirNum*inputVarNum
    maskMat{mskindex} = ones(netDim,inputLengthVar)*inmask(mskindex);
end
maskMat=cell2mat(maskMat);

Wkj = full(intWM);
[row,col] = find(Wkj~=0);
ep = 0.00001;

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
%         dW = ep*yk*(xj-W*yk);
        lp.lr = 0.0001;
        lp.dr = 0.00001;
%         dW = learnhd(W,xj,[],[],yk,[],[],[],[],[],lp,[])
        dW = lp.lr*yk*xj - lp.dr*W;
        Wkj(j,sIndex) = Wkj(j,sIndex)+dW(inputLength+1:inputLength+size(nWint,1))';
        inWM(j,:) = (inWM(j,:) + dW(1:inputLength)').*maskMat(j,:);
    end
end
% for i = 100:1000
%    a =  stateCollectMat(i,1:netDim)';   
%      
% for j = 1:size(row,1)
% 
% xj = a(row(j));
% yk = a(col(j));
% 
% Wd = ep*yk*(xj-yk*Wkj(row(j),col(j)));
% Wkj(row(j),col(j)) = Wkj(row(j),col(j)) + Wd;
% end
% end


intWM = sparse(Wkj);

learnAndTest