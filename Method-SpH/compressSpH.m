function [B_trn, B_tst] = compressSpH(X, SpHparam)

% input:
%          X: n*d, n is the number of database samples
%          SpHparam:  
%              SpHparam.nbits---encoding length
%              SpHparam.centers---spherical centers
%              SpHparam.radii---spherical radii
% output:
%          B_trn: compacted binary code of training samples
%          B_tst: compacted binary code of test samples

ntrain =SpHparam.ntrain;
xData = X;
centers = SpHparam.centers;
radii = SpHparam.radii;

% compute distances from centers
dData = distMat( xData , centers );

% compute binary codes for data points
th = repmat( radii' , size(dData , 1) , 1);
bData = zeros( size(dData) );
bData( dData <= th ) = 1;
bData = compactbit(bData);

B_trn = bData(1: ntrain, :);
B_tst = bData(ntrain+1:end, :);


