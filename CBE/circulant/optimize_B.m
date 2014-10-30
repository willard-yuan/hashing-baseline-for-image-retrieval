function [B, obj] = optimize_B(fft_r, fft_X, para)

%d = length(fft_r);

lambda = para.lambda;
fft_B = fft_X*diag(fft_r); % a N by d matrix
% fft(X) is column-wise fft fft(X,2) is row-wise fft
B_time = ifft(fft_B,[], 2);
B_time = real(B_time);
B = zeros(size(B_time));
B(B_time>=0) = 1;
B(B_time<0) = -1;
%B = B / sqrt(d); % Jan 22

if (para.bit < length(fft_r))
    B(:, para.bit+1:end) = B(:, para.bit+1:end).*0;
    B_time(:, para.bit+1:end) = B(:, para.bit+1:end);
end

obj = sum(sum((B-B_time).^2));
obj = obj + lambda*sum((real(fft_r).^2 + imag(fft_r).^2 - 1).^2);
end