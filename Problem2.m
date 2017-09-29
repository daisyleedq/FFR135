clear all, clc, clf, close all;

% INPUT
numUpdates=2e4;
% boolean stating if data is to be centered around zero or not
% 1 -> centered, 0 -> not centered
centerData=1;

% --- IMPORTING DATA ---
addpath(genpath('Data'))
fileID = fopen('data_ex2_task2_2017.txt');
data = textscan(fileID,'%f %f');
fclose(fileID);

% --- TRAINING NETWORK ---
if centerData
    input_data=[(data{1,1}-mean(data{1,1})) (data{1,2}-mean(data{1,2}))];
else
    input_data=[data{1,1} data{1,2}];
end

p=size(input_data,1);
N=size(input_data,2);
weights = -1*ones(1, N) +2*rand(1, N);
weightNorm = zeros(1,numUpdates);

for iUpdate=1:numUpdates
   
    iPattern=randi([1 p]);
    xi=input_data(iPattern,:);
    
    weights = OjaUpdate( weights, xi );
    weightNorm(iUpdate)=norm(weights);
    
end

figure(1)
plot(1:numUpdates,weightNorm)

figure(2), hold on
if centerData
    plot([-1.5 1.5],[0 0],'k')
    plot([0 0],[-1.5 1.5],'k')
else
    plot([-2 14],[0 0],'k')
    plot([0 0],[-0.5 3],'k')
end
    
plot(input_data(:,1),input_data(:,2),'o')
%plot([0 weights(1)],[0 weights(2)],'linewidth',2.0)
quiver(0,0,weights(1),weights(2),'LineWidth',2.0,'MaxHeadSize',1)