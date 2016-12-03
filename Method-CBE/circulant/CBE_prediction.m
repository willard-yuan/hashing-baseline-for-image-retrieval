function B = CBE_prediction(model, X)
% compute CBE with fft and ifft
% for real-world application, convert B to bool

% flipping the signs, this could be optimized
for i = 1:size(X,1)
    X(i,:) = X(i,:).*model.bernoulli; 
end

r = model.r;

fft_r = fft(r).';
fft_X = fft(X, [], 2);

fft_B = zeros(size(fft_X));

% compute fft_B one by one (memory saving)
for i = 1:size(fft_X,1)
   fft_B(i,:) = fft_X(i,:) .* fft_r;
end 

%fft_B = fft_X*diag(fft_r); % a N by d matrix

B_time = ifft(fft_B,[], 2);
B_time = real(B_time);
B = zeros(size(B_time));
B(B_time>=0) = 1;
B(B_time<0) = -1;

end