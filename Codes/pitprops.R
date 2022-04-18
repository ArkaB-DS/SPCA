library(elasticnet)
data("pitprops")
## Table 1
PCA <- prcomp(pitprops, center = FALSE)
PCA$rotation[,1:6]
(PCA$sdev/sum(PCA$sdev)*100)[1:6]
cumsum(PCA$sdev/sum(PCA$sdev)*100)[1:6]
## Table 3
SPCA<-spca(pitprops, K = 6, type = "Gram", sparse = "penalty",
           trace = TRUE, para = c (0.06, 0.16, 0.1, 0.5, 0.5, 0.5))
SPCA
SPCA$loadings
SPCA$pev

## Figure 2
lambda.grid <- seq(0, 3.5, 0.01)
PEVmatrix <- matrix(0, ncol = 6, nrow = length(lambda.grid))
for (i in lambda.grid)
{
cat(i,"\n")
SPCA<-spca(pitprops, K = 1, type = "Gram", sparse = "penalty", lambda = 0,
           para = rep(i,6), eps.conv = 1e-4)
PEVmatrix[i, ] <- SPCA$pev
}

plot(lambda.grid, PEVmatrix[,1], type = "l", xlim = c(0, 0.2))
