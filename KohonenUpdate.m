function [ weights ] = KohonenUpdate( pattern, weights, eta, sigma )
%KohonenUpdate: Summary of this function goes here
%   Detailed explanation goes here

Lambda=@(i,i0) exp(-abs(i-i0)^2/(2*sigma^2));
i0=0;
minLength=inf;
for i=1:length(weights)
   
    l=norm(pattern-weights(i,:);
    if l <= minLength
        minLength=l;
        i0=i;
    end
        
end

for i=1:length(weights)
   
    dw=eta*Lambda(i,i0)*(pattern-weights(i,:));
    weights(i,:)=weights(i,:)+dw;
    
end

end

