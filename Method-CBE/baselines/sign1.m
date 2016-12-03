function [X] = sign1(X)

B = -1*ones(size(X));
B(X>=0)=1;
X = B;