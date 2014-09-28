% Version control:
%     V1.5 2014/09/28
%     V1.4 2014/09/16
%     V1.3 2014/08/21
%     V1.2 2014/08/16
%     V1.1 2013/09/26
%     V1.0 2013/07/22
% Author:
%     yongyuan.name

close all; clear all; clc;
addpath('./utils/');
db_name = 'CIFAR10';

loopnbits = [128];
query_ID = 15; % query_ID ranges from 1 to 1000 in cifar10 (8 retrieves horse, 13 retrieves car, 15 horses)
param.numRetrieval = 25; % Number of returned retrieval images
param.query_ID = query_ID;
param.choice = 'visualization';

hashmethods = {'PCA-ITQ', 'PCA-RR', 'DSH', 'LSH', 'SKLSH', 'SH', 'PCAH',};
nhmethods = length(hashmethods);

% load dataset
if ~exist('exp_data.mat', 'file')
    load cifar_10yunchao.mat;
    db_datalabel = cifar10;
    db_data = db_datalabel(:, 1:end-1);
    exp_data = construct_data(db_name, db_data);
    save('./exp_data.mat', 'exp_data');
else
    load exp_data.mat;
end

clear db_data db_datalabel cifar10;

for i =1:length(loopnbits)
    fprintf('======start %d bits encoding======\n\n', loopnbits(i));
    param.nbits = loopnbits(i);
    for j = 1:nhmethods
        [~, ~, ~, retrieval_list{i, j}] = demo(exp_data, param, hashmethods{1, j});
    end
end

% show retrieval images
load cifar-10-batches-mat/data_batch_1.mat;
data1=data;
labels1=labels;
clear data labels;
load cifar-10-batches-mat/data_batch_2.mat;
data2=data;
labels2=labels;
clear data labels;
load cifar-10-batches-mat/data_batch_3.mat;
data3=data;
labels3=labels;
clear data labels;
load cifar-10-batches-mat/data_batch_4.mat;
data4=data;
labels4=labels;
clear data labels;
load cifar-10-batches-mat/data_batch_5.mat;
data5=data;
labels5=labels;
clear data labels;
load cifar-10-batches-mat/test_batch.mat;
data6=data;
labels6=labels;
clear data labels;
database=[data1 labels1; data2 labels2; data3 labels3; data4 labels4; data5 labels5; data6 labels6];
cifar10labels=[labels1; labels2; labels3;labels4; labels5; labels6];

figure('Color', [1 1 1]); hold on;

for j = 1: nhmethods
    I2 = uint8(zeros(32, 32, 3, 36)); % 32 and 32 are the size of the output image
    for i=1:(param.numRetrieval+1)
        index=retrieval_list{1, j}(i,1);
        image_r=database(index,1:1024);
        image_g=database(index,1025:2048);
        image_b=database(index, 2049:end-1);
        image_rer=reshape(image_r, 32, 32);
        image_reg=reshape(image_g, 32, 32);
        image_reb=reshape(image_b, 32, 32);
        image(:, :,1)=image_rer';
        image(:, :, 2)=image_reg';
        image(:, :, 3)=image_reb';
        image=uint8(image);
        I2(:, :, :, i) = image;
    end
    h =subplot(2, nhmethods, j);
    queryIm = I2(:, :, :, 1);
    imshow(queryIm);
    t = title('Query image');
    p = get(t,'Position');
    set(t,'Position',[p(1) p(2)+0.3 p(3)])
    clear t p;
    axis equal;
    
    p = get(h, 'pos');
    p(1) = p(1)-0.014 ;
    p(2) = p(2)-0.05 ;
    p(3) = p(3)+0.01 ;
    p(4) = p(4)-0.1 ;
    set(h, 'pos', p);
    clear h p;
    
    h = subplot(2, nhmethods, j+nhmethods);
    p = get(h, 'pos');
    p(1) = p(1)-0.024 ;
    p(3) = p(3)+0.024 ;
    p(4) = p(4)+0.4 ;
    set(h, 'pos', p);
    clear p h;
    montage(I2(:, :, :, 2:param.numRetrieval+1));
    title(hashmethods{j});
end