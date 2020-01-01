


for i = 1:reservoirNum
rank(i) = sum(sum(abs(outWM(:,((i-1)*netDim)+1:netDim*i))))
end
index = find(rank == max(abs(rank)))

test1 = [99 99];
test2 = [88 88];
count = 0;
x = zeros(2,575);
x(:,((index-1)*netDim)+1:netDim*index) = 1;

while (test1(1) > test2(1)) | (test1(2) > test2(2)) 
    test1 = test2;
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

