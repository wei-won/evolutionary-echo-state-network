intWM0 = mat2cell(intWM, netDim*ones(1,reservoirNum), netDim*ones(1,reservoirNum));
for i = 1:reservoirNum;
    for j = 1:reservoirNum;
        if i~=j
            intWM0{i,j} = zeros(netDim, netDim);
        end
    end
end
intWM = cell2mat(intWM0);