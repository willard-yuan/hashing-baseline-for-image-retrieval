
function marker=gen_marker(curve_idx)

markers=[];

% scheme
% scheme
markers{end+1}='o';
markers{end+1}='*';
markers{end+1}='d';
markers{end+1}='p';
markers{end+1}='s';
markers{end+1}='h';
markers{end+1}='o';
markers{end+1}='*';
markers{end+1}='o';
markers{end+1}='o';
markers{end+1}='o';
markers{end+1}='o';
markers{end+1}='o';

% markers{end+1}='s';
% markers{end+1}='o';
% markers{end+1}='d';
% markers{end+1}='^';
% markers{end+1}='*';
% markers{end+1}='v';
% markers{end+1}='x';
% markers{end+1}='+';
% markers{end+1}='>';
% markers{end+1}='<';
% markers{end+1}='.';
% markers{end+1}='p';
% markers{end+1}='h';

sel_idx=mod(curve_idx-1, length(markers))+1;
marker=markers{sel_idx};

end
