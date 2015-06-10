function LSHparam = trainLSH(LSHparam)

% Input:
%          LSHparam
%              LSHparam.nbits---number of bits (nbits do not need to be a multiple of 8)
% Output:
%             LSHparam:
%                 LSHparam.w---random projection

dim = LSHparam.dim;
nbits = LSHparam.nbits;

W = randn(dim, nbits);

LSHparam.w = W;

fprintf('LSH training process has finished\r');