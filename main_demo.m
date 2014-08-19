% Version control:
%     V1.2 modified date: 2014/08/16---2014/08/
%     V1.1 Last modified date: 2013/09/26
%     V1.0 Initial date: 2013/07/22
% Author:
%     willard-yuan.github.io

close all; clear all; clc;

addpath('./utils/');

nbits = 256;

% load dataset
if ~exist('exp_data.mat', 'file')
    load cifar_10yunchao.mat;
    db_label = cifar10;
    db_data = db_label(:, 1:end-1);
    % construct and save data
    exp_data = construct_data(db_data);
    save('./exp_data.mat', 'exp_data');
else
    load exp_data.mat;
end

hashmethods = { 'itq', 'pcah', 'rr', 'sklsh', 'lsh', 'sh', 'sph', 'dsh'};
nhmethods = length(hashmethods);

for i = 1:nhmethods
    [recall{1, i}, precision{1, i}] = demo(exp_data, nbits, hashmethods{1, i});
end

% plot markers
markers = {'r-o', 'b-o', 'k-o',  'm-o', 'c-o', 'g-o', 'y-o', 'b-p'};

%% show precision vs. recall
figure('Color', [1 1 1]); hold on;
for i = 1: nhmethods
    plot(recall{1, i}, precision{1, i}, markers{i}, 'LineWidth', 2);
end
str_nbits =  num2str(nbits);
xlabel(['recall @ ', str_nbits, ' bits']);
ylabel('precision');
axis square;
legend('PCA-ITQ', 'PCAH', 'PCA-RR', 'SKLSH', 'LSH', 'SH', 'SpH', 'DSH', 'Location', 'best');
box on;
grid on;
hold off;