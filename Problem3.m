clear all, clc, clf, close all;

% --- IMPORTING DATA ---
addpath(genpath('Data'))
fileID = fopen('data_ex2_task3_2017.txt');
data = textscan(fileID,'%f %f %f');
fclose(fileID);

targets=data{1,1};

input_data=[data{1,2} data{1,3}];

kValues=1:10;
numRuns=20;
numUpdates1=1e5;
numUpdates2=3000;
p=size(input_data,1);
N=size(input_data,2);
meanCE=zeros(1,length(kValues));

figure(1), hold on
for i=1:length(targets)
    if targets(i) == 1
        scatter(input_data(i,1),input_data(i,2),50,'yellow','filled')
    else
        scatter(input_data(i,1),input_data(i,2),50,'green','filled')        
    end
end
figure(2), hold on
for i=1:length(targets)
    if targets(i) == 1
        scatter(input_data(i,1),input_data(i,2),50,'yellow','filled')
    else
        scatter(input_data(i,1),input_data(i,2),'green','filled')        
    end
end
numPointsX=80;
numPointsY=80;

for iKval=4:length(kValues)
    
    k=kValues(iKval);
    input_unsup=input_data;
    minCE=inf;
    CE=zeros(numRuns,1);
    
    for iRun=1:numRuns
        
        weights_unsup = -1*ones(k, N) +2*rand(k, N);
        
        for iUpdate=1:numUpdates1
            
            iPattern=randi([1 p]);
            weights_unsup = unsupervisedUpdate( input_unsup(iPattern,:), weights_unsup );
            
        end
        
        output_unsup = unsupervisedRun( input_unsup, weights_unsup );
        input_sup = output_unsup;
        
        weights_sup = -1*ones(1, k) +2*rand(1, k);
        threshold = -1*ones(1, 1) +2*rand(1, 1);
        
        for iUpdate=1:numUpdates2
            
            iPattern=randi([1 p]);
            [ weights_sup, threshold ] = supervisedUpdate( input_sup(iPattern,:), targets(iPattern), weights_sup, threshold );
            
        end
        
        output_sup = supervisedRun( input_sup, weights_sup, threshold );
        
        signO=sign(output_sup);
        signO(signO==0)=1;
        
        CE(iRun)=(1/(2*p))*sum(abs(targets-signO));
        
        if CE(iRun) < minCE
            
            minCE=CE(iRun);
            best_weights_unsup = weights_unsup;
            best_weights_sup = weights_sup;
            best_threshold = threshold;
            
        end
        
    end
    
    meanCE(iKval)=mean(CE);

    
    if k==4 || k==10
    
        if k==4
            figure(1)
        else
            figure(2)
        end
        
        [X,Y]=meshgrid(linspace(-15,25,numPointsX),linspace(-10,15,numPointsY));
        
        output_mesh=zeros(numPointsX,numPointsY);
        
        for i=1:numPointsX
            for j=1:numPointsY
                
                input_unsup=[X(i,j) Y(i,j)];
                output_unsup = unsupervisedRun( input_unsup, best_weights_unsup );
                input_sup = output_unsup;
                output_sup = supervisedRun( input_sup, best_weights_sup, best_threshold );
                
                output_mesh(i,j)=output_sup;
                
                if output_sup >= 0
                    plot(X(i,j),Y(i,j),'o','Color','yellow')
                else
                    plot(X(i,j),Y(i,j),'o','Color','green')
                end
                
            end
        end
        
        voronoi(best_weights_unsup(:,1),best_weights_unsup(:,2))
        
        for i = 1:size(best_weights_unsup,1)
            hold on
            plot([0 best_weights_unsup(i,1)], [0 best_weights_unsup(i,2)], 'Color','k', 'LineWidth',2)
            plot(best_weights_unsup(i,1),best_weights_unsup(i,2),'o', 'MarkerFaceColor','k', 'MarkerEdgeColor','k')
        end
        
        title(['Decision Boundary, k=' num2str(kValues(iKval))],'Interpreter','latex','FontSize',18)
        xlabel('$\xi_1$','Interpreter','latex','FontSize',14)
        ylabel('$\xi_2$','Interpreter','latex','FontSize',14)
        
        disp(['Mean classification error for k=' num2str(kValues(iKval)) ' was: ' num2str(meanCE(iKval))])
        disp(['Minimum classification error for k=' num2str(kValues(iKval)) ' was: ' num2str(minCE)])

    end
        
end

if length(kValues)>1
    figure(3)
    plot(kValues,meanCE,'-o','LineWidth',1.5)
    title('Mean Classification Error','Interpreter','latex','FontSize',18)
    xlabel('$k$-values','Interpreter','latex','FontSize',14)
    ylabel('$C_{error}$','Interpreter','latex','FontSize',14)
    save('CE_mean.mat','meanCE')
end
    
    