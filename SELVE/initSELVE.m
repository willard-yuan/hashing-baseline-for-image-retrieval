function  SELVEparam = initSELVE(traindata, SELVEparam)
            
SELVEparam.s = 2;   %number of nearest anchors, please tune this parameter on different datasets
SELVEparam.lambda = 0.1;
SELVEparam.beta = 0.5;
SELVEparam.RedDim = 300;  % the left dimensions of original data
SELVEparam.m = 300;       % the number of landmark
SELVEparam.sigma = 0;

kmMaxIter = 10;
kmNumRep = 1;
[label,anchor] = litekmeans(traindata,SELVEparam.m,'MaxIter',kmMaxIter,'Replicates',kmNumRep);
clear kmMaxIter kmNumRep;

temptraindata = zeros(size(traindata,1),size(traindata,2));
tempanchor = zeros(SELVEparam.m,size(traindata,2));
totalnum = 0;

for i=1:length(unique(label))
    tempnum = find(label == i);
    temptraindata(totalnum +1: totalnum + length(tempnum),:) = traindata(tempnum,:);
    tempanchor(totalnum +1:totalnum + length(tempnum),:) = repmat(anchor(i,:),length(tempnum),1);
    totalnum = totalnum + length(tempnum);
end
Gamma = temptraindata - tempanchor;  % ins * fea
SELVEparam.GtG = Gamma'*Gamma;
clear temptraindata tempanchor Gamma tempnum totalnum;

%% searching for transformation matrix
SELVEparam.XtX = traindata'*traindata;
SELVEparam.anchor = anchor;
SELVEparam.label = label;