function weights = KohonenUpdate(pattern, winningIndex, weights, eta, sigma)
%KohonenUpdate: performs a weight update according to Kohonen update rules
%   
%   INPUT AND OUTPUT:
%   pattern - randomly selected pattern of size 1xN
%   winningIndex - index of winning neuron
%   weights - weights of size 1xN
%   eta - eta parameter according to current phase
%   sigma - sigma parameter according to current phase

    % defines neighbouring function
    NeighbouringFunction = @(winInd, ind, sigma) exp(-abs((ind-winInd))^2/(2*sigma));
    deltaWeights = zeros(size(weights));
    
    % calculates weight difference for each pattern
    for i = 1:size(weights,1)
        deltaWeights(i,:) = eta * (pattern-weights(i,:)) * NeighbouringFunction(i,winningIndex,sigma);
    end
    % updates weights
    weights = weights + deltaWeights;
end