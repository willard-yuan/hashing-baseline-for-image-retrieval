function [B, U] = compressPCAH(X, PCAHparam)
% Input:
%          X: n*d n is the number of samples, d is the dimension of feature
%          PCAHparam:
%                              PCAHparam.nbits---encoding length
%                              PCAHparam.pcaW---hashing function
% Output:
%          B: compacted binary code
%          U: binary code

 
U = X*PCAHparam.pcaW;
B = compactbit(U>0);
U = (U>0);

