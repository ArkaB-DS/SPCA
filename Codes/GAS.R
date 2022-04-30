require(MASS)
require(lars)

#######################################################
# Reference: Leng and Wang (2008) On General Adaptive Sparse Principal
# Component Analysis. JCGS.
#
# Input: x - either the data matrix (when type='predictor') or
#            the gram matrix (when type='Gram')
#        n - sample size
#        d - the number of PCs to retain
#        method - GAS, SPCA or VAST, see the paper for details
#        adaptive - whether to use adaptive penalty
#        n.BT - number of bootstrap samples
#
# Output: loadings - the estimated loadings
#         B0 - PCA
#########################################################
gas.pca <- function(x, n, d, type=c("Gram","predictor"),
                    max.iter=10, method=c('GAS','SPCA','VAST'),
                    adaptive=TRUE, para=NULL, corr=FALSE, seed=NULL,
                    n.BT = 2000)
{
  eps.conv <- 1e-3
  call <- match.call()
  type <- match.arg(type)
  method <- match.arg(method)
  vn <- dimnames(x)[[2]]
  p <- dim(x)[2]    
  xtx <- switch(type, predictor = {
    x <- scale(x, center = TRUE, scale = FALSE)
    xtx <- t(x)%*%x
  }, Gram = {
    xtx <- x
  })
  svdobj <- svd(xtx)
  v <- svdobj$v
  
  A <- as.matrix(v[, 1:d, drop = FALSE])
  
  for(i in 1:d)
    A[,i] <- A[,i]*sign(A[1,i])
  
  B <- A; temp <- B; A0 <- B
  
  if(method!='SPCA') {
    if(!is.null(seed)) {
      set.seed(seed)
    }
    if(is.null(n.BT))
      n.BT <- 2000
    boot.ev <- array(0, dim=c(p,n.BT,d))
    
    for(ii in 1:n.BT) {
      newx <- switch(type, Gram={
        tmp <- mvrnorm(n, mu=rep(0,p), xtx)
        newx <- t(tmp)%*%tmp
      }, predictor={
        idx <- sample(1:n,n,replace=T)
        newx <- t(x[idx,])%*%x[idx,]
      })
      
      tmp.svd <- svd(newx/n)
      tmp <- tmp.svd$v[,1:d,drop=FALSE]
      t2 <- acos(apply(tmp*A0,2,sum)); t3 <- t2>pi/2
      tmp[,t3] <- -tmp[,t3]
      boot.ev[,ii,] <- tmp
    }
    
    boot.cov <- array(0, dim=c(p,p,d))
    for(ii in 1:d)
      boot.cov[,,ii] <- cov(t(boot.ev[,,ii]))
    
    boot.incov <- array(0, dim=c(p,p,d))
    for(ii in 1:d)
      boot.incov[,,ii] <- solve(boot.cov[,,ii])
  }
  
  xtx.1 <- xtx
  if(corr) xtx.1 <- xtx.1*n
  II <- diag(p)*n
  k <- 0
  diff <- 1
  
  tr.x <- tr(xtx)
  while ((k < max.iter) & (diff > eps.conv)) {
    k <- k + 1
    
    for (i in 1:d)
    {
      xtx1 <- switch(method, GAS =
      {xtx1 <- boot.incov[,,i,drop=TRUE]},
      SPCA =
      { xtx1<- xtx.1},
      VAST =
      { xtx1 <- diag(diag(boot.incov[,,i,drop=TRUE]))})
      lfit <- lars.lsa(xtx1,A[,i],n=n,adaptive=adaptive,para=para[i])
      B[,i] <-  lfit$beta.bic          
    }
    normB <- sqrt(apply(B^2, 2, sum))
    normB[normB == 0] <- 1
    B2 <- t(t(B)/normB)
    diff <- max(abs(B2 - temp))
    temp <- B
    A <- xtx %*% B;
    z <- svd(A)
    A <- (z$u) %*% t(z$v)
  }
  B <- normalize(B, d)
  dimnames(B) <- list(vn, paste("PC", 1:d, sep = ""))
  dimnames(A0) <- list(vn, paste("PC", 1:d, sep = ""))
  
  obj <- list(loadings=B, B0=A0)
  obj
}


tr <- function(x)
  sum(diag(x))

rootmatrix <- function(x) {
  x.eigen <- eigen(x)
  d <- x.eigen$values
  d <- (d + abs(d))/2
  v <- x.eigen$vectors
  return(v %*% diag(sqrt(d)) %*% t(v))
}

normalize <- function(B,d)
{
  normB <- sqrt(apply(B^2, 2, sum))
  normB[normB == 0] <- 1
  B <- t(t(B)/normB)
  B[abs(B)<1e-6] <- 0
  for (i in 1:d) {
    tmp <- abs(B[,i])>1e-6;
    if(sum(tmp)!=0) {
      tmp1 <- B[tmp,i]
      B[,i] <- sign(tmp1[1])*B[,i]
    }
  }
  B
}

