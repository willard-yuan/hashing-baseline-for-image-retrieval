function [B, U] = compressLSH(X, LSHparam)

% Input:
%          X: n*d n is the number of samples, d is the dimension of feature
%          LSHparam: 
%                           LSHparam.nbits---encoding length
%                           LSHparam.w---hashing function
% Output:
%          B: compacted binary code
%          U: binary code


U = X*LSHparam.w;
%B = zeros(size(U));
%B (U>0) = 1;
B = compactbit(U>0);
U = (U>0);


