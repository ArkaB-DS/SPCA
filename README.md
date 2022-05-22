# SPCA

This repo contains the R codes, figures, and datasets used in the project for the course - `MTH514A: Multivariate Analysis` at IIT Kanpur during the academic year 2022-2023.

## Project Members

  - [Arkajyoti Bhattacharjee](https://github.com/ArkaB-DS)
  - [Rachita Mondal](https://github.com/Rachita-Mondal)
  - [Ritwik Vashishtha](https://github.com/ritwikvashistha)
  - [Shubha Sankar Banerjee](https://github.com/shubha3)

## Project Title
`A Brief Review of Sparse Principal Components Analysis and its Generalization` [`[Report]`](https://github.com/ArkaB-DS/SPCA/blob/main/Multivariate_Project.pdf) [`[Slides]`](https://github.com/ArkaB-DS/SPCA/blob/main/Multivariate_Project__slides_.pdf)

## Table of Contents

|Section|Topic|
|-------|-----|
|1|Introduction|
|2|The LASSO and Elastic Net|
|3|SPCA <ul> 3.1 Direct Sparse Approximation</ul> <ul> 3.2 SPCA Criterion </ul> <ul> 3.3 Numerical Solution </ul> <ul> 3.4 Adjusted Total Variance </ul> <ul> 3.5 Computational Complexity </ul>|
|4|GAS-PCA <ul> 4.1 Asymptotic Properties of GAS-PCA </ul> <ul>Optimal Choice of the Kernel Matrix, $\tilde{Omega}$</ul>|
|5|Examples <ul>5.1 Synthetic Data Analysis</ul> <ul>5.2 Real Data Analysis <ul>5.2.1 Pitprops Data</ul> <ul>5.2.2 Teaching Data</ul></ul>|
|6|Conclusion|
## Abstract
> Principal Component Analysis is a widely studied methodology as it is a useful technique for dimension reduction. 
In this report, we discuss Sparse Principal Component Analysis (SPCA), which is a modification over PCA. 
This method is able to resolve the interpretation issue of PCA. Additionally, it provides sparse loadings to
the principal components. The main idea of SPCA comes from the relationship between PCA problem and regression analysis.
We also discuss GAS-PCA, which is a generalization over SPCA and this method performs better than SPCA,
even in finite sample cases. Our report is mainly based on [1] and its extension [2].


## Primary References
[1] [Hui Zou, Trevor Hastie & Robert Tibshirani (2006) Sparse Principal Component Analysis, Journal of Computational and Graphical Statistics, 15:2, 265-286, DOI: <u>10.1198/106186006X113430</u>](https://hastie.su.domains/Papers/spc_jcgs.pdf)

[2] [Chenlei Leng & Hansheng Wang (2009) On General Adaptive Sparse Principal Component Analysis, Journal of Computational and Graphical Statistics, 18:1, 201-215, DOI: <u>10.1198/jcgs.2009.0012</u>](https://www.tandfonline.com/doi/pdf/10.1198/jcgs.2009.0012?casa_token=6hQ5NY-CPQwAAAAA:6QvZeqWa-IXVd_Mbxu6MCUqnEVEw5L-MmLI5Z1-_03bU9mYqD6LHI_foctumbmTOAX3-xaWqy-U)
