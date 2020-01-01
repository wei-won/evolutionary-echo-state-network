seqtau = [1,20,40,60,80,100,120,140,160,180,200,220,240,260,280,300];
Ltau = length(seqtau);

resluts = cell(Ltau,2);

for itau = 1:Ltau
    tau = seqtau(itau);
    disp(['tau = ',num2str(tau),'...']);
    BCM_optTest;
    resluts{itau,1} = avg_nrmseReshape;
    resluts{itau,2} = nrmseReshape;
end
