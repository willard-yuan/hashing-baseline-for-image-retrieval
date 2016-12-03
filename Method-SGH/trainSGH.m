% trainSGH(XTrain,bases,bit)
% SGH procedure
% Input:
%   XTrain: training data matrix(nxd), where n is number of the training data points
%   and d is the dimension of each data point.
%   bases: kernel bases which randomly sample from training data.
%   bit: number of bit.
% Output:
%   Wx: Projection matrix.
%   KXTrain: Kernel contruction from training data.
%   para: parameter about kernel construction. Please utilize this para to construct
%       kernel for testing data. Including delta and bias.
function [Wx,KXTrain,para] = trainSGH(XTrain,bases,bit)
num_training = size(XTrain,1);

%% Construct PX and QX
FnormX = sum(XTrain.*XTrain,2);
rho = 2;
FnormX = exp(-FnormX/rho);
alpha = sqrt(2*(exp(1)-exp(-1))/rho);
part = bsxfun(@times,alpha*XTrain,FnormX);
PX = [part,sqrt(exp(1)+exp(-1))*FnormX, 1*ones(num_training,1)];
QX = [part,sqrt(exp(1)+exp(-1))*FnormX,-1*ones(num_training,1)];
clear FnormX part;

%% Construct Kernel
% construct KXTrain
KTrain = distMat(XTrain,bases);
KTrain = KTrain.*KTrain;
delta = mean(mean(KTrain,2));
KTrain = exp(-KTrain/(2*delta));

bias = mean(KTrain);
KXTrain = KTrain-repmat(bias,num_training,1);

para.delta = delta;
para.bias = bias;

fprintf('bit:%d\n',bit);
%% Training
% Sequential learning algorithm to learn Wx
[Wx] = trainSGH_seq(KXTrain,PX,QX,bit);
end