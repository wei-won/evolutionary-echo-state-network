
Wkj = full(intWM);
[row,col] = find(Wkj~=0);
ep = 0.00001;





for i = 100:200
   a =  stateCollectMat(i,1:netDim*reservoirNum)';   
     
for j = 1:size(row,1)

xj = a(row(j));
yk = a(col(j));

Wd = ep*yk*(xj-yk*Wkj(row(j),col(j)));
Wkj(row(j),col(j)) = Wkj(row(j),col(j)) + Wd;
end
end


intWM = sparse(Wkj);

learnAndTest