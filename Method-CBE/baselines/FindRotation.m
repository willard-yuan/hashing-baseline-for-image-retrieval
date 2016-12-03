function [B,R] = FindRotation(X, bit)


UX = randn(size(X,1),bit);
UX = sign(UX);
UX(UX<=0)=0;
UX = normalize(UX);


% optimization
for i=1:1
    % find rotation
    C = UX' * X;
    [UB,~,UA] = svds(double(C),bit);
    %[UB,~,UA] = lansvd(double(C),bit,'L');
    
    R = UA * UB';

    % find B
    Z = X*R;
    UX = ones(size(Z)).*0;
    for j=1:size(Z,1)
        [b] = findBestBinary(Z(j,:));
        UX(j,:) = b./sqrt(sum(b));
    end
end

B = UX;