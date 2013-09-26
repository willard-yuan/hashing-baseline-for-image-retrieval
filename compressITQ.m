function [C] = compressITQ(X, bit)
%
% code for converting data X to binary code C using ITQ
% Input:
%       X: n*d data matrix, n is number of images, d is dimension
%       bit: number of bits
% Output:      
%       C: n*bit binary code matrix
% 
% Yunchao Gong (yunchao@cs.unc.edu)
%


% center the data, VERY IMPORTANT for ITQ to work
sampleMean = mean(X,1);
X = (X - repmat(sampleMean,size(X,1),1));

% PCA
C = cov(X);
[pc, l] = eigs(C, bit);
XX = X*pc;

% ITQ to find optimal rotation
% default is 50 iterations
% C is the output code
% R is the rotation found by ITQ
[C, R] = ITQ(XX,50);
        


