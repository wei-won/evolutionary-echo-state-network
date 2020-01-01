

clc
test1 = [99 99];
test2 = [88 88];
count = 0;
a = sort(abs(outWM(1,1:netDim*reservoirNum)));

while (test1(1) > test2(1)) | (test1(2) > test2(2)) 
    test1 = test2;
    x = abs(outWM) > a(round(netDim*reservoirNum*5/10));
    y1 = find(x(1,1:netDim*reservoirNum) ==1);
    intWM(y1,:) = intWM(y1,:)*1.001;
    intWM(:,y1) = intWM(:,y1)*1.001;
    headers
    learnAndTest
    count = count+1;
    test2 = (sqrt(msetestresult ./ teacherVariance));
end

test1 = [99 99];
test2 = [88 88];
count = 0;
a = sort(abs(outWM(2,1:netDim*reservoirNum)));

while (test1(1) > test2(1)) | (test1(2) > test2(2)) 
    test1 = test2;
    x = abs(outWM) > a(round(netDim*reservoirNum*5/10));
    y1 = find(x(2,1:netDim*reservoirNum) ==1);
    intWM(y1,:) = intWM(y1,:)*1.001;
    intWM(:,y1) = intWM(:,y1)*1.001;
    headers
    learnAndTest
    count = count+1;
    test2 = (sqrt(msetestresult ./ teacherVariance));
end




test1 = [99 99];
test2 = [88 88];
count = 0;

a = sort(abs(outWM(1,1:netDim*reservoirNum)));
b = sort(abs(outWM(2,1:netDim*reservoirNum)));

while (test1(1) > test2(1)) | (test1(2) > test2(2)) 
    test1 = test2;
    x1 = abs(outWM(1,:)) > a(round(netDim*reservoirNum*9/10));
    x2 = abs(outWM(2,:)) > b(round(netDim*reservoirNum*9/10));
    y1 = find(x1(1:netDim*reservoirNum) ==1);
    y2 = find(x2(1:netDim*reservoirNum) ==1);
    intWM(y1,:) = intWM(y1,:)*1.001;
    intWM(:,y1) = intWM(:,y1)*1.001;
    intWM(y2,:) = intWM(y2,:)*1.001;
    intWM(:,y2) = intWM(:,y2)*1.001;
    headers
    learnAndTest
    count = count+1;
    test2 = (sqrt(msetestresult ./ teacherVariance));
end