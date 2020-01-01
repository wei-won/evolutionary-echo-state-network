IN = ones(inputLength,size(weather(:,1),1)-15);
OUT = ones(size(weather(:,1),1)-15,outputLength);

for i = 1:size(weather(:,1),1)-15

    IN(1:15,i) = weather(i:i+14,2);
    IN(16:30,i) = weather(i:i+14,3);
    IN(31:45,i) = weather(i:i+14,4);
    IN(46:60,i) = weather(i:i+14,6);
    IN(61:75,i) = weather(i:i+14,7);
    
end

% % Output for 1_1_1
% OUT = weather(16:1277,2);
% OUT = weather(16:1277,3);

% Output for 2_1_1/2_2_1
for i = 1:outputLength
    OUT(:,i) = weather(16:1277,i+5);
end

% IN = 0.1*ones(5,size(weather(:,1),1));
% IN(1,:) = weather(:,2)';
% IN(2,:) = weather(:,9)';
% IN(3,:) = weather(:,10)';
% IN(4,:) = weather(:,5)';
% IN(5,:) = weather(:,7)';

% IN(2,:) = ones(1,size(weather(:,1),1));
% IN(3,:) = ones(1,size(weather(:,1),1));
% IN(4,:) = ones(1,size(weather(:,1),1));
% IN(5,:) = ones(1,size(weather(:,1),1));

% OUT = weather(:,2);

sampleinput = IN;
sampleout = OUT';

% sampleinput(sampleinput == -1) = 0;
% 
% for i = 1:inputLength
%     sampleinput(i,:)=((sampleinput(i,:))/ max(sampleinput(i,:)))-0.5;
% end
% for i = 1:outputLength
%     sampleout(:,i) = (sampleout(:,i)/max(sampleout(:,i)))-0.5;
% end

% normalize input to range [-0.5,0.5]
for indim = 1:length(sampleinput(:,1))
    maxVal = max(sampleinput(indim,:)); minVal = min(sampleinput(indim,:));
    if maxVal - minVal > 0
      sampleinput(indim,:) = (sampleinput(indim,:) - minVal)/(maxVal - minVal)-0.5;
    end
end

% normalize output to range [-0.5,0.5]
for outdim = 1:length(sampleout(:,1))
    maxVal = max(sampleout(outdim,:)); minVal = min(sampleout(outdim,:));
    if maxVal - minVal > 0
       sampleout(outdim,:) = (sampleout(outdim,:) - minVal)/(maxVal - minVal)-0.5;
    end
end


%% Plot I/O
% % plot generated sampleout
% figure(1); clf;
% outdim = length(sampleout(:,1));
% for k = 1:outdim
%     subplot(outdim, 1, k);
%     plot(sampleout(k,:));
%     if k == 1
%         title('sampleout','FontSize',8);
%     end
% end
%     
% % plot generated sampleinput
% figure(2); clf;
% outdim = length(sampleinput(:,1));
% for k = 1:outdim
%     subplot(outdim, 1, k);
%     plot(sampleinput(k,:));
%     if k == 1
%         title('sampleinput','FontSize',8);
%     end
% end