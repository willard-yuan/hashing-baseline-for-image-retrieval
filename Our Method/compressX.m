function [B, UX] = compressX(X, Xparam)

% Input:
%          X: n*d data matrix, n is number of images, d is dimension
%          Xparam:
%
% output:
%            B: compacted binary code
%            U: binary code