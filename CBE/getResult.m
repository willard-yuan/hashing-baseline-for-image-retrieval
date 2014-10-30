function res =  getResult(X, method, para)

%X = normalize(center(X));
%X(isnan(X)) = 0;

num_test = 500;    % 500 query test point, rest are database

% split up into training arend test set
ndata = size(X,1);
R = randperm(ndata);
Xtest = X(R(1:num_test),:);
R(1:num_test) = [];

if (length(R) > 10000)
    R = R(1:10000);
end
Xtraining = X(R,:);
clear X;

% threshold to define ground truth
kkk=10;
DtrueTestTraining = dist_mat(Xtest,Xtraining);
WtrueTestTraining = zeros(size(DtrueTestTraining));
for i=1:size(WtrueTestTraining,1)
    [~,b] = sort(DtrueTestTraining(i,:));
    WtrueTestTraining(i,b(1:kkk))=1;
end

%clear DtrueTestTraining Xtraining Xtest;
clear DtrueTestTraining;

res = [];
for i = 1:length(method)
    disp(method{i});
    res(i,:) = test_all_methods(Xtraining, Xtest, WtrueTestTraining, para{i}, method{i});
end

end

