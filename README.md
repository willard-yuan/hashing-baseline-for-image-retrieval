=======================================Matlab Code======================================

This source code comes from http://www.unc.edu/~yunchao/itq.htm. I have modified it and
implement drawing the Precision Recall Curves using different methods such as ITQ/LSH/RR
/SKLSH, and different binary bit length PR_Curves using LSH. A Retri_Images_Demo is also 
provided to show the image retrieval result using ITQ.

Modified by Willard, and my website is: www.yuanyong.org

========================================================================================

Important files are:

1) ITQ.m: implements the Iterative Quantization method
2) compressITQ: convert large-scale data to binary matrix
3) main.m: demo code computes recall precision, also implements some other baseline methods
4) RF_train.m: estimate some parameter for SKLSH
5) RF_compress.m: perform SKLSH binary embedding
6) cca.m performs a canonical correlation analysis for supervised cases
7) Demo_PR.m: This is a geometric illustration of Draw the Recall Precision Curve
8) DemoLSH_PR.m: This is a geometric illustration of LSH recall and precision using
different code length
9) Retri_Images_Demo.m: This is a PCA-ITQ demo showing the retrieval sample

========================================================================================

Some important notes:
1) before ITQ, the data must have be centered
2) we found 20-50 iterations are usually enough for ITQ
3) I modified it on a 16G memory computer, 4G is failed for the dataset is large

If there is a bug, don't hesitate to contact me. Thanks!