lars.lsa <- function (Sigma0, b0, n,
                      adaptive=TRUE,
                      type = c("lar","lasso"),
                      eps = .Machine$double.eps,
                      max.steps,
                      para=NULL) 
{
  type <- match.arg(type)
  TYPE <- switch(type, lasso = "LASSO", lar = "LAR")
  
  n1 <- dim(Sigma0)[1]
  
  Sigma <- Sigma0
  b <- b0
  
  if(adaptive) {
    Sigma <- diag(abs(b))%*%Sigma%*%diag(abs(b))
    b <- sign(b)
  }
  
  nm <- dim(Sigma)
  m <- nm[2]
  im <- inactive <- seq(m)
  
  Cvec <- drop(t(b)%*%Sigma)
  ssy <- sum(Cvec*b)
  if (missing(max.steps)) 
    max.steps <- 8 * m
  beta <- matrix(0, max.steps + 1, m)
  Gamrat <- NULL
  arc.length <- NULL
  R2 <- 1
  RSS <- ssy
  first.in <- integer(m)
  active <- NULL
  actions <- as.list(seq(max.steps))
  drops <- FALSE
  Sign <- NULL
  R <- NULL
  k <- 0
  ignores <- NULL
  
  while ((k < max.steps) & (length(active) < m)) {
    action <- NULL
    k <- k + 1
    C <- Cvec[inactive]
    Cmax <- max(abs(C))
    if (!any(drops)) {
      new <- abs(C) >= Cmax - eps
      C <- C[!new]
      new <- inactive[new]
      for (inew in new) {
        R <- updateR(Sigma[inew, inew], R, drop(Sigma[inew, active]),
                     Gram = TRUE,eps=eps)
        if(attr(R, "rank") == length(active)) {
          ##singularity; back out
          nR <- seq(length(active))
          R <- R[nR, nR, drop = FALSE]
          attr(R, "rank") <- length(active)
          ignores <- c(ignores, inew)
          action <- c(action,  - inew)
        }
        else {
          if(first.in[inew] == 0)
            first.in[inew] <- k
          active <- c(active, inew)
          Sign <- c(Sign, sign(Cvec[inew]))
          action <- c(action, inew)
        }
      }
    }
    else action <- -dropid
    Gi1 <- backsolve(R, backsolvet(R, Sign))
    dropouts <- NULL
    A <- 1/sqrt(sum(Gi1 * Sign))
    w <- A * Gi1
    
    if (length(active) >= m) {
      gamhat <- Cmax/A      
    }
    else {        
      a <- drop(w %*% Sigma[active, -c(active,ignores), drop = FALSE])
      gam <- c((Cmax - C)/(A - a), (Cmax + C)/(A + a))
      gamhat <- min(gam[gam > eps], Cmax/A)
    }
    if (type == "lasso") {
      dropid <- NULL
      b1 <- beta[k, active]
      z1 <- -b1/w
      zmin <- min(z1[z1 > eps], gamhat)
      
      if (zmin < gamhat) {
        gamhat <- zmin
        drops <- z1 == zmin
      }
      else drops <- FALSE
    }
    beta[k + 1, ] <- beta[k, ]
    beta[k + 1, active] <- beta[k + 1, active] + gamhat * w
    
    Cvec <- Cvec - gamhat * Sigma[, active, drop = FALSE] %*% w   
    Gamrat <- c(Gamrat, gamhat/(Cmax/A))
    
    arc.length <- c(arc.length, gamhat)
    if (type == "lasso" && any(drops)) {
      dropid <- seq(drops)[drops]
      for (id in rev(dropid)) {
        R <- downdateR(R,id)
      }
      dropid <- active[drops]
      beta[k + 1, dropid] <- 0
      active <- active[!drops]
      Sign <- Sign[!drops]
    }
    
    actions[[k]] <- action
    inactive <- im[-c(active)]
  }
  beta <- beta[seq(k + 1), ]
  
  dff <- b-t(beta)
  
  RSS <- diag(t(dff)%*%Sigma%*%dff)
  
  if(adaptive)
    beta <- t(abs(b0)*t(beta))
  
  dof <- apply(abs(beta)>eps,1,sum)
  BIC <- RSS+log(n)*dof
  AIC <- RSS+2*dof
  if(is.null(para)) {
    tmp <- sort(BIC,ind=TRUE)
    beta.bic <- beta[tmp$ix[1],]
  }
  else {
    tmp1 <- dof==para
    beta.bic <- beta[tmp1,]
  }
  list(beta.bic=beta.bic, BIC=BIC, beta=beta)
}