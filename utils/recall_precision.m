function [recall, precision, rate] = recall_precision(Wtrue, Dhat)
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

max_hamm = max(Dhat(:)); %将Dhat(:)按列拉成一个1维列向量，然后取最大值
hamm_thresh = min(3,max_hamm);%比较3,max_hamm，取两者的最小值

[Ntest, Ntrain] = size(Wtrue);
total_good_pairs = sum(Wtrue(:)); %将Wtrue(:)按列拉成一个1维列向量，然后求和
%原欧式空间中小于Dball的个数WtrueTestTraining = DtrueTestTraining < Dball

% find pairs with similar codes
precision = zeros(max_hamm,1);
recall = zeros(max_hamm,1);
rate = zeros(max_hamm,1);

for n = 1:length(precision)
    j = (Dhat<=((n-1)+0.00001));
    
    %exp. # of good pairs that have exactly the same code
    retrieved_good_pairs = sum(Wtrue(j)); %找出Wtrue中以j为真的索引
    
    % exp. # of total pairs that have exactly the same code
    retrieved_pairs = sum(j(:)); %统计j中1的个数

    precision(n) = retrieved_good_pairs/retrieved_pairs;
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

% if nargout == 0 || nargin > 3
%     if isempty(fig);
%         fig = figure;
%     end
%     figure(fig)
%     
%     subplot(311)
%     plot(0:hamm_thresh-1, precision(1:hamm_thresh), varargin{:})
%     hold on
%     xlabel('hamming radius')
%     ylabel('precision')
%     
%     subplot(312)
%     plot(0:hamm_thresh-1, recall(1:hamm_thresh), varargin{:})
%     hold on
%     xlabel('hamming radius');
%     ylabel('recall');
%         
%    subplot(313);
%     plot(recall, precision, varargin{:});
%     hold on;
%     axis([0 1 0 1]);
%     xlabel('recall');
%     ylabel('precision');
% 
%     drawnow;
% end
