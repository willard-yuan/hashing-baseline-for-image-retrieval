function [B, U] = compressDSH(X, DSHparam)

%function [B, elapse] = compressDSH(X, model)

% DSH_compress: Compress process in Density Sensitive Hashing
%
%     [B, elapse] = DSH_compress(X, model)
%
%             Input:
%                 X - Data matrix. Each row vector of data is a query point.
%             model - Struct value in Matlab. The field in model is:
%                        U - The matrix record the projection vectors
%                intercept - The vector record the intercept
%
%             Output:
%                  B - The binary codes for query points
%             elapse - The compress time 
%
%   Examples:
%
%          [TestCode, TestTime] = DSH_compress(fTest, model); 
%
%   Reference:
%          Yue Lin, Deng Cai and Cheng Li. "Density Sensitive Hashing"
%           
%           
%      version 1.0 -- Feb/2012
%     
%      Written by Yue Lin (linyue29@gmail.com)

[Nsamples, Nfeatures] = size(X);
res = repmat(DSHparam.intercept', Nsamples, 1);

%tmp_T = tic;
U = X * DSHparam.U';
%B = (U > res);
B = compactbit(U > res);
U = (U>0);
%elapse = toc(tmp_T);

end