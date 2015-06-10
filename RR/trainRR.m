function RRparam = trainRR(RRparam)

% Input:
%          RRparam.nbits: number of bits (nbits do not need to be a multiple of 8)
%
% Output:
%             RRparam.r: random rotation
%             RRparam.nbits: encoding length

nbits = RRparam.nbits;

R = randn(nbits, nbits);
[U, ~, ~] = svd(R);
R = U(:, 1: nbits);

RRparam.r = R;

fprintf('PCA-RR training process has finished\r');