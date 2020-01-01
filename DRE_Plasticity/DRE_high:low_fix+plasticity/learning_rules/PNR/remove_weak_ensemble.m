

for i = 1:reservoirNum
rank(i) = sum(sum(abs(outWM(:,((i-1)*netDim)+1:netDim*i))))
end
index = find(rank == min(abs(rank)))


intWM(:,((index-1)*netDim)+1:netDim*index) = 0

intWM(((index-1)*netDim)+1:netDim*index,:) = 0


learnAndTest;

mse(1) = msetest(1);
mse(2) = msetest(2);