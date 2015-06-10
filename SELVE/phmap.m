function [ap, ph2] = phmap(score,label,labelvalue)
hd2_ind=find(score<=2);
if isempty(hd2_ind)
    ph2=0;
else
    ph2=sum(label(hd2_ind)==labelvalue)/length(hd2_ind);
end
ap = apcal(score,label,labelvalue);