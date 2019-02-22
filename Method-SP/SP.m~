%function [R R2] = SP(X, bit, sparsity, n_iter)
function [R R2] = SP(X, SPparam)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Solve:
%   min |XR2'-B|^2 + BETA |XR2'-XR'|^2
%   s.t. R2'R2=I, |R|0<= m
% X: num * dim trianing data matrix. Note in our paper, X is dim * num.
% R and R2: bit * dim projection matrix, R2 is orthogonal and R is sparse
% B: num * bit binary codes
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

bit = SPparam.nbits;
sparsity = SPparam.sparsity;
n_iter = SPparam.iter;


% initialize with a random rotation
dim = size(X, 2);
R = randn(bit, dim);
B = X*R';
t = (B>0);
B(t) = 1;
B(~t) = -1;

% pre compute pca matrix if bit < dim
if(bit < dim)
    [pc, ~] = eigs(cov(X),bit);
    X_pc = X * pc;   
end

fprintf('iteration \n');
beta = 1;
for iter=0:n_iter
    
    % fix B,R, update R2
    Y = (B + beta*X*R')/(1+beta);
    if(bit >= dim)
        R2 = OrthogonalConstrainOpt(X,Y);
    else
        Rtmp = OrthogonalConstrainOpt(X_pc,Y);
        R2 = Rtmp * pc';
    end
    
    % fix B,R2, update R
    R = SparseConstrainOpt(R2, sparsity);
    
    % fix R,R2, update B
    B = X*R2';
    t = (B>0);
    B(t) = 1;
    B(~t) = -1;
end
fprintf('\n');


function R = OrthogonalConstrainOpt(X, Y)
    %%% min |XR'-Y|^2, s.t. R'R=I
    data_dim = size(X,2);
    bit_num = size(Y,2);

    [U Sigma V] = svd(X'*Y);
    if(bit_num >= data_dim)
        V = V(:,1:data_dim);
    else
        U = U(:,1:bit_num);    
    end
    R = V*U';
end

function R = SparseConstrainOpt(R2, sparsity)
    n_total = numel(R2);
    n_nonzero = ceil(n_total * (1-sparsity));
    values = abs(R2(:));
    values = sort(values, 'descend');
    thresh = values(n_nonzero);
    R=R2;
    R(abs(R)<thresh) = 0;
end

end







