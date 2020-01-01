clear;
addpath('../');
gene = [0,0,1,1,1,1,1,1,1,0,1,0,0,0,1,1,0,1,1,0,1,1,0,0,1,1,1,0,1,1,1,0,1,1,0];
nrmse = [];
avg_nrmse = [];

for lr = 0.00001:0.00005:0.001;
   run_individual;
   dreDim = reservoirNum * netDim;
   topNum = dreDim / 10;
   Wkj = full(intWM);
   for out_i = 1:outputLength
       [outW_rank(out_i,:),outIndex_rank(out_i,:)]=sort(outWM(out_i,1:dreDim),'descend');
       outW_top(out_i,:) = outW_rank(out_i,1:topNum);
       outIndex_top(out_i,:) = outIndex_rank(out_i,1:topNum);
       for i = 1:2
           for j = 1:topNum
               PNR_i = outIndex_top(out_i,j);
               Wkj(PNR_i,:) = (1+lr) * Wkj(PNR_i,:);
               Wkj([1:PNR_i-1,PNR_i+1:end],PNR_i) = (1+lr) * Wkj([1:PNR_i-1,PNR_i+1:end],PNR_i);
%                ofbWM(PNR_i,out_i) = (1+lr) * ofbWM(PNR_i,out_i);
%                outWM(out_i,PNR_i) = (1+lr) * outWM(out_i,PNR_i);
           end
       end
   end
   intWM = sparse(Wkj);

   learnAndTest;
%    continueRun;
   nrmse=[nrmse;NRMSE];
   avg_nrmse = [avg_nrmse;avg_NRMSE];
end

lr = 0.00001:0.00005:0.001;
figure;
plot(lr,avg_nrmse);


%%
lr = 0.00001:0.00005:0.001;

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