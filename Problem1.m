clear all, clc, clf, close all;

M=100;
N=1000;
Torder=1e3;
Tconv=2e4;
sigma0=100;
eta0=0.1;
tausigma=300;
etaFunction=@(t)eta0*exp(-t/tausigma);
sigmaFunction=@(t)sigma0*exp(-t/tausigma);

input_data=zeros(N,2);

n=0;
figure(1),hold on
plot([0 0],[0 1],'k');plot([0.5 0.5],[0 0.5],'k');plot([1 1],[0.5 1],'k');
plot([0 0.5],[0 0],'k');plot([0.5 1],[0.5 0.5],'k');plot([0 1],[1 1],'k');
figure(2)
subplot(1,2,1)
hold on
plot([0 0],[0 1],'k');plot([0.5 0.5],[0 0.5],'k');plot([1 1],[0.5 1],'k');
plot([0 0.5],[0 0],'k');plot([0.5 1],[0.5 0.5],'k');plot([0 1],[1 1],'k');
subplot(1,2,2)
hold on
plot([0 0],[0 1],'k');plot([0.5 0.5],[0 0.5],'k');plot([1 1],[0.5 1],'k');
plot([0 0.5],[0 0],'k');plot([0.5 1],[0.5 0.5],'k');plot([0 1],[1 1],'k');

while n < N 
    x=rand;
    y=rand;
    if ~( x > 0.5 && y < 0.5 )
        n=n+1;
        input_data(n,:)=[x y];
        figure(1)
        plot(x,y,'o')
    end
end

weights = -1*ones(M, 2) +2*rand(M, 2);

for t=1:(Torder+Tconv)
   
    if t <= Torder
       
       eta=eta0*exp(-t/tausigma);
       sigma=sigma0*exp(-t/tausigma);
       
       if t==Torder
           figure(2)
           subplot(1,2,1)
           plot(weights(:,1),weights(:,2),'-o')
           axis image
       end
        
    else
       
       eta=0.01;
       sigma=0.9;
        
    end
    
    mu=randi([1 1000]);
    pattern=input_data(mu,:);
    dist = 10^7;
    winningIndex = 0;
    for i = 1:M
        tempDist = norm(pattern-weights(i,:));
        if (tempDist < dist)
            dist = tempDist;
            winningIndex = i;
        end
    end
    
    weights=KohonenUpdate(pattern, winningIndex, weights, eta, sigma);

end

figure(2)
subplot(1,2,2)
plot(weights(:,1),weights(:,2),'-o')
axis image





