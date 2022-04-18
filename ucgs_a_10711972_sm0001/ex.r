# Example 1, Case C

source('GAS.r')
n <- 1000
p <- 12

v1 <- c(1,1,0.2,0.2,rep(0,4),rep(0,4))
v2 <- c(rep(0,4),1,1,0.1,0.1,rep(0,4))
v3 <- c(rep(0,8),1,1,0.3,0.2)

v1 <- v1/sqrt(sum(v1*v1))
v2 <- v2/sqrt(sum(v2*v2))
v3 <- v3/sqrt(sum(v3*v3))

d <- diag(c(100,60,30,10,10,10,5,5,5,5,2,2))

S1 <- cbind(v1,v2, v3,matrix(runif(9*p),p,9))

qr.S <- qr(S1)
S2 <- qr.Q(qr.S)
  
S <- S2%*%d%*%t(S2) 

x <- mvrnorm(n, mu=rep(0,p), S)
 
lfit <- gas.pca(x,type='predictor',n=n,d=3,
                adaptive=T,method='GAS')
lfit
