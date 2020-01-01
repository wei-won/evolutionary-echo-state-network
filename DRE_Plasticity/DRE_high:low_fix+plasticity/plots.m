%% BCM plot
load('BCM_avg_sliding_tau.mat');

% % *************  Scatter  *************
% % col of NRMSEs for 'scatter3' -- value
% avg_col = avg_mat(:);
% 
% % col of T for 'scatter3' -- X
% x = seqT';
% X = repmat(x,Leta*Ltau,1);
% 
% % col of eta for 'scatter3' -- Y
% y = repmat(seqeta,LT,1);
% Y = y(:);
% Y = repmat(Y,Ltau,1);
% 
% % col of tau for 'scatter3' -- Z
% z = repmat(seqtau,LT*Leta,1);
% Z = z(:);
% 
% % scatter3
% scatter3(X,Y,Z,40,avg_col,'filled');
% colorbar
% % ***********************************

% % ************ isosurface ************
% [X,Y,Z]=meshgrid(seqeta,seqT,seqtau);
% isosurface(X,Y,Z,avg_mat,0.65);
% alpha(0.2);

% ************* 3d surfc **************
tau = 260;
itau = find(seqtau==tau);
avg_tau = avg{itau};
[X,Y] = meshgrid(seqT,seqeta);
surfc(X,Y,avg_tau);
colorbar

shading interp % interpretation