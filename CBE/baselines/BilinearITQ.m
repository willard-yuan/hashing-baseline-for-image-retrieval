function [B,R1,R2,res] = BilinearITQ(X, iter)

% Implements the full dimensional bilinear rotation method.
% Yunchao Gong.

[R1,~] = qr(randn(size(X,1)));
[R2,~] = qr(randn(size(X,2)));
d1 = size(X,1);
d2 = size(X,2);

res = zeros(1,5);
for i=1:iter
    % Step 1: fix R1 and R2, update B
    BB = zeros(size(X,1),size(X,2),size(X,3),'single');
    for j=1:size(X,3)
        BB(:,:,j) = sign(R1'*X(:,:,j)*R2);
    end
    
    % Step 2: fix R1, rotate R2 first
    X1 = zeros(size(X,1)*size(X,3), size(X,2),'single');
    for j=1:size(X,3)
        X1((j-1)*d1+1:j*d1,:) = R1'*X(:,:,j);
    end

    B1 = zeros(size(X,1)*size(X,3), size(X,2),'single');
    for j=1:size(X,3)
        B1((j-1)*d1+1:j*d1,:) = BB(:,:,j);
    end

    [UB,sigma,UA] = svd(double(B1'*X1));
    R2 = UA * UB';

    % Step 3: fix R2, rotate R1 first
    X2 = zeros(size(X,1), size(X,2)*size(X,3),'single');
    for j=1:size(X,3)
        X2(:,(j-1)*d2+1:j*d2) = X(:,:,j)*R2;
    end

    B2 = zeros(size(X,1),size(X,2)*size(X,3),'single');
    for j=1:size(X,3)
        B2(:,(j-1)*d2+1:j*d2) = BB(:,:,j);
    end
    
    [UB,sigma,UA] = svd(double(B2*X2'));
    R1 = UB * UA';
    R1 = R1';
end

B = zeros(size(X,3),size(X,1)*size(X,2),'single');
for i=1:size(X,3)
    t = B1((i-1)*d1+1:i*d1,:);
    B(i,:) = t(:)';
end




