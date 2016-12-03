function [recall, presicion] = recall_precision5(Wtrue, Dhat, pos)
%
% Input:
%    Wtrue = true neighbors [Ntest * Ndataset], can be a full matrix NxN
%    Dhat  = estimated distances
%
% Output:
%
%                  exp. # of good pairs inside hamming ball of radius <= (n-1)
%  precision(n) = --------------------------------------------------------------
%                  exp. # of total pairs inside hamming ball of radius <= (n-1)
%
%                  exp. # of good pairs inside hamming ball of radius <= (n-1)
%  recall(n) = --------------------------------------------------------------
%                          exp. # of total good pairs 

grid = pos;
for i=1:size(Dhat,1)
    [a,b] = sort(Dhat(i,:),'ascend');
    Wtrue(i,:) = Wtrue(i,b);
end
total_good_pairs = sum(Wtrue(:));

for i=1:length(grid)
    g = grid(i);
    retrieved_good_pairs = sum(sum(Wtrue(:,1:g)));
    [row, col] = size(Wtrue(:,1:g));
    total_pairs = row*col;
    recall(i) = retrieved_good_pairs/total_good_pairs;
    presicion(i) = retrieved_good_pairs/total_pairs;
end




