function ap = apcal(score,label,labelvalue)
% ap=apcal(score,label)
% average precision (AP) calculation 
% input: 
%  score - 1xn vector 
%  label - 1xn vector
%  labelvalue - value of true positives in the 'label' vector
% output: ap
if length(score)~=length(label)
    error('score and label must be equal length\n');
    pause;
end
[x y]=sort(score);
numds=length(label);
x=0;
p=0;

new_label=zeros(1,numds);
new_label(label==labelvalue)=1;
for i=1:numds
    if new_label(y(i))==1
        x=x+1;
        p=p+x/i;
    end
end

% for i=1:numds
%     if label(y(i))==labelvalue
%         x=x+1;
%         p=p+x/i;
%     end
% end
if p==0
    ap=0;
else
    ap=p/x;
end