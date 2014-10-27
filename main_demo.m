% Version control:
%     V1.5 2014/10/20
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

query_ID = 1;
param.choice = 'evaluation';

loopnbits = [8 16 32 64 128 256];
%loopnbits = [32];
runtimes = 8; % change 8 times to make the rusult more precise

param.pos = [0:1000:10000];

% load dataset
load cifar_10yunchao.mat;
db_datalabel = cifar10;
db_data = db_datalabel(:, 1:end-1);

%hashmethods = {'PCA-ITQ', 'LSH'};
hashmethods = {'PCA-ITQ', 'LSH', 'PCAH', 'SH', 'SKLSH', 'PCA-RR', 'DSH'};
nhmethods = length(hashmethods);

for k = 1:runtimes
    fprintf('The %d run time, start constructing data\n\n', k);
    exp_data = construct_data(db_name, db_data);
    fprintf('Constructing data finished\n\n');
    for i =1:length(loopnbits)
        fprintf('======start %d bits encoding======\n\n', loopnbits(i));
        param.nbits = loopnbits(i);
        param.query_ID = query_ID;
        for j = 1:nhmethods
            [recall{k}{i, j}, precision{k}{i, j}, mAP{k}{i,j}, rec{k}{i, j}, ~] = demo(exp_data, param, hashmethods{1, j});
        end
    end
    clear exp_data;
end

% average MAP
for j = 1:nhmethods
    for i =1: length(loopnbits)
        tmp = zeros(size(mAP{1, 1}{i, j}));
        for k =1:runtimes
            tmp = tmp+mAP{1, k}{i, j};
        end
        MAP{i, j} = tmp/runtimes;
    end
    clear tmp;
end
    

% save result
save('./final_result.mat', 'precision', 'recall', 'MAP', 'mAP', 'hashmethods', 'nhmethods', 'loopnbits');
load final_result.mat;

% plot attribution
line_width=2;
marker_size=8;
xy_font_size=14;
legend_font_size=10;
title_font_size=xy_font_size;

%% show precision vs. recall , i is the selection of which bits.
figure('Color', [1 1 1]); hold on;
i = 1; % i: choose the bits to show
k = 1; % k is the times of run times
for j = 1: nhmethods
    p = plot(recall{k}{i, j}, precision{k}{i, j});
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

%% show recall vs. the number of retrieved sample.
figure('Color', [1 1 1]); hold on;
i = 1;
k = 1;
for j = 1: nhmethods
    p = plot(param.pos, rec{k}{i, j});
    color=gen_color(j);
    marker=gen_marker(j);
    set(p,'Color', color)
    set(p,'Marker', marker);
    set(p,'LineWidth', line_width);
    set(p,'MarkerSize', marker_size);
end

str_nbits =  num2str(loopnbits(i));
h1 = xlabel('the number of retrieved samples');
h2 = ylabel(['recall @ ', str_nbits, ' bits']);
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

%% show mAP. This mAP function is provided by Yunchao Gong
figure('Color', [1 1 1]); hold on;
for j = 1: nhmethods
    map = [];
    for i = 1: length(loopnbits)
        map = [map, MAP{i, j}];
    end
    p = plot(log2(loopnbits), map);
    color=gen_color(j);
    marker=gen_marker(j);
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
set(gca, 'xtick', log2(loopnbits));
set(gca, 'XtickLabel', {'8', '16', '32', '64', '128', '256'});
hleg = legend(hashmethods);
set(hleg, 'FontSize', legend_font_size);
set(hleg, 'Location', 'best');
box on;
grid on;
hold off;