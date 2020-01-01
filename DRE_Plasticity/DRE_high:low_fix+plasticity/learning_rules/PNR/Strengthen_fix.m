
test1 = [99 99];
test2 = [88 88];
nrmse = [];
avg_nrmse = [];
count = 0;
lr = 0.001;

a = sort(abs(outWM(1,1:netDim*reservoirNum)));
b = sort(abs(outWM(2,1:netDim*reservoirNum)));
non0outWM1 = find(outWM(1,1:netDim*reservoirNum) ~= 0);
non0outWM2 = find(outWM(2,1:netDim*reservoirNum) ~= 0);

while (test1(1) >= test2(1)) & (test1(2) >= test2(2)) 
% while count < 25
    test1 = test2;
%     x1 = abs(outWM(1,:)) > a((netDim*reservoirNum-round(size(non0outWM1,2)*1/10)));
%     x2 = abs(outWM(2,:)) > b((netDim*reservoirNum-round(size(non0outWM2,2)*1/10)));
    
    x1 = abs(outWM(1,:)) > a(round(netDim*reservoirNum*9/10));
    x2 = abs(outWM(2,:)) > b(round(netDim*reservoirNum*9/10));
    
    % enhance separately based on output weights
    y1 = find(x1(1:netDim*reservoirNum) ==1);
    y2 = find(x2(1:netDim*reservoirNum) ==1);
    intWM(y1,:) = intWM(y1,:) * (1-lr);
    intWM(:,y1) = intWM(:,y1) * (1-lr);
    intWM(y2,:) = intWM(y2,:) * (1-lr);
    intWM(:,y2) = intWM(:,y2) * (1-lr);
    
%     % combine priceple neurons over outputs and enhance all together
%     x = x1 | x2;
%     y = find(x(1:netDim*reservoirNum) ==1);
%     
%     % strengthen all related weights (including trans-reservoir)
%     intWM(y,:) = intWM(y,:) * (1+lr);
%     intWM(:,y) = intWM(:,y) * (1+lr);
    
%     % strengthen related weights inside reservoir
%     intWM(x1,non0outWM1) = intWM(x1,non0outWM1) * (1+lr);
%     intWM(non0outWM1,x1) = intWM(non0outWM1,x1) * (1+lr);
%     intWM(x2,non0outWM2) = intWM(x2,non0outWM2) * (1+lr);
%     intWM(non0outWM2,x2) = intWM(non0outWM2,x2) * (1+lr);
    
    headers
    learnAndTest
    nrmse=[nrmse;NRMSE];
    avg_nrmse = [avg_nrmse;avg_NRMSE];
    count = count+1;
    test2 = (sqrt(msetestresult ./ teacherVariance));
    
end