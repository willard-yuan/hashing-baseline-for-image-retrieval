======================Matlab Code================================

This source code comes from http://www.unc.edu/~yunchao/itq.htm. I have modified it and
implement drawing the Precision Recall Curve using different method such as ITQ/LSH/RR
/SKLSH, and
Yunchao Gong and Svetlana lazebnik.
Iterative Quantization: A Procrustean Approach to Learning Binary Code
CVPR 2011.
Author: Yunchao Gong and Svetlana Lazebnik
Contact: yunchao@cs.unc.edu


This package contains cleaned up code for the above paper.

Important files are:

1) ITQ.m: implements the Iterative Quantization method
2) compressITQ: convert large-scale data to binary matrix
3) main.m: demo code computes recall precision, also implements some other baseline methods
4) RF_train.m: estimate some parameter for SKLSH
5) RF_compress.m: perform SKLSH binary embedding
6) cca.m performs a canonical correlation analysis for supervised cases

Some important notes:
1) before ITQ, the data must have be centered (see secton 2.2 of the paper)
2) we found 20-50 iterations are usually enough for ITQ


We appreciate any bug report. Thanks!

