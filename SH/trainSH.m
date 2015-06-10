function SHparam = trainSH(X, SHparam)

% Input:
%          X: features matrix [Nsamples, Nfeatures]
%          SHparam.nbits: umber of bits (nbits do not need to be a multiple of 8)
% Output:
%             SHparam:
%                 SHparam.nbits---encoding length
%                 SHparam.pc---principal component
%                 SHparam.mm---
%                 SHparam.mx---
%                 SHparam.models---
%
% Spectral Hashing
% Y. Weiss, A. Torralba, R. Fergus. 
% Advances in Neural Information Processing Systems, 2008.

[Nsamples, Ndim] = size(X);
nbits = SHparam.nbits;

% algo:
% 1) PCA
npca = min(nbits, Ndim);
%[pc, l] = eigs(cov(X), npca);
pc = SHparam.pcaW;
X = X * pc; % no need to remove the mean
clear SHparam.pacW;


% 2) fit uniform distribution
mn = prctile(X, 5);  mn = min(X)-eps;
mx = prctile(X, 95);  mx = max(X)+eps;


% 3) enumerate eigenfunctions
R=(mx-mn);
maxMode=ceil((nbits+1)*R/max(R));

nModes=sum(maxMode)-length(maxMode)+1;
modes = ones([nModes npca]);
m = 1;
for i=1:npca
    modes(m+1:m+maxMode(i)-1,i) = 2:maxMode(i);
    m = m+maxMode(i)-1;
    fprintf('SH: iteration %d has finished\r',i);
end
modes = modes - 1;
omega0 = pi./R;
omegas = modes.*repmat(omega0, [nModes 1]);
eigVal = -sum(omegas.^2,2);
[yy,ii]= sort(-eigVal);
modes=modes(ii(2:nbits+1),:);

% 4) store paramaters
SHparam.pc = pc;
SHparam.mn = mn;
SHparam.mx = mx;
SHparam.mx = mx;
SHparam.modes = modes;
fprintf('SH training process has finished\r');