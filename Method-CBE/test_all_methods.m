function recall = test_all_methods(Xtraining, Xtest, WtrueTestTraining, para, method)

% ''method'' is the method used to generate small code
% ''method'' can be
% CBE-opt CBE-rand (Yu et al. ICML 2014)
% BITQ-opt BITQ-rand (Gong et al. CVPR 2013)
% LSH  (Locality Sensitive Hashing)
% ITQ  (Gong et al. CVPR 2011)
% SITQ (Gong et al. NIPS 2012)
% SKLSH(Raginsky and Lazebnik NIPS 2009)
% Note that methods implemented here are for comparing the recall
% not the computational time

if (isfield(para, 'bit'))
    bit = para.bit;
end

train_size = min(size(Xtraining,1), 5000);
d= size(Xtraining, 2);
rand_bit = randperm(d);

switch(method)
    case 'CBE-rand'
        model = circulant_rand(d);
        B1 = CBE_prediction(model, Xtraining);
        B2 = CBE_prediction(model, Xtest);
        if (para.bit < d)
            B1 = B1 (:, rand_bit(1:bit));
            B2 = B2 (:, rand_bit(1:bit));
        end
        B1 = compactbit(B1>0);
        B2 = compactbit(B2>0);
        
    case 'CBE-opt'
        if (~isfield(para, 'lambda'))
            para.lambda = 1;
        end
        if (~isfield(para, 'verbose'))
            para.verbose = 0;
        end
        [~, model] = circulant_learning(double(Xtraining(1:train_size, :)), para);
        B1 = CBE_prediction(model, Xtraining);
        B2 = CBE_prediction(model, Xtest);
        if (para.bit < d)
            B1 = B1 (:, 1:bit);
            B2 = B2 (:, 1:bit);
        end
        B1 = compactbit(B1>0);
        B2 = compactbit(B2>0);
        
    case 'LSH'
        R = randn(size(Xtraining,2), para.bit);
        
        B1 = sign(Xtraining*R);
        B2 = sign(Xtest*R);
        
        B1 = compactbit(B1>0);
        B2 = compactbit(B2>0);
        
    case 'SKLSH'
        RFparam.gamma = 1;
        RFparam.D = size(Xtraining, 2);
        RFparam.M = para.bit;
        RFparam = RF_train(RFparam);
        B1 = RF_compress(Xtraining, RFparam);
        B2 = RF_compress(Xtest, RFparam);
        
    case 'ITQ'
        % PCA
        if (bit < size(Xtraining,2))
            [~,pc] = mixData6(Xtraining(1:train_size,:), bit);
            Xtraining = Xtraining * pc;
            Xtest = Xtest * pc;
        end
        % ITQ
        [~, R] = ITQ(Xtraining(1:train_size,:),5);
        B1 = Xtraining*R;
        B2 = Xtest*R;
        B1 = compactbit(B1>0);
        B2 = compactbit(B2>0);
        
    case 'BITQ-opt' % BITQLOW
        % determine b1 and b2 for bit
        d = bit;
        n = 1: d;
        m = d./n;
        idx = find(abs(m - round(m)) > 0.000001);
        m(idx) = [];
        n(idx) = [];
        [~, idx] = min(abs(m-n));
        b2 = m(idx);
        b1 = n(idx);
        
        XX_train = TensorFV(Xtraining);
        XX_test = TensorFV(Xtest);
        [R1,R2] = BilinearITQ_low(XX_train(:,:,1:train_size), b1, b2, 5);
        
        BB = zeros(b1,b2,size(XX_train,3),'single');
        for j=1:size(XX_train,3)
            BB(:,:,j) = sign(R1'*XX_train(:,:,j)*R2);
        end
        B1 = zeros(size(XX_train,3),b1*b2,'single');
        for i=1:size(XX_train,3)
            t = BB(:,:,i);
            B1(i,:) = t(:)';
        end
        
        BB = zeros(b1,b2,size(XX_test,3),'single');
        for j=1:size(XX_test,3)
            BB(:,:,j) = sign(R1'*XX_test(:,:,j)*R2);
        end
        B2 = zeros(size(XX_test,3),b1*b2,'single');
        for i=1:size(XX_test,3)
            t = BB(:,:,i);
            B2(i,:) = t(:)';
        end
        B1 = compactbit(B1 > 0);
        B2 = compactbit(B2 > 0);
        
    case 'BITQ-rand' % BITQLOW
        % determine b1 and b2 for bit
        d = bit;
        n = 1: d;
        m = d./n;
        idx = find(abs(m - round(m)) > 0.000001);
        m(idx) = [];
        n(idx) = [];
        [~, idx] = min(abs(m-n));
        b2 = m(idx);
        b1 = n(idx);
        XX_train = TensorFV(Xtraining);
        XX_test = TensorFV(Xtest);
        %[R1,R2] = BilinearITQ_low(XX_train(:,:,1:train_size), b1, b2, 5);
        R1 = randn(size(XX_train,1),b1);
        R2 = randn(size(XX_train,2),b2);
        
        BB = zeros(b1,b2,size(XX_train,3));
        for j=1:size(XX_train,3)
            BB(:,:,j) = sign(R1'*XX_train(:,:,j)*R2);
        end
        B1 = zeros(size(XX_train,3),b1*b2);
        for i=1:size(XX_train,3)
            t = BB(:,:,i);
            B1(i,:) = t(:)';
        end
        
        BB = zeros(b1,b2,size(XX_test,3));
        for j=1:size(XX_test,3)
            BB(:,:,j) = sign(R1'*XX_test(:,:,j)*R2);
        end
        B2 = zeros(size(XX_test,3),b1*b2);
        for i=1:size(XX_test,3)
            t = BB(:,:,i);
            B2(i,:) = t(:)';
        end
        B1 = compactbit(B1 > 0);
        B2 = compactbit(B2 > 0);
        
    case 'SITQ'
        % learn the rotation
        [~,R] = FindRotation(Xtraining(1:train_size,:), bit);
        % do the projection
        Z  = Xtraining*R;
        B1 = zeros(size(Z));
        for j=1:size(Z,1)
            [b] = findBestBinary(Z(j,:));
            B1(j,:) = b./sqrt(sum(b));
        end
        
        Z  = Xtest*R;
        B2 = zeros(size(Z));
        for j=1:size(Z,1)
            [b] = findBestBinary(Z(j,:));
            B2(j,:) = b./sqrt(sum(b));
        end
        
        B1 = compactbit(B1 > 0);
        B2 = compactbit(B2 > 0);
end

% compute Hamming metric and compute recall
Dhamm = hammingDist(B2, B1);
recall = recall_precision5(WtrueTestTraining, Dhamm);