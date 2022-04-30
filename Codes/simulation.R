library(elasticnet)
set.seed(42)
# original data
V1 <- rnorm(1, 0, sqrt(290))
V2 <- rnorm(1, 0, sqrt(300))
V3 <- (-0.3)*rnorm(1, 0, sqrt(290)) + 0.925*rnorm(1, 0, sqrt(300)) + rnorm(1)
# observed data
X <- matrix(0, nrow = 1e5, ncol = 10)
epsilon <- matrix(rnorm(10*nrow(X)), nrow = 1e5, ncol = 10)
for (i in 1:nrow(X))
{
V1 <- rnorm(1, 0, sqrt(290))
V2 <- rnorm(1, 0, sqrt(300))
V3 <- (-0.3)*rnorm(1, 0, sqrt(290)) + 0.925*rnorm(1, 0, sqrt(300)) + rnorm(1)
X[i, 1:4] <- V1
X[i, 5:8] <- V2 
X[i, 9:10] <- V3 
}
X <- X + epsilon
PCA <- prcomp(X, scale. = TRUE)
PCA$rotation[, 1:3]
PCA$sdev[1:3]
PCA$sdev[1:3]/sum(PCA$sdev[1:3])

out <- spca(var(X), K = 10, para = rep(5, 10), 
            type = "Gram", sparse = "penalty",
            max.iter = 1000, lambda = 0,
            use.corr = TRUE)

out_gas<-gas.pca(var(X),d=10,type="Gram",n=100000)
out$loadings
out$pev

df<-cbind(PCA$rotation[, 1:3],out$loadings[,1:3],out_gas$loadings[,1:3])
library(stargazer)
stargazer(df)
