function exp_data = construct_data(db_name, db_data)

addpath('./utils/');

% construct data
fprintf('starting construct %s database\n\n', db_name);


% parameters
averageNumberNeighbors = 50;    % ground truth is 50 nearest neighbor
num_test = 1000;                % 1000 query test point, rest are database


% split up into training and test set
[ndata, D] = size(db_data);
R = randperm(ndata);
test_data = db_data(R(1:num_test), :);
test_ID = R(1:num_test);
R(1: num_test) = [];
train_data = db_data(R, :);
train_ID = R;
num_training = size(train_data, 1);

% define ground-truth neighbors (this is only used for the evaluation):
R = randperm(num_training); 
DtrueTraining = distMat(train_data(R(1:100), :), train_data); % sample 100 points to find a threshold
Dball = sort(DtrueTraining, 2); %DtrueTraining sort by row
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


fprintf('constructing %s database has finished\n\n', db_name);