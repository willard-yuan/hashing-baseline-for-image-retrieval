function BPHparam = trainBPH( X, BPHparam)
%
% Notation:
% X1: data matrix of View1, each column is a sample vector
% lambda: trade off between different views
% mu: trade off between collective matrix factorization and linean
% projection
% gamma: parameter to control the model complexity


lambda = BPHparam.lambda;
mu = BPHparam.mu;
gamma = BPHparam.gamma;
bits = BPHparam.nbits;
X = X';

%% random initialization
[d, ntrain] = size(X);
V = rand(bits, ntrain);

P = rand(bits, d);
threshold = 0.01;
lastF = 99999999;
iter = 1;

R = randn(bits, bits);
[U11 S2 V2] = svd(R);
R = U11(:, 1: bits);


%% compute iteratively
while (true)
    % update U
    U = X * V' / (V * V' + gamma * eye(bits));
    
    %V = P * X;
    V = V';
    
    Z = V * R;
    UX = ones(size(Z,1),size(Z,2)).*-1;
    UX(Z>=0) = 1;
    
    C = UX' * V;
    [UB, sigma, UA] = svd(C);
    R = UA * UB';
    
    % update V
    %V = (lambda * U' * U + 2 * mu * eye(bits) + gamma * eye(bits)) \ (lambda * U' * X + mu * P * X );
    V = (lambda * U' * U + 2 * mu * eye(bits) + 2*gamma * eye(bits)) \ (lambda * U' * X + mu * P * X+0.01*R'*UX');
    
    %update P
    P = V * X' / (X * X' + gamma * eye(d));
    
    % compute objective function
    norm1 = lambda * norm(X - U * V, 'fro');
    norm2 = 0.01 * norm(UX' - R*V, 'fro');
    norm3 = mu * norm(V - P * X, 'fro');
    norm5 = gamma * (norm(U, 'fro') + norm(V, 'fro') + norm(P, 'fro'));
    currentF= norm1 + norm2+norm3+ norm5;
    %fprintf('\nobj at iteration %d: %.4f\n reconstruction error for collective matrix factorization: %.4f,\n reconstruction error for linear projection: %.4f,\n regularization term: %.4f\n\n', iter, currentF, norm1 , norm3, norm5);
    fprintf('\n obj at iteration %d: %.4f, \n reconstruction error for collective matrix factorization: %.4f, \n reconstruction error for linear projection: %.4f, \n encoding term: %.4f, \n regularization term: %.4f\n\n', iter, currentF, norm1 , norm3, norm2, norm5);
    if (lastF - currentF) < threshold
        fprintf('algorithm converges...\n');
        fprintf('final obj: %.4f\n reconstruction error for collective matrix factorization: %.4f,\n reconstruction error for linear projection: %.4f,\n regularization term: %.4f\n\n', currentF,norm1, norm3, norm5);        
        BPHparam.R = R;
        BPHparam.U = U;
        BPHparam.P = P;
        BPHparam.Y = V;
        return
    end
    iter = iter + 1;
    lastF = currentF;
end