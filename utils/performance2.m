function evaluation_info = performance2( groundtruth, D_dist, param )

%function evaluation_info = performance( B_tst, B_db, groundtruth, param )

% 输入: B_tst 测试样本哈希值 n*bits
%           B_db database所有样本哈希值 n*bits
%           groundtruth 测试样本与database样本相同的标记
%           param.pos position
%           param.nbits 编码位长度
% 输出: evaluation_info
%           

[test_num, Ntrain] = size(groundtruth);

%test_num = size(B_tst, 1); %测试样本数
pos = param.pos; % position
poslen = length(pos); % position的长度
label_r = zeros(1, poslen); % label recall
label_p = zeros(1, poslen); % label precision
label_ar = zeros(1, poslen); % label average recall
label_ahd = zeros(1, poslen); % label average distance
label_ap = zeros(1, 1); % label average precision
label_ph2 = zeros(1, 1); % label hamming distance 2
label_hlr = zeros(1,1);
%D_dist =  hammingDist(B_tst,B_db); % 计算各测试样本与database中样本的汉明距离
parfor n = 1:test_num % 开启并行
%for n = 1:test_num % 开启并行
    % compute your distance
    D_code = D_dist(n,:);%hammingDist(B_tst(n,:),B_db); 第n个测试样本与database中样本的汉明距离
    D_truth = find(groundtruth(n,:)>0);%ground truth 第n个样本database中的groundtruth (所在列号)
    
    [P, R, AR, AHD, AP, PH2] = precall2(D_code, D_truth, pos);
    %[P, R] = precall2(D_code, D_truth, pos);
    
    label_r = label_r + R(1:poslen);
    label_p = label_p + P(1:poslen);
    label_ar = label_ar + AR(1:poslen);
    label_ahd = label_ahd + AHD(1:poslen);
    label_ap = label_ap + AP;
    label_ph2 = label_ph2 + PH2;
    label_hlr = label_hlr + (PH2>0);
end
%[hr, hp]= recall_precision(groundtruth, D_dist, param.nbits);
%evaluation_info.hrecall =  hr;
%evaluation_info.hprecision =  hp;
evaluation_info.recall=label_r/test_num;
evaluation_info.precision=label_p/test_num;
evaluation_info.AR=label_ar/test_num;
evaluation_info.AHD=label_ahd/test_num;
evaluation_info.AP=label_ap/test_num;
evaluation_info.PH2=label_ph2/test_num;
evaluation_info.HLR=label_hlr/test_num;
%evaluation_info.param=param;