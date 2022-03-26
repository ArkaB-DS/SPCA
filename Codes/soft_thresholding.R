# Replicating Fig 1 of SPCA (Zhu et. al)

# function for soft thresholding
soft_thresholding <- function(x, delta = 1) max((abs(x)-delta),0)*sign(x)

x <- seq(-5, 5, 0.01)
y <- sapply(x, soft_thresholding)
pdf("soft_threshold.pdf", height = 7, width = 7)
plot(x, y, type = "l", xlab = "\n", ylab = "\n",
	xaxt = "n", yaxt = "n", bty = "n", lwd =2, col = "blue")

# for x-y axes
library(shape)
Arrows(0,0,max(x)+0.2,0)
Arrows(0,0,-max(x)-0.2,0)
Arrows(0,0,0,max(y)+0.1)
Arrows(0,0,0,-max(y)-0.1)
text(5.3,-0.3, "x")
text(0.3,4.2, "y")
dev.off()