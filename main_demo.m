% Version control:
%     V1.3 2014/08/21
%     V1.2 modified date: 2014/08/16---2014/08/19
%     V1.1 Last modified date: 2013/09/26
%     V1.0 Initial date: 2013/07/22
% Author:
%     willard-yuan.github.io

close all; clear all; clc;

addpath('./utils/');

db_name = 'CIFAR10';

loopnbits = [8 16 32 64 128];

param.pos = [1000:1000:40000];

% load dataset
if ~exist('exp_data.mat', 'file')
    load cifar_10yunchao.mat;
    db_datalabel = cifar10;
    db_data = db_datalabel(:, 1:end-1);
    % construct and save data
    fprintf('starting construct %s database\n\n', db_name);
    fprintf('constructing %s database has finished\n\n', db_name);
    exp_data = construct_data(db_data);
    save('./exp_data.mat', 'exp_data');
else
    load exp_data.mat;
end

%hashmethods = {'FGSM', 'MSH', 'DSH'};
hashmethods = {'PCA-ITQ', 'PCAH', 'PCA-RR', 'SKLSH', 'LSH', 'SH', 'SpH', 'DSH'};
nhmethods = length(hashmethods);

for i =1:length(loopnbits)
    fprintf('======start %d bits encoding======\n\n', loopnbits(i));
    param.nbits = loopnbits(i);
    for j = 1:nhmethods
        [recall{i, j}, precision{i, j}, evaluation_info{i, j}] = demo(exp_data, param, hashmethods{1, j});
    end
end

% save result
save('./final_result.mat', 'precision', 'recall', 'evaluation_info', 'hashmethods', 'nhmethods', 'loopnbits');
load final_result.mat;

% plot attribution
line_width=2;
marker_size=8;
xy_font_size=14;
legend_font_size=10;
title_font_size=xy_font_size;

%% show precision vs. recall , i is the selection of which bits.
figure('Color', [1 1 1]); hold on;
i = 4;
for j = 1: nhmethods
    p = plot(recall{i, j}, precision{i, j});
    color=gen_color(j);
    marker=gen_marker(j);
    set(p,'Color', color)
    set(p,'Marker', marker);
    set(p,'LineWidth', line_width);
    set(p,'MarkerSize', marker_size);
end

str_nbits =  num2str(loopnbits(i));
h1 = xlabel(['recall @ ', str_nbits, ' bits']);
h2 = ylabel('precision');
title(db_name, 'FontSize', title_font_size);
set(h1, 'FontSize', xy_font_size);
set(h2, 'FontSize', xy_font_size);
axis square;
hleg = legend(hashmethods );
set(hleg, 'FontSize', legend_font_size);
set(hleg,'Location', 'best');
box on;
grid on;
hold off;

%% show MAP vs. bits , i is the selection of which bits.
figure('Color', [1 1 1]); hold on;
for i = 1: nhmethods
    MAP = [];
    for j = 1: length(loopnbits)
        MAP = [MAP, evaluation_info{j, i}.AP];
    end
    p = plot(loopnbits, MAP);
    color=gen_color(i);
    marker=gen_marker(i);
    set(p,'Color', color);
    set(p,'Marker', marker);
    set(p,'LineWidth', line_width);
    set(p,'MarkerSize', marker_size);
end

h1 = xlabel('number of bits');
ylabel('mean average precision');
title(db_name, 'FontSize', title_font_size);
set(h1, 'FontSize', xy_font_size);
set(h2, 'FontSize', xy_font_size);
axis square;
xlim([loopnbits(1) loopnbits(end)]);
set(gca, 'xtick', loopnbits);
hleg = legend(hashmethods);
set(hleg, 'FontSize', legend_font_size);
set(hleg, 'Location', 'best');
box on;
grid on;
hold off;