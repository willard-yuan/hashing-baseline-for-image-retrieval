function X = normalization(X, mode)

if (nargin == 1)
    mode = 'l2';
end

switch (mode)
    case 'gaussian'
        % gaussian normalization for each feature dimension
        for i = 1:size(X,2)
            X(:,i) = (X(:,i) - mean(X(:,i))) ./ std(X(:,i));
        end
        X(isnan(X)) = 0;
        % zero center each data point, l2 normalization
        % such normalization is common for image pixels
        for i = 1:size(X,1)
            X(i,:) = X(i,:) - mean(X(i,:));
            X(i,:) = X(i,:)./norm(X(i,:),2);
        end
        
    case 'l2'
        % zero center each column
        % imporatnt according to ITQ
        for i = 1:size(X,2)
           X(:,i) = X(:,i) - mean(X(:,i));
        end
        X(isnan(X)) = 0;
        % l2 normalization
        for i = 1:size(X,1)
            X(i,:) = X(i,:)./norm(X(i,:),2);
        end
end
X(isnan(X)) = 0;

% randonly permutate the dimensions following bilinear ITQ
% note that we should not do this for temporal data as the order contains
% information
rr = randperm(size(X,2));
X = X(:,rr);


end