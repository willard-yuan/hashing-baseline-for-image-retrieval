function [evaluation_info time]=evaluate(B_train, B_test, gnd_train, gnd_test)
start_t=clock;
Ntrain = length(gnd_train);
Ntest = length(gnd_test);
% Ntest = 100;

ap_all = zeros(Ntest,1);
ph2_all = zeros(Ntest,1);
for i = 1:Ntest
    % compute your distance
    D_code = hammingDist(B_test(i,:) ,B_train);
    
    % evaluation
    [ap ph2] = phmap(D_code, gnd_train, gnd_test(i)); 
    ap_all(i)=ap;
    ph2_all(i)=ph2;
end

evaluation_info.AP=mean(ap_all);
evaluation_info.PH2=mean(ph2_all);
end_t=clock;
time=etime(end_t,start_t);