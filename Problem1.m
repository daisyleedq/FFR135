clear all, clc, clf, close all;

% INITIALIZING VARIABLES
M=100;
N=1000;
Torder=1e3;
Tconv=2e4;
sigma0=100;
eta0=0.1;
tausigma=300;
input_data=zeros(N,2);
weights = -1*ones(M, 2) +2*rand(M, 2);

% GENEATING DATA
n=0;
while n < N 
    x=rand;
    y=rand;
    if ~( x > 0.5 && y < 0.5 )
        n=n+1;
        input_data(n,:)=[x y];
        figure(1), hold on
        plot(x,y,'o','LineWidth',1.2)
    end
end

% --- TRAINING NETWORK ---
for t=1:(Torder+Tconv)% looping through all time steps
   
    if t <= Torder % updating eta and sigma according in ordering phase
       
       eta=eta0*exp(-t/tausigma);
       sigma=sigma0*exp(-t/tausigma);
       
       if t==Torder % plots the weights at the end of ordering phase
           figure(2), hold on
           plot(weights(:,1),weights(:,2),'-o','LineWidth',1.2)
       end
        
    else % updating eta and sigma according in convergence phase
       
       eta=0.01;
       sigma=0.9;
        
    end
    
    mu=randi([1 1000]); % randomly selects updating pattern
    pattern=input_data(mu,:);
    
    % derived index of winning neuron
    dist = inf;
    winningIndex = 0;
    for i = 1:M
        tempDist = norm(pattern-weights(i,:));
        if (tempDist < dist)
            dist = tempDist;
            winningIndex = i;
        end
    end
    
    % updates weights according to the Kohonen update rule
    weights=KohonenUpdate(pattern, winningIndex, weights, eta, sigma);

end

figure(3),hold on
plot(weights(:,1),weights(:,2),'-o','LineWidth',1.2)

% PLOTTING DETAILS
figure(1)
plot([0 0],[0 1],'k','LineWidth',2);plot([0.5 0.5],[0 0.5],'k','LineWidth',2);
plot([1 1],[0.5 1],'k','LineWidth',2);plot([0 0.5],[0 0],'k','LineWidth',2);
plot([0.5 1],[0.5 0.5],'k','LineWidth',2);plot([0 1],[1 1],'k','LineWidth',2);
title('Original Data Set','Interpreter','latex','FontSize',18)
xlabel('$\xi_1$','Interpreter','latex','FontSize',14)
ylabel('$\xi_2$','Interpreter','latex','FontSize',14)
set(gca,'FontSize',12)
figure(2)
plot([0 0],[0 1],'k','LineWidth',2);plot([0.5 0.5],[0 0.5],'k','LineWidth',2);
plot([1 1],[0.5 1],'k','LineWidth',2);plot([0 0.5],[0 0],'k','LineWidth',2);
plot([0.5 1],[0.5 0.5],'k','LineWidth',2);plot([0 1],[1 1],'k','LineWidth',2);
title('Weight Vectors after Ordering Phase','Interpreter','latex','FontSize',18)
xlabel('$w_1$','Interpreter','latex','FontSize',14)
ylabel('$w_2$','Interpreter','latex','FontSize',14)
figure(3)
plot([0 0],[0 1],'k','LineWidth',2);plot([0.5 0.5],[0 0.5],'k','LineWidth',2);
plot([1 1],[0.5 1],'k','LineWidth',2);plot([0 0.5],[0 0],'k','LineWidth',2);
plot([0.5 1],[0.5 0.5],'k','LineWidth',2);plot([0 1],[1 1],'k','LineWidth',2);
title('Weight Vectors after Convergence Phase','Interpreter','latex','FontSize',18)
xlabel('$w_1$','Interpreter','latex','FontSize',14)
ylabel('$w_2$','Interpreter','latex','FontSize',14)

