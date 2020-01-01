

clc
test1 = [99];
test2 = [88];
count = 0;
lr = 0.001;
reservoirNum = 1;
PNeurons = [];
intWM0Trend = [];
outWMTrend = [];
RCstateTrend = [];
mseTrend = [];

a = sort(abs(outWM(1,1:netDim*reservoirNum))); % should be in the loop

% while (test1 > test2) 
while count < 1000
    test1 = test2;
    x = abs(outWM(1,1:netDim*reservoirNum)) > a(round(netDim*reservoirNum*9/10));
    y1 = find(x(1,1:netDim*reservoirNum) ==1);
    intWM0(y1,:) = intWM0(y1,:)*(1+lr);
    intWM0(:,y1) = intWM0(:,y1)*(1+lr);
    headers
    learnAndTest
    count = count+1;
    test2 = (sqrt(msetestresult ./ teacherVariance));
%     PNeurons = [PNeurons;y1];
    
    RCstateTrend(:,:,count) = stateCollectMat;
    intWM0Trend(:,:,count) = intWM0;
    outWMTrend(:,:,count) = outWM;
    mseTrend = [mseTrend;test2];
end


ResultPath = '/Users/metoo/Documents/experiment/rc/Ensemble RC/DRE+Plasticity/StandardESN+plasticity/ResultMats/';
path = '/Users/metoo/Documents/experiment/rc/Ensemble RC/DRE+Plasticity/StandardESN+plasticity/NetMats/';

save([ResultPath 'trendMats_100(1_1000run).mat'],'count','y1','RCstateTrend','intWM0Trend','outWMTrend','mseTrend');
save([path 'inoutMat_100(1_1000run).mat'],'sampleinput','sampleout');

% test1 = [99 99];
% test2 = [88 88];
% count = 0;
% a = sort(abs(outWM(2,1:netDim*reservoirNum)));
% 
% while (test1(1) > test2(1)) | (test1(2) > test2(2)) 
%     test1 = test2;
%     x = abs(outWM) > a(round(netDim*reservoirNum*5/10));
%     y1 = find(x(2,1:netDim*reservoirNum) ==1);
%     intWM(y1,:) = intWM(y1,:)*1.001;
%     intWM(:,y1) = intWM(:,y1)*1.001;
%     headers
%     learnAndTest
%     count = count+1;
%     test2 = (sqrt(msetestresult ./ teacherVariance));
% end
% 
% 
% 
% 
% test1 = [99 99];
% test2 = [88 88];
% count = 0;
% 
% a = sort(abs(outWM(1,1:netDim*reservoirNum)));
% b = sort(abs(outWM(2,1:netDim*reservoirNum)));
% 
% while (test1(1) > test2(1)) | (test1(2) > test2(2)) 
%     test1 = test2;
%     x1 = abs(outWM(1,:)) > a(round(netDim*reservoirNum*9/10));
%     x2 = abs(outWM(2,:)) > b(round(netDim*reservoirNum*9/10));
%     y1 = find(x1(1:netDim*reservoirNum) ==1);
%     y2 = find(x2(1:netDim*reservoirNum) ==1);
%     intWM(y1,:) = intWM(y1,:)*1.001;
%     intWM(:,y1) = intWM(:,y1)*1.001;
%     intWM(y2,:) = intWM(y2,:)*1.001;
%     intWM(:,y2) = intWM(:,y2)*1.001;
%     headers
%     learnAndTest
%     count = count+1;
%     test2 = (sqrt(msetestresult ./ teacherVariance));
% end