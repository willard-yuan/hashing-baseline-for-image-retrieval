function DSHparam = trainDSH(X, DSHparam)
%function [model, B, elapse] = trainDSH(X, maxbits)
% DSH_learn: Training process in Density Sensitive Hashing
%
%     [model, B, elapse] = DSH_learn(X, maxbits)
%
%             Input:
%                 X - Data matrix. Each row vector of data is a sample vector. The data should be normalized and centralized to have zero mean before.
%           maxbits - Code length of hash codes
%
%            Output:
%             model - Struct value in Matlab. The field in model is:
%                        U - The matrix record the projection vectors
%                intercept - The vector record the intercept
%                        B - The binary codes for data points
%                   elapse - The training time        
%
%   Examples:
%
%          load('Flickr1M');
%          [model, TrainCode, TrainTime] = DSH_learn(fTrain, 32); 
%
%   Reference:
%          Yue Lin, Deng Cai and Cheng Li. "Density Sensitive Hashing"
%           
%           
%      version 1.0 -- Feb/2012
%     
%      Written by Yue Lin (linyue29@gmail.com)

%tmp_T = tic;

maxbits = DSHparam.nbits;

alpha = 1.5;
r = 3;
iter = 3;
cluster = round(maxbits * alpha);
[dump U] = litekmeans(X, cluster, 'MaxIter', iter);

[Nsamples, Nfeatures] = size(X);
DSHparam.U = zeros(maxbits, Nfeatures);
DSHparam.intercept = zeros(maxbits, 1);

clusize = zeros(size(U, 1), 1);
for i = 1 : size(U, 1)
    clusize(i) = size(find(dump == i), 1);
end
clusize = clusize ./ sum(clusize(:));

Du = EuDist2(U, U, 0);
Du(logical(eye(size(Du)))) = inf;

Dr = [];
for i = 1 : size(Du, 1) 
    tmp = Du(i, :);
    [tmpsort ind] = sort(tmp);
    tmpsort = tmpsort';
    tot = 0;
    Dr = [Dr; tmpsort(1:r)];
end

Dr = unique(Dr);
bitsize = zeros(size(Dr, 1), 1);
for i = 1 : size(bitsize, 1)
     [id1 id2] = find(Du == Dr(i), 1, 'first');
     tmp1 = (U(id1, :) + U(id2, :)) ./ 2.0;
     tmp2 = (U(id1, :) - U(id2, :))';
     tmp3 = repmat(tmp1, size(U, 1), 1);
     DD = U * tmp2;
     th = tmp3 * tmp2;
     pnum = find(DD > th);
     tmpnum = clusize(pnum);
     num1 = sum(tmpnum);
     num2 = 1 - num1;
     bitsize(i) = min(num1, num2) / max(num1, num2);
end

Dsorts = sort(bitsize, 'descend');
for i = 1 : maxbits
    ids = find(bitsize == Dsorts(i), 1, 'first');
    [id1 id2] = find(Du == Dr(ids), 1, 'first');
    Du(id1, id2) = inf;
    Du(id2, id1) = inf;
    bitsize(ids) = inf;
    DSHparam.U(i, :) = U(id1, :) - U(id2, :);
    DSHparam.intercept(i, :) = ((U(id1, :) + U(id2, :)) / 2.0) * DSHparam.U(i, :)';
    fprintf('DSH: iteration %d has finished\r',iter);
end

res = repmat(DSHparam.intercept', Nsamples, 1); 
%Ym = X * model.U';
%B = (Ym > res);
DSHparam.res = res;

%elapse = toc(tmp_T);
fprintf('DSH training process has finished\r');
end