function [value] = area_RP(recall, precision)

if(recall(1)~=0)
    xx = [0,recall'];
    yy = [precision(1), precision'];
else
    xx = [recall'];
    yy = [precision'];
end
[xx, index] = unique(xx);
yy = yy(index);
for iii = 1:length(xx)
    ic = length(xx)-iii+1;
    if(yy(ic) >= 0)
        % nothing
    else
        yy(ic) = yy(ic+1);
    end
    
end
area = 0;
for i=1:(length(xx)-1)
    subarea = 0.5*(xx(i+1)-xx(i))*(yy(i+1)+yy(i));
    area = area+subarea;
end
value = area;