function [recall, precision] = main(X, bit, method)
%
% demo code for generating small code and evaluation
% input X should be a n*d matrix, n is the number of images, d is dimension
% ''method'' is the method used to generate small code
% ''method'' can be 'ITQ', 'RR', 'LSH' and 'SKLSH' 

% parameters
averageNumberNeighbors = 50;    % ground truth is 50 nearest neighbor
num_test = 1000;                % 1000 query test point, rest are database


% split up into training and test set
[ndata, D] = size(X);
R = randperm(ndata); % get the index
Xtest = X(R(1:num_test),:);  % Let the first 1000 datapoints in the index as the test sample
R(1:num_test) = [];
Xtraining = X(R,:);   % The remaining datapoints as the training samples
num_training = size(Xtraining,1);
clear X;

% define ground-truth neighbors (this is only used for the evaluation):
R = randperm(num_training);
DtrueTraining = distMat(Xtraining(R(1:100),:),Xtraining); % sample 100 points to find a threshold
Dball = sort(DtrueTraining,2);
clear DtrueTraining;
Dball = mean(Dball(:,averageNumberNeighbors)); % get the 50th column and averaging
% scale data so that the target distance is 1
Xtraining = Xtraining / Dball;
Xtest = Xtest / Dball;
Dball = 1;
% threshold to define ground truth
DtrueTestTraining = distMat(Xtest,Xtraining);
WtrueTestTraining = DtrueTestTraining < Dball;
clear DtrueTestTraining


% generate training ans test split and the data matrix
XX = [Xtraining; Xtest];
% center the data, VERY IMPORTANT
sampleMean = mean(XX,1);
XX = (double(XX)-repmat(sampleMean,size(XX,1),1));


%several state of art methods
switch(method)
    
    % ITQ method proposed in CVPR11 paper
    case 'ITQ'
        fprintf('# method: ITQ\r');
        % PCA
        [pc, l] = eigs(cov(XX(1:num_training,:)),bit);% Get the projection matrix
        XX = XX * pc;  % PCA
        % ITQ
        [Y, R] = ITQ(XX(1:num_training,:),50);   % 50 is the iteration number, R is the final rotation matrix
        XX = XX*R;      % rotate the dataset after PCA
        Y = zeros(size(XX));
        Y(XX>=0) = 1;
        Y = compactbit(Y>0);
    % RR method proposed in  CVPR11 paper
    case 'RR'
        fprintf('# method: RR\r');
        % PCA
        [pc, l] = eigs(cov(XX(1:num_training,:)), bit);
        XX = XX * pc;
        % RR
        R = randn(size(XX,2),bit);
        [U S V] = svd(R);
        XX = XX*U(:,1:bit);
        Y = compactbit(XX>0);
   % SKLSH
   % M. Raginsky, S. Lazebnik. Locality Sensitive Binary Codes from
   % Shift-Invariant Kernels. NIPS 2009.
    case 'SKLSH' 
        fprintf('# method:SKLSH\r');
        RFparam.gamma = 1;
        RFparam.D = D;
        RFparam.M = bit;
        RFparam = RF_train(RFparam);
        B1 = RF_compress(XX(1:num_training,:), RFparam);
        B2 = RF_compress(XX(num_training+1:end,:), RFparam);
        Y = [B1;B2];
    % Locality sensitive hashing (LSH)
     case 'LSH'
         fprintf('# method:LSH\r');
        XX = XX * randn(size(XX,2),bit);% randn(size(XX,2),bit) generate w,w is a 320*24 matrix
        Y = zeros(size(XX));
        Y(XX>=0)=1;    % the original dataset has centerd, so the threshold is 0
        Y = compactbit(Y);
end

% compute Hamming metric and compute recall precision
B1 = Y(1:size(Xtraining,1),:);        % the training samples after encoding
B2 = Y(size(Xtraining,1)+1:end,:);    % the test sample after encoding
Dhamm = hammingDist(B2, B1);
[recall, precision, rate] = recall_precision(WtrueTestTraining, Dhamm);