function MFHparam = trainMFH( X1, MFHparam)
%
%SOLVECMFH Summary of this function goes here
% Collective Matrix Factorization Hashing Algorithm
%   minimize_{U1,  P1, Y}    lambda*||X1 - U1 * Y||^2 + 
%      + mu * (||Y - P1 * X1||^2 ) +
%      gamma * (||U1||^2 + ||U2||^2 + ||Y||^2)
% Notation:
% X1: data matrix of View1, each column is a sample vector
% lambda: trade off between different views
% mu: trade off between collective matrix factorization and linean
% projection
% gamma: parameter to control the model complexity


lambda = MFHparam.lambda;
mu = MFHparam.mu;
gamma = MFHparam.gamma;
bits = MFHparam.nbits;
X1 = X1';

%% random initialization
[row, col] = size(X1);
Y = rand(bits, col);
%U1 = rand(row, bits);
P1 = rand(bits, row);
threshold = 0.01;
lastF = 99999999;
iter = 1;

%% compute iteratively
while (true)
		% update U1 and U2
    U1 = X1 * Y' / (Y * Y' + gamma * eye(bits));
    
		% update Y    
    Y = (lambda * U1' * U1 + 2 * mu * eye(bits) + gamma * eye(bits)) \ (lambda * U1' * X1 + mu * P1 * X1 );
    
    %update W1 and W2
    P1 = Y * X1' / (X1 * X1' + gamma * eye(row));
    
    % compute objective function
    norm1 = lambda * norm(X1 - U1 * Y, 'fro');
    norm3 = mu * norm(Y - P1 * X1, 'fro');
    norm5 = gamma * (norm(U1, 'fro') + norm(Y, 'fro') + norm(P1, 'fro'));
    currentF= norm1 + norm3+ norm5;
    fprintf('\nobj at iteration %d: %.4f\n reconstruction error for collective matrix factorization: %.4f,\n reconstruction error for linear projection: %.4f,\n regularization term: %.4f\n\n', iter, currentF, norm1 , norm3, norm5);
    if (lastF - currentF) < threshold
        fprintf('algorithm converges...\n');
        fprintf('final obj: %.4f\n reconstruction error for collective matrix factorization: %.4f,\n reconstruction error for linear projection: %.4f,\n regularization term: %.4f\n\n', currentF,norm1, norm3, norm5);
        MFHparam.U = U1;
        MFHparam.P = P1;
        MFHparam.Y = Y;
        return;
    end
    iter = iter + 1;
    lastF = currentF;
end

