function [recall, precision] = demo(exp_data, nbits, method)

% input: 
%          data: 
%              data.train_data
%              data.test_data
%              data.db_data
%          nbits: encoding length
%          method: encoding length
% output:
%            recall: recall rate
%            precision: precision rate

train_data = exp_data.train_data;
test_data = exp_data.test_data;
db_data = exp_data.db_data;
WtrueTestTraining = exp_data.WTT;
clear exp_data;

[ntrain, D] = size(train_data);

%several state of art methods
switch(method)
    %% ITQ method proposed in our CVPR11 paper
    case 'itq'
        addpath('./ITQ/');
        addpath('./PCAH/');
		fprintf('......%s start...... \n\n', 'PCA-ITQ');
        ITQparam.nbits = nbits;
        ITQparam =  trainPCAH(db_data, ITQparam);
        ITQparam = trainITQ(train_data, ITQparam);
        [B_trn, ~] = compressITQ(train_data, ITQparam);
        [B_tst, ~] = compressITQ(test_data, ITQparam);
        %[B_db, ~] = compressITQ(db_data, ITQparam);
        clear train_data test_data db_data ITQparam;
    % PCA hashing
    case 'pcah'
        addpath('./PCAH/');
		fprintf('......%s start...... \n\n', 'PCAH');
        PCAHparam.nbits = nbits;
        PCAHparam = trainPCAH(db_data, PCAHparam);
        [B_trn, ~] = compressPCAH(train_data, PCAHparam);
        [B_tst, ~] = compressPCAH(test_data, PCAHparam);
        %[B_db, ~] = compressPCAH(db_data, PCAHparam);
        clear train_data test_data db_data PCAHparam;
    % RR method proposed in  CVPR11 paper
    case 'rr'
        addpath('./RR/');
        addpath('./PCAH/');
		fprintf('......%s start...... \n\n', 'PCA-RR');
        RRparam.nbits = nbits;
        RRparam =  trainPCAH(db_data, RRparam);
        RRparam = trainRR(RRparam);      
        [B_trn, ~] = compressRR(train_data, RRparam);
        [B_tst, ~] = compressRR(test_data, RRparam);
        %[B_db, ~] = compressRR(db_data, RRparam);
        clear train_data test_data db_data RRparam;        
   % SKLSH Locality Sensitive Binary Codes from Shift-Invariant Kernels. NIPS 2009.
    case 'sklsh' 
        addpath('./SKLSH/');
		fprintf('......%s start......\n\n', 'SKLSH');
        RFparam.gamma = 1; 
        RFparam.D = D; 
        RFparam.M = nbits;
        RFparam = RF_train(RFparam);
        B_trn = RF_compress(train_data, RFparam);
        B_tst = RF_compress(test_data, RFparam);
        %B_db = RF_compress(db_data, RFparam);
       clear train_data test_data db_data RFparam; 
    % Locality sensitive hashing (LSH)
     case 'lsh'
        addpath('./LSH/');
		fprintf('......%s start ......\n\n', 'LSH');
        LSHparam.nbits = nbits;
        LSHparam.dim = D;
        LSHparam = trainLSH(LSHparam);
        [B_trn, ~] = compressLSH(train_data, LSHparam);
        [B_tst, ~] = compressLSH(test_data, LSHparam);
        %[B_db, ~] = compressLSH(db_data, LSHparam);
        clear train_data test_data db_data LSHparam;
     % Spetral hashing
     case 'sh'
        addpath('./SH/');
        addpath('./PCAH/');
		fprintf('......%s start...... \n\n', 'SH');
        SHparam.nbits = nbits;
        SHparam =  trainPCAH(db_data, SHparam);
        SHparam = trainSH(train_data, SHparam);
        [B_trn, ~] = compressSH(train_data, SHparam);
        [B_tst, ~] = compressSH(test_data, SHparam);
        %[B_db, ~] = compressITQ(db_data, ITQparam);
     % Spherical hashing
     case 'sph'
        addpath('./SpH/');
		fprintf('......%s start ......\n\n', 'SpH');
        SpHparam.nbits = nbits;
        SpHparam.ntrain = ntrain;
        SpHparam = trainSpH(train_data, SpHparam);
        [B_trn, B_tst] = compressSpH(db_data, SpHparam);
     % Density sensitive hashing
     case 'dsh'
        addpath('./DSH/');
		fprintf('......%s start ......\n\n', 'DSH');
        DSHparam.nbits = nbits;
        DSHparam = trainDSH(train_data, DSHparam);
        [B_trn, ~] = compressDSH(train_data, DSHparam);
        [B_tst, ~] = compressDSH(test_data, DSHparam);
        clear train_data test_data db_data DSHparam;
     % unsupervised sequential projection learning based hashing
     case 'usplh' % it don't work, the result is error.
        addpath('./USPLH/');
		fprintf('......%s start...... \n\n', 'USPLH');
        USPLHparam.nbits = nbits;
        USPLHparam.c_num=2000;%%% %%% this parameter is for the number of pseduo pair-wise labels
        USPLHparam.lambda=0.1;
        USPLHparam.eta=0.125;
        USPLHparam = trainUSPLH(train_data, USPLHparam);
        [B_trn, ~] = compressUSPLH(train_data, USPLHparam);
        [B_tst, ~] = compressUSPLH(test_data, USPLHparam);
        %[B_db, ~] = compressUSPLH(db_data, USPLHparam);
        clear train_data test_data db_data USPLparam;
     case 'bre' % it runs too much slow, and I don't get the result.
        addpath('./BRE/');
        addpath('./PCAH/');
		fprintf('......%s start...... \n\n', 'BRE');
        BREparam.nbits = nbits;
        BREparam =  trainPCAH(db_data, BREparam);
        BREparam = init_BREparam(train_data, test_data, BREparam);
        [H, H_query] = trainBRE(BREparam);
        [B_trn, ~] = compressBRE(H);
        [B_tst, ~] = compressBRE(H_query);
        clear train_data test_data db_data BREparam;
end

% compute Hamming metric and compute recall precision
Dhamm = hammingDist(B_tst, B_trn);
[recall, precision, rate] = recall_precision(WtrueTestTraining, Dhamm);