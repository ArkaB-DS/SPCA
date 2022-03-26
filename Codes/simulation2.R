originalvariance <- matrix(0, 10, 10)
originalvariance[1:4, 1:4] <- 290
originalvariance[1:4, 5:8] <- 0
originalvariance[1:4, 9:10] <- 290*(-0.3)^2
originalvariance[5:8, 1:4] <- 0
originalvariance[5:8, 5:8] <- 300
originalvariance[5:8, 9:10] <- 0.925^2*300
originalvariance[9:10, 1:4] <- 290*(-0.3)^2
originalvariance[9:10, 5:8] <- 0.925^2*300
originalvariance[9:10, 9:10] <- 0.925*300 + (-0.3)^2*290 + 1 
originalvariance
PCA <- prcomp(originalvariance, center = FALSE)
PCA$rotation[, 1:3]
# PCA$sdev[1:3]
PCA$sdev[1:3]/sum(PCA$sdev[1:3])*100
diag(originalvariance)/sum(diag(originalvariance))*100
diag(qr.R(qr(PCA$rotation)))^2 / 
  sum(diag(qr.R(qr(PCA$rotation)))^2) * 100

  