function [ weights ] = OjaUpdate( weights, xi, input_data )
%OjaUpdate: Summary of this function goes here
%   Detailed explanation goes here

    zeta=input_data.*weights;
    deltaWeights=eta*zeta*(xi-zeta.*weights);
    weights=weights+deltaWeights;

end

