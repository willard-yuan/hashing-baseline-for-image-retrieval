%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Function: This is a PCA-ITQ demo showing the retrieval sample  
%Author: Willard (Yuan Yong' English Name)
%Date: 2013-07-23
%Last Modified:2013-09-26
%My HomePage: www.yuanyong.org
%Note: The first shown image is the query image, other 129 images
%is the return images.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all;
clc;

% parameters
bit=32;  % Using 32 bits code length
averageNumberNeighbors = 50;    % ground truth is 50 nearest neighbor
num_test = 1000;                % 1000 query test point, rest are database
load cifar_10yunchao.mat;
[ndata, D] = size(cifar10);
Xtraining= double(cifar10(1:59000,1:end-1));  %59k for training
Xtest = double(cifar10(59001:60000,1:end-1));  %1k for test
num_training = size(Xtraining,1);

% generate training ans test split and the data matrix
XX = [Xtraining; Xtest];
% center the data, VERY IMPORTANT
sampleMean = mean(XX,1);
XX = (double(XX)-repmat(sampleMean,size(XX,1),1));

% PCA
[pc, l] = eigs(cov(XX(1:num_training,:)),bit);
XX = XX * pc;

% ITQ
[Y, R] = ITQ(XX(1:num_training,:),50);
XX = XX*R;
Y = zeros(size(XX));
Y(XX>=0) = 1;
Y = compactbit(Y>0);

% compute Hamming metric and compute recall precision
B1 = Y(1:size(Xtraining,1),:);       
B2 = Y(size(Xtraining,1)+1:end,:);    
Dhamm = hammingDist(B2, B1);
[foo, Rank] = sort(Dhamm, 2,'ascend');    %sorted by hamming distance

% Load the CIFAR10 data
load cifar-10-batches-mat/data_batch_1.mat;
data1=data;labels1=labels;clear data labels;
load cifar-10-batches-mat/data_batch_2.mat;
data2=data;labels2=labels;clear data labels;
load cifar-10-batches-mat/data_batch_3.mat;
data3=data;labels3=labels;clear data labels;
load cifar-10-batches-mat/data_batch_4.mat;
data4=data;labels4=labels;clear data labels;
load cifar-10-batches-mat/data_batch_5.mat;
data5=data;labels5=labels;clear data labels;
load cifar-10-batches-mat/test_batch.mat;
data6=data;labels6=labels;clear data labels;
database=[data1 labels1 ;data2 labels2;data3 labels3;data4 labels4;data5 labels5;data6 labels6];
cifar10labels=[labels1;labels2;labels3;labels4;labels5;labels6];
%index=[50002,Rank(2,1:129)]'; % Query image is a ship
index=[59018,Rank(18,1:129)]'; % Query image is a airplane
rank=1;
left=0.005;
botton=0.895;
width=0.08;
height=0.08;

% Show the return images
for i=1:130
    j=index(i,1);
    image1r=database(j,1:1024);
    image1g=database(j,1025:2048);
    image1b=database(j,2049:end-1);
    image1rr=reshape(image1r,32,32);
    image1gg=reshape(image1g,32,32);
    image1bb=reshape(image1b,32,32);
    image1(:,:,1)=image1rr';
    image1(:,:,2)=image1gg';
    image1(:,:,3)=image1bb';
    image1=uint8(image1);
    if(mod(rank,13)~=0)
        hdl1=subplot(10,13,rank,'position',[left+0.07*(mod(rank,13)-1)  botton-0.09*fix(rank/13) width height]);
        imshow(image1);
    else
        hdl1=subplot(10,13,rank,'position',[left+0.07*12  botton-0.09*fix(rank/14) width height]);
        imshow(image1);
    end
    rank=rank+1;
end