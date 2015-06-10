% Author:
%     github: @willard-yuan
%     yongyuan.name

%method = 'show-in-random';
method = 'show-in-class';

% load cifar-10 dataset
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
database = [data1 labels1; data2 labels2; data3 labels3; data4 labels4; data5 labels5; data6 labels6];
cifar10labels = [labels1; labels2; labels3;labels4; labels5; labels6];

switch(method)
    %% sort in class
    case 'show-in-class'
        [sortedLabels, index] = sort(cifar10labels);
        dataInClass = database(index, :); 
        clear database;
        numShow = 100;
        numInRow = 10;
        numPerClass = 6000;
        I2 = uint8(zeros(33, 33, 3, numShow)); % 32 and 32 are the size of the output image
        for i=1:numInRow
            randID = randi(numPerClass, numInRow, 1);
            index = randID + (i-1)*numPerClass;
            for j=1:length(index)
                image_r=dataInClass(index(j,:),1:1024);
                image_g=dataInClass(index(j,:),1025:2048);
                image_b=dataInClass(index(j,:), 2049:end-1);
                image_rer = reshape(image_r, 32, 32);
                image_rer(:, end+1) = zeros(length(image_rer), 1);
                image_rer(end+1, :) = zeros(1,length(image_rer));
                image_reg = reshape(image_g, 32, 32);
                image_reg(:, end+1) = zeros(length(image_reg), 1);
                image_reg(end+1, :) = zeros(1,length(image_reg));
                image_reb = reshape(image_b, 32, 32);
                image_reb(:, end+1) = zeros(length(image_reb), 1);
                image_reb(end+1, :) = zeros(1,length(image_reb));
                image(:, :,1) = image_rer';
                image(:, :, 2) = image_reg';
                image(:, :, 3) = image_reb';
                image = uint8(image);
                I2(:, :, :, j+(i-1)*numInRow) = image;
            end
        end
        figure('Color', [1 1 1]); hold on;
        montage(I2(:, :, :, :));
        
    %% sort in random
    case 'show-in-random' 
        numInColum = 100;
        numInRow = 100;
        numImg = 60000;
        I2 = uint8(zeros(32, 32, 3, numInRow*numInColum)); % 32 and 32 are the size of the output image
        randID = randi(numImg, numInRow*numInColum, 1);
        for i=1:numInRow
            for j=1:numInColum
                % sort with random
                image_r=database(randID(j+(i-1)*numInColum,:),1:1024);
                image_g=database(randID(j+(i-1)*numInColum,:),1025:2048);
                image_b=database(randID(j+(i-1)*numInColum,:), 2049:end-1);
                
                image_rer=reshape(image_r, 32, 32);
                image_reg=reshape(image_g, 32, 32);
                image_reb=reshape(image_b, 32, 32);
                image(:, :,1)=image_rer';
                image(:, :, 2)=image_reg';
                image(:, :, 3)=image_reb';
                image=uint8(image);
                I2(:, :, :, j+(i-1)*numInColum) = image;
            end
        end
        figure('Color', [1 1 1]); hold on;
        montage(I2(:, :, :, :));      
end