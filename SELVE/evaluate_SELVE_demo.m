%function SELVE_demo(dataset, bit)

%% example: clear;clc;TIP_demo('data', 12);
%  dataset: ins * fea
%  bit: the number of bit

clear all;
load ./data/data.mat;

bit = 32;
            
[n,dim] = size(traindata);
tn = size(testdata,1);


s = 2;   %number of nearest anchors, please tune this parameter on different datasets
lambda = 0.1;
beta = 0.5;
RedDim = 300;  % the left dimensions of original data
m = 300;       % the number of landmark


kmMaxIter = 10;
kmNumRep = 1;
[label,anchor] = litekmeans(traindata,m,'MaxIter',kmMaxIter,'Replicates',kmNumRep);
clear kmMaxIter kmNumRep;

temptraindata = zeros(size(traindata,1),size(traindata,2));
tempanchor = zeros(m,size(traindata,2));
totalnum = 0;

for i=1:length(unique(label))
    tempnum = find(label == i);
    temptraindata(totalnum +1: totalnum + length(tempnum),:) = traindata(tempnum,:);
    tempanchor(totalnum +1:totalnum + length(tempnum),:) = repmat(anchor(i,:),length(tempnum),1);
    totalnum = totalnum + length(tempnum);
end
Gamma = temptraindata - tempanchor;  % ins * fea
GtG = Gamma'*Gamma;
clear temptraindata tempanchor Gamma tempnum totalnum;

%% searching for transformation matrix
XtX = traindata'*traindata;


[B1, tempResults, sigma, M, Anchor] = TIP_train(traindata, anchor,label,bit, s, 0, lambda,beta,m,XtX,GtG,RedDim);
ReduTestdata = testdata* M;
clear M;
B2 = TIP_test(ReduTestdata, Anchor, lambda, s, sigma,tempResults);
clear tempResults ReduTestdata;

B1 = compactbit(B1);
B2 = compactbit(B2);
Dhamm = hammingDist(B1,B2);

[recall, precision, ~] = recall_precision(WtrueTestTraining, Dhamm);

%% Evaluation MAP
MAP = evaluate(B1, B2, traingnd, testgnd);
clear B1 B2;