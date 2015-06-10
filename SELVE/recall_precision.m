function [recall, precision, rate] = recall_precision(Wtrue, Dhat,  max_hamm)
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
%               exp. # of good pairs inside hamming ball of radius <= (n-1)
%  recall(n) = --------------------------------------------------------------
%                          exp. # of total good pairs 

if(nargin < 3)
    max_hamm = max(Dhat(:));
end
hamm_thresh = min(3,max_hamm);

[Ntest, Ntrain] = size(Wtrue);
total_good_pairs = sum(Wtrue(:));

% find pairs with similar codes
precision = zeros(max_hamm,1);
recall = zeros(max_hamm,1);
rate = zeros(max_hamm,1);

for n = 1:length(precision)
    j = (Dhat<=((n-1)+0.00001));
    
    %exp. # of good pairs that have exactly the same code
    retrieved_good_pairs = sum(Wtrue(j));
    
    % exp. # of total pairs that have exactly the same code
    retrieved_pairs = sum(j(:));

    precision(n) = retrieved_good_pairs/(retrieved_pairs+eps);
    recall(n)= retrieved_good_pairs/total_good_pairs;
    rate(n) = retrieved_pairs / (Ntest*Ntrain);
end

% The standard measures for IR are recall and precision. Assuming that:
%
%    * RET is the set of all items the system has retrieved for a specific inquiry;
%    * REL is the set of relevant items for a specific inquiry;
%    * RETREL is the set of the retrieved relevant items 
%
% then precision and recall measures are obtained as follows:
%
%    precision = RETREL / RET
%    recall = RETREL / REL 

