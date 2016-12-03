function [B, model] = circulant_learning(X, para)
% CBE-opt
% X training data
% model.r optimized circulant vector
% model.bernoulli random bernoulli vector
% B CBE code for X

%N = size(X,1);
d = size(X,2);
rr = randn(1,d);
rr(rr > 0) = 1;
rr(rr <= 0 ) = -1;
% randomly flipping the sign
for i = 1:size(X,1)
    X(i,:) = X(i,:).*rr; 
end
model.bernoulli = rr;


if ~isfield(para, 'bit')
   para.bit = size(X,2); 
end

if ~isfield(para, 'iter')
   para.iter = 500; 
end

if ~isfield(para, 'lambda')
   para.lambda = 1; 
end

if ~isfield(para, 'verbose')
   para.verbose = 0; 
end

% pre-compute the fft of X
fft_X = fft(X,[],2);

% pre-compute m
m = sum(real(fft_X).^2,1)+ sum(imag(fft_X).^2,1);
m = m'/d;

% initilization
if (~isfield(para, 'init_r'))
    r = randn(d,1);
else
    r = para.init_r;
end

fft_r = fft(r);
B = optimize_B(fft_r, fft_X, para);
ops = 100;
obj = inf;
iter = 0;

while(ops > 0.1 && iter <= para.iter)
    fprintf('iteration %d, obj = %f\n', iter, obj);
    if (para.verbose)
        fprintf('obj = %f \n', obj);
        fprintf('obj = %f \n', compute_obj_time(B, X, real(ifft(fft_r)), para.lambda));
        fft_B = fft(B, [], 2);
        fprintf('obj = %f \n', compute_obj_freq(fft_B, fft_X, fft_r, para.lambda));
    end
    
    [fft_r, obj_new] = optimize_R(B, fft_X, fft_r, m, para);
    B = optimize_B(fft_r, fft_X, para);
    ops = obj - obj_new;
    obj = obj_new;  
    iter = iter + 1;
end

r = ifft(fft_r);
r = real(r);
model.r = r;

end


function obj = compute_obj_time(B, X, r, lambda)
   R = circulant(r, 1);
   obj = sum(sum((B - X*R').^2)) + lambda * sum(sum((R'*R - diag(ones(size(R,1), 1))).^2));
end


function obj = compute_obj_freq(fft_B, fft_X, fft_r, lambda)
    d = length(fft_r);
    Z = fft_B - repmat(fft_r.', size(fft_X,1) ,1).*fft_X;
    obj =  1/d * sum(sum(real(Z).^2 + imag(Z).^2));
    obj = obj + lambda*sum((real(fft_r).^2 + imag(fft_r).^2 - 1).^2);
end