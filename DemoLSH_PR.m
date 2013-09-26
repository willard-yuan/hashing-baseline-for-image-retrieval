%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Function: This is a geometric illustration of LSH recall & precision using
%different code length
%curves along with the code length changes 
%Author: Willard (Yuan Yong' English Name)
%Date: 2013-07-22
%Last Modified:2013-09-26
%My HomePage: www.yuanyong.org
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

close all;
clear variables;
clc;
load cifar_10yunchao.mat;
X=cifar10;
X=X(:,1:end-1);

%Get the recall & precision using LSH of different code length
[recall{1,1}, precision{1,1}] = main(X, 16, 'LSH');
[recall{1,2}, precision{1,2}] = main(X, 24, 'LSH');
[recall{1,3}, precision{1,3}] = main(X, 32, 'LSH');
[recall{1,4}, precision{1,4}] = main(X, 64, 'LSH');
[recall{1,5}, precision{1,5}] = main(X, 128, 'LSH');

% Draw the plot
figure; hold on;grid on;
plot(recall{1, 1}, precision{1, 1},'g-^','linewidth',2);
plot(recall{1, 2}, precision{1, 2},'b-s','linewidth',2);
plot(recall{1, 3}, precision{1, 3},'k-p','linewidth',2);
plot(recall{1, 4}, precision{1, 4},'m-d','linewidth',2);
plot(recall{1, 5}, precision{1, 5},'r-o','linewidth',2);
xlabel('Recall');
ylabel('Precision');
legend('LSH-16 bit','LSH-24 bit','LSH-32 bit','LSH-64 bit','LSH-128 bit','Location','NorthEast');