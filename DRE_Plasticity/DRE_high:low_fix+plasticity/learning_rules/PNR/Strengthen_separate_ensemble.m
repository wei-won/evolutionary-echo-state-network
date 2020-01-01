

test1 = [99 99];
test2 = [88 88];
count = 0;

while (test1(1) > test2(1)) | (test1(2) > test2(2))
    test1 = test2;
    for i = 1:reservoirNum
        sequence = sort(abs(outWM(1,((i-1)*netDim)+1:netDim*i)));
        sequence2 = sort(abs(outWM(2,((i-1)*netDim)+1:netDim*i)));
        x(1,((i-1)*netDim)+1:netDim*i) = abs(outWM(1,((i-1)*netDim)+1:netDim*i)) > sequence(netDim-3);
        x(2,((i-1)*netDim)+1:netDim*i) = abs(outWM(2,((i-1)*netDim)+1:netDim*i)) > sequence2(netDim-3);
    end
    y1 = find(x(1,1:netDim*reservoirNum) ==1);
    y2 = find(x(2,1:netDim*reservoirNum) ==1);
    intWM(y1,:) = intWM(y1,:)*1.001;
    intWM(:,y1) = intWM(:,y1)*1.001;
    intWM(y2,:) = intWM(y2,:)*1.001;
    intWM(:,y2) = intWM(:,y2)*1.001;
    headers
    learnAndTest
    count = count+1;
    test2 = (sqrt(msetestresult ./ teacherVariance));
end

