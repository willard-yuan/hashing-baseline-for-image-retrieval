function exp_data = construct_data(db_name, db_data, param)

% 1,000 data points are random selected from the whole data set 
% as the queries, and the remaining is used to form the gallery database
% and treated as the targets for search. A nominal threshold of the average 
% distance to the 50th nearest neighbor is used to determine whether a 
% database point returned for a given query is considered a true positive.

addpath('./utils/');

choice = param.choice;
% parameters
averageNumberNeighbors = 50;    % ground truth is 50 nearest neighbor

% construct data
fprintf('starting construct %s database\n\n', db_name);

if strcmp(db_name, 'gist_320d_CIFAR-10_yunchao')
    num_test = 1000;                % for cifar10, 1000 query test point, rest are database
elseif strcmp(db_name, 'gist_512d_CIFAR-10')
    num_test = 1000;                
elseif strcmp(db_name, 'gist_512d_Caltech-256')
    num_test = 1000;                
elseif strcmp(db_name, 'cnn_1024d_Caltech-256')
    num_test = 1000;                
end


% split up into training and test set
[ndata, D] = size(db_data);
switch(choice)
    case 'visualization'
        s = RandStream('mt19937ar','Seed',0);
        R = randperm(s, ndata);
    case 'evaluation'
        R = randperm(ndata);       
end
test_data = db_data(R(1:num_test), :);
test_ID = R(1:num_test);
R(1: num_test) = [];
train_data = db_data(R, :);
train_ID = R;
num_training = size(train_data, 1);

% define ground-truth neighbors (this is only used for the evaluation):
R = randperm(num_training); 
DtrueTraining = distMat(train_data(R(1:100), :), train_data); % sample 100 points to find a threshold
Dball = sort(DtrueTraining, 2);    %DtrueTraining sort by row
clear DtrueTraining;
Dball = mean(Dball(:, averageNumberNeighbors));

% scale data so that the target distance is 1
train_data = train_data / Dball;
test_data = test_data / Dball;
Dball = 1;

% threshold to define ground truth
DtrueTestTraining = distMat(test_data, train_data);
WtrueTestTraining = DtrueTestTraining < Dball;
clear DtrueTestTraining;

% generate training ans test split and the data matrix
XX = [train_data; test_data];

% center the data, VERY IMPORTANT
sampleMean = mean(XX,1);
XX = (double(XX)-repmat(sampleMean,size(XX,1),1));

% normalize the data
XX_normalized = normalize1(XX);

exp_data.train_data = XX(1:num_training, :);
exp_data.test_data = XX(num_training+1:end, :);
exp_data.db_data = XX;

exp_data.train_data_norml = XX_normalized(1:num_training, :);
exp_data.test_data_norml = XX_normalized(num_training+1:end, :);
exp_data.db_data_norml = XX_normalized;

exp_data.train_ID = train_ID;
exp_data.test_ID = test_ID;

exp_data.WTT = WtrueTestTraining;

cons_data_name = ['pre_' db_name  '.mat'];
save(cons_data_name, 'exp_data');


fprintf('constructing %s database has finished\n\n', db_name);