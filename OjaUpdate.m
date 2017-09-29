function [ weights ] = OjaUpdate( weights, xi )
%OjaUpdate: Summary of this function goes here
%   Detailed explanation goes here
    
    eta=0.001;
    zeta=xi*weights';
    deltaWeights=eta*zeta*(xi-zeta.*weights);
    weights=weights+deltaWeights;

end

