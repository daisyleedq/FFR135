clear all, clc, clf, close all;

addpath(genpath('Data'))
fileID = fopen('data_ex2_task2_2017.txt');
data = textscan(fileID,'%f %f');
fclose(fileID);

input_data=[data{1,1} data{1,2}];

N=length(input_data);
weights = -1*ones(N, 2) +2*rand(N, 2);

numUpdates=2e4;
eta=0.001;

for iUpdate=1:numUpdate
   
    iPattern=randi([1 N]);
    xi=input_data(iPatttern,:);
    
    
end
