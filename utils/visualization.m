function retrieved_list = visualization(Dhamm, ID, numRetrieval, train_data, test_data)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

train_ID = ID.train;
test_ID = ID.test;
query_ID = ID.query;
clear ID;
queryDhamm = Dhamm(query_ID, :);
ID_Dhamm= [train_ID; queryDhamm]';
[ID_rankDhamm, index]= sortrows(ID_Dhamm, 2);
query_trueID = test_ID(query_ID);
true_candidate = ID_rankDhamm(1:numRetrieval, :);

disQueryTraining = distMat(test_data(query_ID, :), train_data(index(1:numRetrieval, :), :));

list = [double(true_candidate(:, 1)) disQueryTraining'];

tmp_list = sortrows(list, 2);

retrieved_list = [query_trueID; tmp_list(:, 1)];

end

