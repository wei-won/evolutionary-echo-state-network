function mse = fitnessFunc(gene)
% gene = [];
headers;
connectMat = reshape(gene,inputVarNum+outputLength,reservoirNum).';
% for g = 1:(inputVarNum+outputLength)*reservoirNum;
% gene = [gene,gene(g)];
% end

% No iterations for each individual

% generate_data;
% generate_weather;
% generateNet;
buildStructure;
learnAndTest;
mse = mean(NRMSE);

% mse(1) = msetest(1);
% mse(2) = msetest(2);

% % 10 iterations for each individual
% generate_data;
% generate_weather;
% mseCollect = [];
% for iteration = 1:10
%     generateNet;
%     learnAndTest;
%     mseCollect = [mseCollect,mean(msetest)];
% end
% mse = mean(mseCollect);

end