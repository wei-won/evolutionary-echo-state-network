clear;
gene = [0,0,1,1,1,1,1,1,1,0,1,0,0,0,1,1,0,1,1,0,1,1,0,0,1,1,1,0,1,1,1,0,1,1,0];
nrmse = [];
avg_nrmse = [];
% for lr = 0.00001:0.00005:0.001
for lr = 0.00005:0.00005:0.001
    run_individual;
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
%         input = stateCollectMat(i,netDim+1:netDim+inputLength)';
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
    %         lp.lr = 0.0001;
    %         lp.dr = 0.00001;
    %         dW = learnhd(W,xj,[],[],yk,[],[],[],[],[],lp,[])
            dW = lr*yk*xj;
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

    learnAndTest;
    nrmse=[nrmse;NRMSE];
    avg_nrmse = [avg_nrmse;avg_NRMSE];
end

% lr = 0.00001:0.00005:0.001;
lr = 0.00005:0.00005:0.001;
figure;
plot(lr,avg_nrmse);

% [Cdr,Idr]=min(z);
% [Clr,Ilr]=min(Cdr);
% LR = lr(Ilr);


%%
% lr = 0.00001:0.00005:0.001;
lr = 0.00005:0.00005:0.001;

nrmse_high = nrmse(:,1);
nrmse_low = nrmse(:,2);

high = ones(1,20)*0.59643;
low = ones(1,20)*0.62806;
figure;
plot(lr,nrmse_high);
hold on;
plot(lr,nrmse_low);
plot(lr,high,'black');
plot(lr,low,'black');
hold off;
% k_high = find(z_high<0.59643);
% k_low = find(z_low<0.62806);
% k = intersect(k_high,k_low);