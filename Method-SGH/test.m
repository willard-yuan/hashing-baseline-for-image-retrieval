%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% SGH demo
% This demo gives an example to obtain the binary code of original data by using SGH method.
% XTrain --> BXTrain
% XTest  --> BXTest
% Before you run this demo, please download the tiny dataset and
% preprocess(scale and zero-center)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Load data and set parameters
load('TINY.mat');
% We assume that file 'TINY.mat' contains the variable XTrain and XTest.and
% XTrain and XTest are sampled from original dataset.
% XTrain and XTest must be scaled and centered. (very important)

num_training = size(XTrain,1);
num_testing = size(XTest,1);
bit = 64;
% Kernel parameter
m = 300;
sample = randperm(num_training);
bases = XTrain(sample(1:m),:);

%% Training procedure
[Wx,KXTrain,para] = trainSGH(XTrain,bases,bit);

BXTrain = (KXTrain*Wx > 0);

%% Testing procedure
% construct KXTest
KTest = distMat(XTest,bases);
KTest = KTest.*KTest;
KTest = exp(-KTest/(2*para.delta));
KXTest = KTest-repmat(para.bias,num_testing,1);

BXTest = (KXTest*Wx > 0);
