=======================================================================================
### Overview:<br/>

This matlab source code comes from http://www.unc.edu/~yunchao/itq.htm. <br/>
> I have modified it and implement drawing the Precision Recall Curves using <br/>
different methods such as ITQ/LSH/RR/SKLSH, and different binary bit length <br/>
PR_Curves using LSH. A Retri_Images_Demo is also  provided to show the image <br/>
retrieval result using ITQ.<br/>

Modified by Willard, and my website is: www.yuanyong.org<br/>

========================================================================================

### Important files are:<br/>

> 1) ITQ.m: implements the Iterative Quantization method <br/>
2) compressITQ: convert large-scale data to binary matrix <br/>
3) main.m: demo code computes recall precision, also implements some other baseline methods <br/>
4) RF_train.m: estimate some parameter for SKLSH <br/>
5) RF_compress.m: perform SKLSH binary embedding <br/>
6) cca.m performs a canonical correlation analysis for supervised cases <br/>
7) Demo_PR.m: This is a geometric illustration of Draw the Recall Precision Curve <br/>
8) DemoLSH_PR.m: This is a geometric illustration of LSH recall and precision using <br/>
different code length <br/>
9) Retri_Images_Demo.m: This is a PCA-ITQ demo showing the retrieval sample <br/>

========================================================================================

### Some important notes: <br/>
> 1) before ITQ, the data must have be centered <br/>
2) we found 20-50 iterations are usually enough for ITQ <br/>
3) I modified it on a 16G memory computer, 4G is failed for the dataset is large <br/>

========================================================================================
### Demo results

![image](https://github.com/willard-yuan/ITQ_ImageRetrieval/raw/master/QueryAirplaneResult.jpg)

![image](https://github.com/willard-yuan/ITQ_ImageRetrieval/raw/master/PR_DifMethods.jpg)

![image](https://github.com/willard-yuan/ITQ_ImageRetrieval/raw/master/LSH_PR.jpg)

If there is a bug, don't hesitate to contact me. Thanks!<br/>
