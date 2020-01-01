Wkj = full(intWM);
[row,col] = find(Wkj~=0);



for i = 1:100
    
    for j = 1:size(row,1)
        
        
        presynapse = row(col==col(j));
        postsynapse = col(col==col(j));
        
        D = stateCollectMat(1:size(postsynapse,1),[presynapse']);
        I = eye(size(presynapse,1));
        P = 1/size(presynapse,1);
        
        temp = Wkj([presynapse],[postsynapse]);
        theta = sum(P*(temp(:,1)*D(1,:)).^2);
        a =  stateCollectMat(size(postsynapse,1),1:netDim*reservoirNum)';
        b =  stateCollectMat(size(postsynapse,1)+1,1:netDim*reservoirNum)';
        xk = a(row(j));
        yk = b(col(j));
        Wd = yk*xk*(yk-theta)/theta;
        Wkj(row(j),col(j)) = Wkj(row(j),col(j)) - Wd;
    end
end


intWM = sparse(Wkj);



normc(intWM);


