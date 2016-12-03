function D=dist_mat(P1, P2)

n1 = zeros(1,size(P1,1));
n2 = zeros(1,size(P2,1));
for i=1:size(P1,1)
    n1(i) = norm(P1(i,:));
end
for i=1:size(P2,1)
    n2(i) = norm(P2(i,:));
end
n1 = n1.^2;
n2 = n2.^2;

D = -2*P1*P2';
N = repmat(n1',[1,size(P2,1)]) + repmat(n2,[size(P1,1),1]);
D = D+N;

D = sqrt(D);





