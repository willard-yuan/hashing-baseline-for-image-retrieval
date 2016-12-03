function [R1,R2] = BilinearITQ_low(X, b1, b2, iter)

% Implements the reduced dimensional bilinear rotation method.
% Yunchao Gong.

[R1,~,~] = svd(randn(size(X,1)));
[R2,~,~] = svd(randn(size(X,2)));
R1 = R1(:,1:b1);
R2 = R2(:,1:b2);

for i=1:iter
    % fix R1 and R2, update B
    BB = zeros(b1, b2, size(X,3));
    for j=1:size(X,3)
        BB(:,:,j) = sign1(R1'*X(:,:,j)*R2);
    end
    
    % fix R1, rotate R2 first
    X1 = zeros(b1*size(X,3), size(X,2));
    for j=1:size(X,3)
        X1((j-1)*b1+1:j*b1,:) = R1'*X(:,:,j);
    end
        
    B1 = zeros(b1*size(X,3), b2);
    for j=1:size(X,3)
        B1((j-1)*b1+1:j*b1,:) = BB(:,:,j);
    end
    
    [UB,sigma,UA] = svds(double(B1'*X1),b2);
    R2 = UA * UB';

    % fix R2, rotate R1 first
    X2 = zeros(size(X,1), b2*size(X,3));
    for j=1:size(X,3)
        X2(:,(j-1)*b2+1:j*b2) = X(:,:,j)*R2;
    end
    
    B2 = zeros(b1,b2*size(X,3));
    for j=1:size(X,3)
        B2(:,(j-1)*b2+1:j*b2) = BB(:,:,j);
    end

    [UB,sigma,UA] = svds(double(B2*X2'),b1);
    R1 = UA * UB';
end











