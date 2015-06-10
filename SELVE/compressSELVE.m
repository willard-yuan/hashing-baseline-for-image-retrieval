function [B, Y] = compressSELVE(X, SELVEparam)
%function Y = compressSELVE(X, Anchor, lambda, s, sigma, tempResults)

Anchor = SELVEparam.anchor;
s = SELVEparam.s;
lambda = SELVEparam.lambda;
sigma = SELVEparam.sigma;
tempResults = SELVEparam.tempResults;

[n,dim] = size(X);
m = size(Anchor,1);

%% get Z
Z = zeros(n,m);
Dis = sqdist(X',Anchor');
clear X;
clear Anchor;

val = zeros(n,s);
pos = val;
for i = 1:s
    [val(:,i),pos(:,i)] = min(Dis,[],2);
    tep = (pos(:,i)-1)*n+[1:n]';
    Dis(tep) = 1e60;
end
clear Dis;
clear tep;
val = exp(-val/(1/1*sigma^2));
val = repmat(sum(val,2).^-1,1,s).*val; %% normalize
tep = (pos-1)*n+repmat([1:n]',1,s);
Z([tep]) = [val];
Z = sparse(Z);
clear tep;
clear val;
clear pos;
lamda1 = sum(Z);
Z = diag(lamda1.^-0.5)*Z'; %Z : fea * ins
Z = Z';

tempS = tempResults.T*Z' + repmat(tempResults.beta,1,size(Z,1));
Y = double(tempS > repmat(tempResults.Ui,1,n));
Y = Y';
B = compactbit(Y);


