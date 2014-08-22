function [p, r] = precall(score, truth, pos)

%%% number of true samples
num_truesamples=length(truth);

%%% score is the computed hamming distance
[sorted_val, sorted_ind]=sort(score); 
sorted_truefalse=ismember(sorted_ind, truth);
    
truepositive=cumsum(sorted_truefalse);

r=truepositive(pos)/num_truesamples;
p=truepositive(pos)./(pos);%[1:numds];
