function [Wx, r] = cca(X,Y,reg)

%
% X is input data for the 1st view (image), n*d, n images, d dim
% Y is input data for the 2nd view (Tag), n*D, D dim
% reg is regularization parameter, usually set by validation
% in our work, reg = 0.0001 which works well
%
% Wx is the embedding function for image
% r is the eigenvalue
%
%
% to run the code, you need visual data X and tag data Y
% 
% bit = 32, 64, 128 ...
% [eigenvector,r] = cca(X, Y, 0.0001); % this computes CCA projections
% eigenvector = eigenvector(:,1:bit)*diag(r(1:bit)); % this performs a scaling using eigenvalues
% E = X*eigenvector; % final projection to obtain embedding E
% 


z = [X, Y];
C = cov(z);
sx = size(X,2);
sy = size(Y,2);
Cxx = C(1:sx, 1:sx) + reg*eye(sx);
Cxy = C(1:sx, sx+1:sx+sy);
Cyx = Cxy';
Cyy = C(sx+1:sx+sy,sx+1:sx+sy) + reg*eye(sy);


Rx = chol(Cxx);
invRx = inv(Rx);
Z = invRx'*Cxy*(Cyy\Cyx)*invRx;
Z = 0.5*(Z' + Z);  


[Wx,r] = eig(Z);   % basis in h (X)
r = sqrt(real(r)); % as the original r we get is lamda^2
Wx = invRx * Wx;   % actual Wx values
r = diag(r);

[r index] = sort(r,'descend');
Wx = Wx(:,index);



