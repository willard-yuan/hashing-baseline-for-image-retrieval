function [B, U] = compressBPH(X, BPHparam)

% Input:
%          X: n*d n is the number of samples, d is the dimension of feature
%          LSHparam: 
%                           LSHparam.nbits---encoding length
%                           LSHparam.w---hashing function
% Output:
%          B: compacted binary code
%          U: binary code


U = (BPHparam.P * X')'*BPHparam.R;

%U = bsxfun(@minus, (MFHparam.P * X')'*MFHparam.R, mean(MFHparam.Y',1));

%B = zeros(size(U));
%B (U>0) = 1;
B = compactbit(U>0);
U = (U>0);


