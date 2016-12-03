function [b] = findBestBinary(x)

b = zeros(1,length(x));
s = 0;
[aa,bb] = sort(x,'descend');
dis = zeros(1,length(x));
for i=1:length(x)
    if(aa(i)==0)
        break;
    end
    s = s + aa(i);
    dis(i) = (s)/sqrt(i);
end
[c,d] = max(dis);
b(bb(1:d)) = 1;














