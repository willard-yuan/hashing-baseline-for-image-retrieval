addpath(genpath('.'));

%% open matlabpool for faster computation in CBE-opt
%matlabpool

%% some toy data for verifying the code
X = importdata('toy.mat');
X_normalized = normalization(X, 'l2');

%% parameters
method = {'ITQ' , 'SITQ', 'SKLSH', 'LSH' , 'BITQ-rand', 'BITQ-opt', 'CBE-rand', 'CBE-opt'};
bit = 256;
para = {};
for i = 1:length(method)
    para{i}.bit = bit;
end
para{8}.iter = 10;

%% generating binary code and test
res = getResult(X_normalized, method, para);
drawFigure(method, res);