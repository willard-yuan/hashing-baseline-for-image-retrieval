function RFparam = RF_train(RFparam)
%% RFparam.D: input dimension
%% RFparam.M: desired output dimension
%% RFparam.gamma: bandwidth of the Gaussian kernel

%% actually, there is no training here. This function is just randomly setting the
%% code parameters.

RFparam.R = randn(RFparam.D,RFparam.M)*sqrt(RFparam.gamma);
RFparam.B = rand(1,RFparam.M) * 2 * pi;
%RFparam.T = zeros(1,RFparam.M); 
RFparam.T = (rand(1,RFparam.M) * 2 - 1) * sqrt(2);
