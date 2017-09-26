function weights = KohonenUpdate(pattern, winningIndex, oldWeights, eta, sigma)
    
    NeighbouringFunction = @(winInd, ind, sigma) exp(-abs((ind-winInd))^2/(2*sigma));
    deltaWeights = zeros(size(oldWeights));
    
    for i = 1:size(oldWeights,1)
        deltaWeights(i,:) = eta * (pattern-oldWeights(i,:)) * NeighbouringFunction(i,winningIndex,sigma);
    end
    weights = oldWeights + deltaWeights;
end