function [B, SELVEparam] = trainSELVE(traindata, SELVEparam)
%function [Y, tempResults, sigma, P, anchor] = trainSELVE(traindata, anchor,label,r, s, sigma,lambda,beta,m,XtX,GtG,RedDim)

anchor = SELVEparam.anchor;
label = SELVEparam.label;
r = SELVEparam.nbits;
sigma = SELVEparam.sigma;
lambda = SELVEparam.lambda;
beta = SELVEparam.beta;
m = SELVEparam.m;
XtX = SELVEparam.XtX;
RedDim = SELVEparam.RedDim;
GtG = SELVEparam.GtG;
s = SELVEparam.s;


tempSum = beta*GtG - XtX;
clear GtG XtX;

[P Dz]= eigs(tempSum,RedDim);
Xp = traindata * P;
anchor = anchor*P;

%% get Z
[NumIns,NunFea] = size(traindata);
NumAnc = size(anchor,1);
Z = zeros(NumIns,NumAnc);
Dis = sqdist(Xp',anchor');
%clear Anchor;

val = zeros(NumIns,s);
pos = val;
for i = 1:s
    [val(:,i),pos(:,i)] = min(Dis,[],2);
    tep = (pos(:,i)-1)*NumIns+[1:NumIns]';
    Dis(tep) = 1e60;
end
clear Dis;
clear tep;

if sigma == 0
    sigma = mean(val(:,s).^0.5);
end
val = exp(-val/(1/1*sigma^2));
val = repmat(sum(val,2).^-1,1,s).*val; %% normalize
tep = (pos-1)*NumIns+repmat([1:NumIns]',1,s);
Z([tep]) = [val];
Z = sparse(Z);  % Z: ins * fea
clear tep;
clear val;
clear pos;
lamda = sum(Z);
Z = diag(lamda.^-0.5)*Z'; %Z : fea * ins

MaxIter = 10;
Ui = zeros(r,1);

% initialize basis
B = rand(size(Z,1),r)-0.5;
B = B - repmat(mean(B,1), size(B,1),1);
B = B*diag(1./sqrt(sum(B.*B)));

for Iter = 1:MaxIter
    %% fix D_i updata A_i
    invBtBi =inv(B'*B+lambda*eye(size(B,2),size(B,2)));
    T = invBtBi*B'; %T
    beta = lambda*invBtBi*Ui; %\beta
    clear invBtBi
    S = T*Z + repmat(beta,1,size(Z,2));
    S(find(isnan(S)==1)) = 0;
    Ui = mean(S,2);
    
    B = learn_basis(Z, S, 1, B);
end
S = S';
S(find(isnan(S)==1)) = 0;
ZZ = repmat(Ui,1,size(S,1));
tempResults.T = T;
tempResults.beta = beta;
tempResults.Ui = Ui;
Y = double(S>ZZ');

clear SELVEparam.anchor SELVEparam.sigma; 

B = compactbit(Y);

SELVEparam.anchor = anchor;
SELVEparam.tempResults = tempResults;
SELVEparam.sigma = sigma;
SELVEparam.M = P;

