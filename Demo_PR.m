%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Function: This is a geometric illustration of Draw the Recall Precision Curve
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
bit=32;   %code length

%Get the recall & precision
[recall{1,1}, precision{1,1}] = main(X, bit, 'ITQ');   % method ITQ, the follow is the same
[recall{1,2}, precision{1,2}] = main(X, bit, 'RR');
[recall{1,3}, precision{1,3}] = main(X, bit, 'LSH');
[recall{1,4}, precision{1,4}] = main(X, bit, 'SKLSH');

% Draw the Recall Precision Curve
figure; hold on;grid on;
plot(recall{1, 1}, precision{1, 1},'r-o','linewidth',2);
plot(recall{1, 2}, precision{1, 2},'b-s','linewidth',2);
plot(recall{1, 3}, precision{1, 3},'k-p','linewidth',2);
plot(recall{1, 4}, precision{1, 4},'m-d','linewidth',2);
xlabel('Recall');
ylabel('Precision');
legend('PCA-ITQ','PCA-RR','LSH','SKLSH','Location','NorthEast');