diffOnInt = intWM0Trend(:,:,count)-intWM0Trend(:,:,1);
intEvolutionIndex = find(diffOnInt);
[intX,intY] = find(diffOnInt);

% Creat a 2-D matrix for intWM trending
% History series of every changed internal weight list in row
for i = 1:size(intX,1)
    evolutionOnInt(i,:) = intWM0Trend(intX(i),intY(i),:);
end

% Creat a 2-D matrix for trend of outWM standard division
% put the std of outWM for each iter in row
outWMstdTrend(1,:) = std(outWMTrend);

% Creat a 2-D matrix for trend of intWM standard division
% put the std of intWM for each iter in row
for i = 1:count
   intWM0stdTrend(1,i) = std2(intWM0Trend(:,:,i)); 
end

% Plot the trend of std on outWM
figure(1);
plot(outWMstdTrend);
title('output weights std trend');

% Plot the trend of std on intWM0
figure(2);
plot(intWM0stdTrend);
title('internal weights std trend');

% Plot trend of mse
figure(3);
plot(mseTrend);
title('mse trend');

% % Plot trend of internal weights
% figure(4);
% plot(abs(evolutionOnInt'));
% title('internal weights std trend');
intWM0TrendPlot = reshape(intWM0Trend,size(intWM0Trend,1) ...
    *size(intWM0Trend,2),size(intWM0Trend,3)); % transform intWM0Trend into 2D column wise
figure(5);
plot(intWM0TrendPlot(:,1));
hold on
plot(intWM0TrendPlot(:,count));
hold off
title('1st intWM vs last intWM');

% Plot trend of output weights
figure(6);
plot(outWMTrend(:,:,1));
hold on
plot(outWMTrend(:,:,count));
hold off
title('1st outWM vs last outWM');
