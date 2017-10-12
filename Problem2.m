%clear all, clc, clf, close all;

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
plot(log(1:numUpdates),weightNorm,'LineWidth',2)

figure(2), hold on

C=zeros(2,2);
for i=1:2
    for j=1:2
        for mu=1:p
            
            C(i,j)=C(i,j)+(1/p)*(input_data(mu,i)-mean(input_data(:,i)))*...
                   (input_data(mu,j)-mean(input_data(:,j)));
            
        end
    end
end

[V,D]=eig(C);

lambdaMax=max(D(:));
[~,index_lambdaMax]=find(D==lambdaMax);
eigVec_lambdaMax=V(:,index_lambdaMax);

plot(input_data(:,1),input_data(:,2),'o')
quiver(0,0,weights(1),weights(2),'LineWidth',2.0,'MaxHeadSize',1)
quiver(0,0,eigVec_lambdaMax(1),eigVec_lambdaMax(2),'LineWidth',2.0,'MaxHeadSize',1)

if centerData
    plot([-1.5 1.5],[0 0],'k')
    plot([0 0],[-1.5 1.5],'k')
    axis([-1.5 1.5 -1.5 1.5])
else
    plot([-1.5 14],[0 0],'k')
    plot([0 0],[-1.5 3],'k')
    axis([-1.5 14 -1.5 3])
end

figure(1)
title('Network Convergence','Interpreter','latex','FontSize',18)
ylabel('$|\mathbf{w}|$','Interpreter','latex','FontSize',14)
xlabel('log( Time step $t$ )','Interpreter','latex','FontSize',14)
figure(2)
title('Maximal Principle Component Direction','Interpreter','latex','FontSize',18)
ylabel('$\xi_1$','Interpreter','latex','FontSize',14)
xlabel('$\xi_2$','Interpreter','latex','FontSize',14)
l=legend('Data','$\mathbf{w}$','$\mathbf{u}_{\lambda_{max}}$');
set(l,'Interpreter','latex','FontSize',14)