%% Generate input data
clc, clear all, clf
inputDim = 2;
nbrOfInputs = 1000;
inputData = zeros(nbrOfInputs,inputDim);

i=1;
while (i < 1001)
    x = rand;
    y = rand;
    if (~(x > 0.5 && y < 0.5))
        inputData(i,:)=[x y];
        i=i+1;
    end
end

%% Plot data
clc, clf
hold on
lW = 2;
plot([0 0 ], [0 1], 'LineWidth', lW, 'Color', 'black')
plot([0.5 0.5 ], [0 0.5], 'LineWidth', lW, 'Color', 'black')
plot([1 1], [0.5 1], 'LineWidth', lW, 'Color', 'black')
plot([0 1], [1 1], 'LineWidth', lW, 'Color', 'black')
plot([0.5 1], [0.5 0.5], 'LineWidth', lW, 'Color', 'black')
plot([0 0.5], [0 0], 'LineWidth', lW, 'Color', 'black')

% plot(inputData(:,1), inputData(:,2), 'o')

%%
clc
nbrOfNeurons = 100;
weights = -1*ones(nbrOfNeurons, inputDim) +2*rand(nbrOfNeurons, inputDim);
tauSigma = 300;
eta0 = 0.1;
sigma0 = 100;
Torder = 10^3;

etaFunction = @(t)eta0*exp(-t/tauSigma);
sigmaFunction = @(t)sigma0*exp(-t/tauSigma);

for t = 1:Torder
    mu = randi([1 length(inputData)]);
    pattern = inputData(mu,:);
    
    dist = 10^7;
    winningIndex = 0;
    for i = 1:nbrOfNeurons
        tempDist = norm(pattern-weights(i,:));
        if (tempDist < dist)
            dist = tempDist;
            winningIndex = i;
        end
    end
    eta = etaFunction(t);
    sigma = sigmaFunction(t);
    weights = KohonenUpdate(pattern, winningIndex, weights, eta, sigma);
end

%%
clc, clf
hold on
lW = 2;
plot([0 0 ], [0 1], 'LineWidth', lW, 'Color', 'black')
plot([0.5 0.5 ], [0 0.5], 'LineWidth', lW, 'Color', 'black')
plot([1 1], [0.5 1], 'LineWidth', lW, 'Color', 'black')
plot([0 1], [1 1], 'LineWidth', lW, 'Color', 'black')
plot([0.5 1], [0.5 0.5], 'LineWidth', lW, 'Color', 'black')
plot([0 0.5], [0 0], 'LineWidth', lW, 'Color', 'black')
plot(weights(:,1), weights(:,2),'-o')
%%
hold on
for i = size(weights,1)
    hold on
    plot(weights(i,1), weights(i,2),'-o');
end
