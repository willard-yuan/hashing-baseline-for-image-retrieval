function [XX] = TensorFV(X)
    
    % make d = m*n, and m, n as close as possible
    d = size(X,2);
    n = 1: d;
    m = d./n;
    
    idx = find(abs(m - round(m)) > 0.000001);
    m(idx) = [];
    n(idx) = [];
    
    [~, idx] = min(abs(m-n));
    m = m(idx);
    n = n(idx);
    %n = 128;
    %m = size(X,2)/n;

    XX = reshape(X', n, m, size(X,1));













