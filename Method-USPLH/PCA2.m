function [eigvector, eigvalue, elapse] = PCA2(covdata, options)
%PCA	Principal Component Analysis
%
%	Usage:
%       [eigvector, eigvalue] = PCA(data, options)
%       [eigvector, eigvalue] = PCA(data)
% 
%             Input:
%               data       - Data matrix. Each row vector of fea is a data point.
%
%     options.ReducedDim   - The dimensionality of the reduced subspace. If 0,
%                         all the dimensions will be kept. 
%                         Default is 0. 
%
%             Output:
%               eigvector - Each column is an embedding function, for a new
%                           data point (row vector) x,  y = x*eigvector
%                           will be the embedding result of x.
%               eigvalue  - The sorted eigvalue of PCA eigen-problem. 
%
%	Examples:
% 			fea = rand(7,10);
% 			[eigvector,eigvalue] = PCA(fea,4);
%           Y = fea*eigvector;
% 
%   version 2.2 --Feb/2009 
%   version 2.1 --June/2007 
%   version 2.0 --May/2007 
%   version 1.1 --Feb/2006 
%   version 1.0 --April/2004 
%
%   Written by Deng Cai (dengcai2 AT cs.uiuc.edu)
%                                                   

if (~exist('options','var'))
   options = [];
end

ReducedDim = size(covdata,1);
if isfield(options,'ReducedDim')
    ReducedDim = options.ReducedDim;
end
tmp_T = cputime;

%[nSmp,nFea] = size(data);

ddata = max(covdata, covdata');

dimMatrix = size(ddata,2);
if dimMatrix > 1000 & ReducedDim < dimMatrix/10  % using eigs to speed up!
    option = struct('disp',0);
    [eigvector, eigvalue] = eigs(ddata,ReducedDim,'la',option);
    eigvalue = diag(eigvalue);
else
    [eigvector, eigvalue] = eig(ddata);
    eigvalue = diag(eigvalue);

    [junk, index] = sort(-eigvalue);
    eigvalue = eigvalue(index);
    eigvector = eigvector(:, index);
end
    
clear ddata;
maxEigValue = max(abs(eigvalue));
eigIdx = find(abs(eigvalue)/maxEigValue < 1e-12);
eigvalue (eigIdx) = [];
eigvector (:,eigIdx) = [];



if ReducedDim < length(eigvalue)
    eigvalue = eigvalue(1:ReducedDim);
    eigvector = eigvector(:, 1:ReducedDim);
end


if isfield(options,'PCARatio')
    sumEig = sum(eigvalue);
    sumEig = sumEig*options.PCARatio;
    sumNow = 0;
    for idx = 1:length(eigvalue)
        sumNow = sumNow + eigvalue(idx);
        if sumNow >= sumEig
            break;
        end
    end
    eigvector = eigvector(:,1:idx);
end

elapse = cputime - tmp_T;
