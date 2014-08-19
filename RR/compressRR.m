function [B, U] = compressRR(X, RRparam)
% input:
%          X: n*d n is the number of samples, d is the dimension of feature
%          LSHparam: 1. LSHparam.nbits: encoding length
%                            2. LSHparam.w: hashing function
% output:
%          B: compacted binary code
%          U: binary code

pc = RRparam.pcaW;

V = X*pc;

U = V*RRparam.r;
B = zeros(size(U));
B (U>0) = 1;
B = compactbit(B>0);
U = (U>0);


