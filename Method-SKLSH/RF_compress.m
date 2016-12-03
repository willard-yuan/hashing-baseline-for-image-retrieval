function [Y, Z] = RF_compress(X, RFparam)

N = size(X,1);

B = repmat(RFparam.B, N, 1);

%%
%% compute random features
%%
W = sqrt(2) * cos(X * RFparam.R + B);



%%
%% compute signs of random features
%%
%T = (rand(N,RFparam.M) * 2 - 1) * sqrt(2);
T = repmat(RFparam.T, N, 1);

Z = sign(W + T);
Y = compactbit(Z>0);

