function [ p, r, apM, ahd,ap, ph2 ] = precall2(score,truth, M)

% 输入: score 将样本与database的汉明距离作为score
%           truth 样本在database中groundtruth (列号)
%           M 即position

%%% number of true samples
num_truesamples=length(truth);
%%% number of samples
numds=length(score);

%%% score is the computed hamming distance
[sorted_val, sorted_ind]=sort(score); % 将传进来的汉明距离小大排序, sorted_val为排序后的距离
sorted_truefalse=ismember(sorted_ind, truth);  % 判断sorted_ind中的元素有没有在truth里,在就为1，不在为0
 
% for i_M=1:length(M)
%     Hamm_M(i_M) = find(sorted_val<=sorted_val(M(i_M)), 1, 'last');
% end
Hamm_M = M;

for i_M=1:length(M)
    ahd(i_M)=mean(sorted_val(:,1:M(i_M))); % average hamming distance 计算在不同的position下平均汉明距离
end
    
truepositive=cumsum(sorted_truefalse); % 计算有多少是和查询样本是同一类的累加值
for i_M=1:length(M)
    apM(i_M)=truepositive(M(i_M))/M(i_M);
end

% hd2_ind=find(score<=2);%hamming distance < 2
% if isempty(hd2_ind)
%     ph2=0;
% else
%     ph2=sum(ismember((hd2_ind), truth))/length(hd2_ind);
% end

hd2_ind=find(sorted_val<=2, 1, 'last');%score<=2);%hamming distance < 2
if isempty(hd2_ind)
    ph2 = 0;
else
    ph2 = truepositive(hd2_ind)/hd2_ind;
end
r=truepositive(Hamm_M)/num_truesamples; % 计算在position位置处的召回率
p=truepositive(Hamm_M)./(Hamm_M);%[1:numds]; % 计算在position处的准确率
%ap = apcal2(score,truth);
idx = find(sorted_truefalse>0);
if(isempty(idx))
  ap = 0;
else
  ap = mean(truepositive(idx)./idx);
end
