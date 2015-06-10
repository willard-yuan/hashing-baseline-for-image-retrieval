function [recall, precision, mAP, rec, pre, retrieved_list] = demo(exp_data, param, method)
% input: 
%          data: 
%              data.train_data
%              data.test_data
%              data.db_data
%          param:
%              param.nbits---encoding length
%              param.pos---position
%          method: encoding length
% output:
%            recall: recall rate
%            precision: precision rate
%            evaluation_info: 

train_data = exp_data.train_data;
test_data = exp_data.test_data;
db_data = exp_data.db_data;

train_data_norml = exp_data.train_data_norml;
test_data_norml = exp_data.test_data_norml;
db_data_norml = exp_data.db_data_norml;

WtrueTestTraining = exp_data.WTT;
pos = param.pos;

ID.train = exp_data.train_ID;
ID.test = exp_data.test_ID;
ID.query = param.query_ID;

clear exp_data;

[ntrain, D] = size(train_data);

%several state of art methods
switch(method)
    %% ITQ method proposed in CVPR11 paper
    case 'ITQ'
        addpath('./ITQ/');
        addpath('./PCAH/');
		fprintf('......%s start...... \n\n', 'PCA-ITQ');
        ITQparam.nbits = param.nbits;
        ITQparam =  trainPCAH(db_data, ITQparam);
        %ITQparam =  trainPCAH(train_data, ITQparam);
        ITQparam = trainITQ(train_data, ITQparam);
        [B_trn, ~] = compressITQ(train_data, ITQparam);
        [B_tst, ~] = compressITQ(test_data, ITQparam);
        %[B_db, ~] = compressITQ(db_data, ITQparam);
        clear db_data ITQparam;
        
     case 'SELVE'
        addpath('./SELVE/');
		fprintf('......%s start...... \n\n', 'SELVE');
        SELVEparam.nbits = param.nbits;
        SELVEparam = initSELVE(train_data, SELVEparam);
        [B_trn, SELVEparam] = trainSELVE(train_data, SELVEparam);
        reduTest_data = test_data* SELVEparam.M;
        [B_tst, ~] = compressSELVE(reduTest_data, SELVEparam);
        clear db_data SELVEparam;
        
    % PCA hashing
    case 'PCAH'
        addpath('./PCAH/');
		fprintf('......%s start...... \n\n', 'PCAH');
        PCAHparam.nbits = param.nbits;
        PCAHparam = trainPCAH(db_data, PCAHparam);
        [B_trn, ~] = compressPCAH(train_data, PCAHparam);
        [B_tst, ~] = compressPCAH(test_data, PCAHparam);
        %[B_db, ~] = compressPCAH(db_data, PCAHparam);
        clear db_data PCAHparam;
        
    % RR method proposed in  CVPR11 paper
    case 'PCA-RR'
        addpath('./RR/');
        addpath('./PCAH/');
		fprintf('......%s start...... \n\n', 'PCA-RR');
        RRparam.nbits = param.nbits;
        RRparam =  trainPCAH(db_data, RRparam);
        RRparam = trainRR(RRparam);      
        [B_trn, ~] = compressRR(train_data, RRparam);
        [B_tst, ~] = compressRR(test_data, RRparam);
        %[B_db, ~] = compressRR(db_data, RRparam);
        clear db_data RRparam;  
        
   % SKLSH Locality Sensitive Binary Codes from Shift-Invariant Kernels. NIPS 2009.
    case 'SKLSH' 
        addpath('./SKLSH/');
		fprintf('......%s start......\n\n', 'SKLSH');
        RFparam.gamma = 1; 
        RFparam.D = D; 
        RFparam.M = param.nbits;
        RFparam = RF_train(RFparam);
        B_trn = RF_compress(train_data, RFparam);
        B_tst = RF_compress(test_data, RFparam);
        %B_db = RF_compress(db_data, RFparam);
        clear db_data RFparam; 
        
    % Locality sensitive hashing (LSH)
     case 'LSH'
        addpath('./LSH/');
		fprintf('......%s start ......\n\n', 'LSH');
        LSHparam.nbits = param.nbits;
        LSHparam.dim = D;
        LSHparam = trainLSH(LSHparam);
        [B_trn, ~] = compressLSH(train_data, LSHparam);
        [B_tst, ~] = compressLSH(test_data, LSHparam);
        %[B_db, ~] = compressLSH(db_data, LSHparam);
        clear db_data LSHparam;
        
     % Spetral hashing
     case 'SH'
        addpath('./SH/');
        addpath('./PCAH/');
		fprintf('......%s start...... \n\n', 'SH');
        SHparam.nbits = param.nbits;
        SHparam =  trainPCAH(db_data, SHparam);
        SHparam = trainSH(train_data, SHparam);
        [B_trn, ~] = compressSH(train_data, SHparam);
        [B_tst, ~] = compressSH(test_data, SHparam);
        %[B_db, ~] = compressITQ(db_data, ITQparam);
        
     % Spherical hashing
     case 'SpH'
        addpath('./SpH/');
		fprintf('......%s start ......\n\n', 'SpH');
        SpHparam.nbits = param.nbits;
        SpHparam.ntrain = ntrain;
        SpHparam = trainSpH(train_data, SpHparam);
        [B_trn, B_tst] = compressSpH(db_data, SpHparam);
        
     % Density sensitive hashing
     case 'DSH'
        addpath('./DSH/');
		fprintf('......%s start ......\n\n', 'DSH');
        DSHparam.nbits = param.nbits;
        DSHparam = trainDSH(train_data, DSHparam);
        [B_trn, ~] = compressDSH(train_data, DSHparam);
        [B_tst, ~] = compressDSH(test_data, DSHparam);
        clear db_data DSHparam;
     % unsupervised sequential projection learning based hashing
     
    case 'CBE-rand'
        addpath('./CBE/');
        addpath('./CBE/misc_lib/');
        addpath('./CBE/circulant/');
        addpath('./CBE/baselines/');
        CBEparam.nbits = param.nbits;
        rand_bit = randperm(D);
        model = circulant_rand(D);
        B1 = CBE_prediction(model, train_data_norml);
        B2 = CBE_prediction(model, test_data_norml);
        if (CBEparam.nbits < D)
            B1 = B1 (:, rand_bit(1:CBEparam.nbits));
            B2 = B2 (:, rand_bit(1:CBEparam.nbits));
        end
        B_trn = compactbit(B1>0);
        B_tst = compactbit(B2>0);
        
    case 'CBE-opt'
        addpath('./CBE/');
        addpath('./CBE/misc_lib/');
        addpath('./CBE/circulant/');
        addpath('./CBE/baselines/');
        CBEparam.nbits = param.nbits;
        train_size = min(size(train_data,1), 5000);
        if (~isfield(CBEparam, 'lambda'))
            CBEparam.lambda = 1;
        end
        if (~isfield(CBEparam, 'verbose'))
            CBEparam.verbose = 0;
        end
        [~, model] = circulant_learning(double(train_data_norml(1:train_size, :)), CBEparam);
        B1 = CBE_prediction(model, train_data_norml);
        B2 = CBE_prediction(model, test_data_norml);
        if (CBEparam.nbits < D)
            B1 = B1 (:, 1:CBEparam.nbits);
            B2 = B2 (:, 1:CBEparam.nbits);
        end
        B_trn = compactbit(B1>0);
        B_tst = compactbit(B2>0); 
        
     case 'Our Method'
        addpath('./Our Method/');    % your method can be writen here
     
     case 'USPLH' % it don't work, the result is error.
        addpath('./USPLH/');
		fprintf('......%s start...... \n\n', 'USPLH');
        USPLHparam.nbits = param.nbits;
        USPLHparam.c_num=2000;% this parameter is for the number of pseduo pair-wise labels
        USPLHparam.lambda=0.1;
        USPLHparam.eta=0.125;
        USPLHparam = trainUSPLH(train_data, USPLHparam);
        [B_trn, ~] = compressUSPLH(train_data, USPLHparam);
        [B_tst, ~] = compressUSPLH(test_data, USPLHparam);
        %[B_db, ~] = compressUSPLH(db_data, USPLHparam);
        clear db_data USPLparam;
        
     case 'BRE' % it runs too much slow, and I don't get the result.
        addpath('./BRE/');
        addpath('./PCAH/');
		fprintf('......%s start...... \n\n', 'BRE');
        BREparam.nbits = param.nbits;
        BREparam =  trainPCAH(db_data, BREparam);
        BREparam = init_BREparam(train_data, test_data, BREparam);
        [H, H_query] = trainBRE(BREparam);
        [B_trn, ~] = compressBRE(H);
        [B_tst, ~] = compressBRE(H_query);
        clear db_data BREparam;
end

% compute Hamming metric and compute recall precision
Dhamm = hammingDist(B_tst, B_trn);
clear B_tst B_trn;
choice = param.choice;
switch(choice)
    case 'evaluation'
        clear train_data test_data;
        [recall, precision, ~] = recall_precision(WtrueTestTraining, Dhamm);
		[rec, pre]= recall_precision5(WtrueTestTraining, Dhamm, pos); % recall VS. the number of retrieved sample
        [mAP] = area_RP(recall, precision);
        retrieved_list = [];
    case 'visualization'
        num = param.numRetrieval;
        retrieved_list =  visualization(Dhamm, ID, num, train_data, test_data); 
        recall = [];
        precision = [];
        rec = [];
        pre = [];
        mAP = [];
end

end