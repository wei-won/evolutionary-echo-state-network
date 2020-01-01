clear;
addpath('../');
% gene = [0,0,1,1,1,1,1,1,1,0,1,0,0,0,1,1,0,1,1,0,1,1,0,0,1,1,1,0,1,1,1,0,1,1,0];
nrmse = [];
avg_nrmse = [];

%% setup Hebb_with_decacy parameters

ruleOpt = 'HebbDecay';
initialRun = 100;
synapTrainOpt = 'offline'; % Can be 'online' or 'offline'
learnTarget = 'allWeights'; % Can choose from 'intWeights', 'allWeights', 'intinWeights'

seqT =50:50:900;
% seqlr = 0.0001:0.0001:0.002;
% seqlr = 0.00001:0.00001:0.0002;
seqlr = 0.00001:0.00001:0.0004;
% seqdr = 0:0.00002:0.00012;
seqdr = 0.00014:0.00002:0.0002;
LT = length(seqT);
Llr = length(seqlr);
Ldr = length(seqdr);
steps = LT * Llr * Ldr;

%% Test Begin

h = waitbar(0,'Please wait...');
step = 0;
for iT = 1:LT
    T = seqT(iT);
    for ilr = 1:Llr
        lr = seqlr(ilr);
        for idr = 1:Ldr
            dr = seqdr(idr);
            step = step + 1;
            run_individual;
            plasticity = true;
        
            switch(learnTarget)    
                case 'intWeights'
                    W = intWM'; % learn only internal weights
                case 'allWeights'
                    W = [intWM';inWM';ofbWM']; % learn input weights and internal weights and out
                case 'intinWeights'
                    W = [intWM';inWM']; % learn input weights and internal weights
                otherwise
                    error(['Unknown learning target' learnTarget]);
            end
      
            % creat mask 0/1 matrix
            WMmask = zeros(size(W));
            WMmask(find(W)) = 1;
        
    %         inmask = connectMat(:,1:inputVarNum);
    %         maskMat = cell(reservoirNum,inputVarNum);
    %         for mskindex = 1:reservoirNum*inputVarNum
    %             maskMat{mskindex} = ones(netDim,inputLengthVar)*inmask(mskindex);
    %         end
    %         maskMat=cell2mat(maskMat);
    % 
    %         Wkj = full(intWM);
    %         [row,col] = find(Wkj~=0);
    % 
    % 
    % 
    %         for i = 102:201
    %             crntState = stateCollectMat(i-100,1:netDim*reservoirNum)';
    %             prevState = stateCollectMat(i-101,1:netDim*reservoirNum)';
    %             input = sampleinput(:,i);
    %         %     input = stateCollectMat(i,netDim+1:netDim+inputLength)';
    %             for j = 1:netDim*reservoirNum
    %                 nW = Wkj(j,:)';
    %                 inW = inWM(j,:)';
    %                 nIndex = find(row==j);
    %                 sIndex = col(nIndex);
    %                 stateIn = prevState(sIndex);
    %                 nWint = nW(sIndex);
    %                 xj = [input; stateIn];
    %         %         xj = [input;prevState];
    %                 yk = crntState(j);
    %                 W = [inW;nWint];
    %         %         W = [inW;nW];
    %         %         dW = ep*yk*(xj-W*yk);
    %         %         lp.lr = 0.0001;
    %         %         lp.dr = 0.00001;
    %         %         dW = learnhd(W,xj,[],[],yk,[],[],[],[],[],lp,[])
    %                 dW = lr*yk*xj - dr*W;
    %                 Wkj(j,sIndex) = Wkj(j,sIndex)+dW(inputLength+1:inputLength+size(nWint,1))';
    %                 inWM(j,:) = (inWM(j,:) + dW(1:inputLength)').*maskMat(j,:);
    %             end
    %         end
    %         % for i = 100:1000
    %         %    a =  stateCollectMat(i,1:netDim)';   
    %         %      
    %         % for j = 1:size(row,1)
    %         % 
    %         % xj = a(row(j));
    %         % yk = a(col(j));
    %         % 
    %         % Wd = ep*yk*(xj-yk*Wkj(row(j),col(j)));
    %         % Wkj(row(j),col(j)) = Wkj(row(j),col(j)) + Wd;
    %         % end
    %         % end
    % 
    % 
    %         intWM = sparse(Wkj);
    % 
    %         learnAndTest;

%             learnAndTest_withHebbDecay;
            switch(synapTrainOpt)    
                case 'online' % online synaptic learning
                    learnAndTest_withHebbDecay;
                case 'offline' % offline synaptic learning
                    pretrainSynap;
                    learnAndTest;
                otherwise
                    error(['Unknown learning option' synapTrainOpt]);
            end
            
            nrmse=[nrmse;NRMSE];
            avg_nrmse = [avg_nrmse;avg_NRMSE];
            waitbar(step/steps,h,['Please wait...(' num2str(step) '/' num2str(steps) ')'])
        end
    end
end
close(h)

% [x,y]=meshgrid(seqlr,seqdr);
% z = reshape(avg_nrmse,Ldr,Llr);
% mesh(x,y,z);
% 
% [Cdr,Idr]=min(z);
% [Clr,Ilr]=min(Cdr);
% LR = seqlr(Ilr);
% DR = seqdr(Idr(Ilr));

%% reshape result mats
nrmseReshape = cell(LT,1);
avg_nrmseReshape = cell(LT,1);
% nrmseReshape = zeros(2*Llr,Ldr);
for iT = 1:LT
    
    nrmsePerT = nrmse((iT-1)*Llr*Ldr+1:iT*Llr*Ldr,:);
    avg_nrmsePerT = avg_nrmse((iT-1)*Llr*Ldr+1:iT*Llr*Ldr,:);
    nrmseReshape{iT} = zeros(2*Llr,Ldr);
    for i = 1:Llr
        nrmseReshape{iT}((i-1)*2+1,:) = nrmsePerT((i-1)*Ldr+1:i*Ldr,1)';
        nrmseReshape{iT}((i-1)*2+2,:) = nrmsePerT((i-1)*Ldr+1:i*Ldr,2)';
    end
    
    avg_nrmseReshape{iT} = reshape(avg_nrmsePerT,Ldr,Llr)';
end

%%
nrmseReshape = zeros(LT,2*Llr,Ldr);
avg_nrmseReshape = zeros(LT,Llr,Ldr);
for iT = 1:LT
    
    nrmsePerT = nrmse((iT-1)*Llr*Ldr+1:iT*Llr*Ldr,:);
    avg_nrmsePerT = avg_nrmse((iT-1)*Llr*Ldr+1:iT*Llr*Ldr,:);
    
    for i = 1:Llr
        nrmseReshape(iT,(i-1)*2+1,:) = nrmsePerT((i-1)*Ldr+1:i*Ldr,1)';
        nrmseReshape(iT,(i-1)*2+2,:) = nrmsePerT((i-1)*Ldr+1:i*Ldr,2)';
    end
    
    avg_nrmseReshape(iT,:,:) = reshape(avg_nrmsePerT,Ldr,Llr)';
end

a = cell(Ldr,2);
for i = 1:Ldr
   a{i,1} = avg_nrmseReshape(:,:,i)'; 
   a{i,2} = nrmseReshape(:,:,i)';
end
%% save results

% save('HebbWithDecay_optTest_results_gene40(2)WMs3.mat','avg_nrmse','nrmse','avg_nrmseReshape','nrmseReshape','gene','initialRunlength','seqlr','seqdr','seqT');

%%
% [x,y]=meshgrid(seqlr,seqdr);
% nrmse_high = nrmse(:,1);
% nrmse_low = nrmse(:,2);
% z_high = reshape(nrmse_high,20,20);
% z_low = reshape(nrmse_low,20,20);
% % high = ones(20,20)*0.59932;
% % low = ones(20,20)*0.62483;
% mesh(x,y,z_high);
% hold on;
% mesh(x,y,z_low);
% % mesh(x,y,high);
% % mesh(x,y,low);
% hold off;
% % k_high = find(z_high<0.59932);
% % k_low = find(z_low<0.62483);
% % k = intersect(k_high,k_low);