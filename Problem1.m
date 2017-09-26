clear all, clc, clf, close all;

M=100;
N=1000;
Torder=1e3;
Tconv=2e4;
sigma0=5;
eta0=0.1;
tausigma=300;
% eta=@(t)eta0*exp(t/tausigma);
% sigma=@(t)sigma0*exp(-t/tausigma);

input_data=zeros(N,2);

n=0;
figure(1),hold on
while n < N 
    x=rand;
    y=rand;
    if ~( x > 0.5 && y < 0.5 )
        n=n+1;
        input_data(n,:)=[x y];
        plot(x,y,'o')
    end
end
plot([0 0],[0 1],'k');plot([0.5 0.5],[0 0.5],'k');plot([1 1],[0.5 1],'k');
plot([0 0.5],[0 0],'k');plot([0.5 1],[0.5 0.5],'k');plot([0 1],[1 1],'k');

weights=2*rand([M 2])-1;

for t=1:(Torder+Tconv)
   
    if t < Torder
       
       eta=eta0*exp(t/tausigma);
       sigma=sigma0*exp(-t/tausigma);
        
    else
       
       eta=0.01;
       sigma=0.9;
        
    end
    
    iPattern=randi([1 1000]);
    weights = KohonenUpdate( input_data(iPattern,:), weights, eta, sigma );

end

figure(2),hold on
plot(weights(:,1),weights(:,2),'-o')
plot([0 0],[0 1],'k');plot([0.5 0.5],[0 0.5],'k');plot([1 1],[0.5 1],'k');
plot([0 0.5],[0 0],'k');plot([0.5 1],[0.5 0.5],'k');plot([0 1],[1 1],'k');




