function [B, U] = compressMFH(X, CMFHparam)

% Input:
%          X: n*d n is the number of samples, d is the dimension of feature
%          LSHparam: 
%                           LSHparam.nbits---encoding length
%                           LSHparam.w---hashing function
% Output:
%          B: compacted binary code
%          U: binary code


%U = X*CMFHparam.P;

U = (bsxfun(@minus, CMFHparam.P * X' , mean(CMFHparam.Y,2)))';

%B = zeros(size(U));
%B (U>0) = 1;
B = compactbit(U>0);
U = (U>0);


