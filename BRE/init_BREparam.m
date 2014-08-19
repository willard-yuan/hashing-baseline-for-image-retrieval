function BREparam = init_BREparam(Xtr, Xtst, BREparam)

Xtr2 = Xtr*BREparam.pcaW;
Xtst2 = Xtst*BREparam.pcaW;
clear Xtr Xtst;

%reconstructive hashing
Ktrain = Xtr2*Xtr2';
Ktest = (Xtst2)*Xtr2';

%set parameters for bre:
BREparam.disp = 0;
BREparam.n = size(Ktrain,1);
BREparam.Ktrain = Ktrain;
BREparam.Ktest = Ktest;
BREparam.hash_size = 50;
hash_inds = zeros(BREparam.hash_size, BREparam.nbits);

for b = 1:BREparam.nbits
    rp = randperm(BREparam.n);
    hash_inds(:,b) = rp(1:BREparam.hash_size)';
end

BREparam.hash_inds = hash_inds;
BREparam.W0 = .001*randn(BREparam.hash_size, BREparam.nbits);
    