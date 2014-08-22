function [score, recall] = evaluation(Wtrue, Dhat)
%
% Input:
%    Wtrue = true neighbors [Ntest * Ndataset], can be a full matrix NxN
%    Dhat  = estimated distances
%   The next inputs are optional:
%    fig = figure handle
%    options = just like in the plot command
%
% Output:
%
%               exp. # of good pairs inside hamming ball of radius <= (n-1)
%  score(n) = --------------------------------------------------------------
%               exp. # of total pairs inside hamming ball of radius <= (n-1)
%
%               exp. # of good pairs inside hamming ball of radius <= (n-1)
%  recall(n) = --------------------------------------------------------------
%                          exp. # of total good pairs 

[Ntest, Ntrain] = size(Wtrue);
total_good_pairs = sum(Wtrue(:));

% find pairs with similar codes
score = zeros(100,1);
for n = 1:length(score)
    j = find(Dhat<=((n-1)+0.00001));
    
    %exp. # of good pairs that have exactly the same code
    retrieved_good_pairs = sum(Wtrue(j));
    
    % exp. # of total pairs that have exactly the same code
    retrieved_pairs = length(j);

    score(n) = retrieved_good_pairs/retrieved_pairs;
    recall(n)= retrieved_good_pairs/total_good_pairs;
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

% if nargout == 0 || nargin > 3
%     if isempty(fig);
%         fig = figure;
%     end
%     figure(fig)
%     subplot(211)
%     plot(0:length(score)-1, score, varargin{:})
%     hold on
%     xlabel('hamming radium')
%     ylabel('percent correct (precision)')
%     title('percentage of good neighbors inside the hamm ball')
%     subplot(212)
%     plot(recall, score, varargin{:})
%     hold on
%     axis([0 1 0 1])
%     xlabel('recall')
%     ylabel('percent correct (precision)')
%     drawnow
% end
