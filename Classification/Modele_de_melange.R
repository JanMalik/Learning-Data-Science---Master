#####################
###   Malik Jan   ###
### 06 April 2018 ###
#####################

## Melange gaussien

mu    = c(-3,1,2)
sigma = c(1,0.5,0.3)
pik   = c(0.25,0.4,0.35)

x=seq(-6,4,length=100)
dens.melange = apply(sapply(1:3,FUN=function(i) pik[i]*dnorm(x,mu[i],sigma[i])),1,sum)
par(mfrow=c(1,2))
plot(x,dens.melange,type="l",lwd=2,ylab="")
plot(x,pik[1]*dnorm(x,mu[1],sigma[1]),type="l",col=2,ylim=c(0,0.5),ylab="")
lines(x,pik[2]*dnorm(x,mu[2],sigma[2]),col=3)
lines(x,pik[3]*dnorm(x,mu[3],sigma[3]),col=4)
lines(x,dens.melange,col=1)

gpe         = sample(1:3,size=3000,replace=TRUE,pik)
donnees.sim = sapply(gpe,FUN=function(k) rnorm(1,mu[k],sigma[k]))

par(mfrow=c(1,1))
hist(donnees.sim,breaks=50,freq=FALSE,ylim=c(-0.1,0.7))
points(donnees.sim,rep(-0.05,length(donnees.sim)),type="p",pch="|",col=4)
lines(density(donnees.sim),col=2)



## Melange Poisson

lambda = c(1,4,10)
pik   = c(0.25,0.4,0.35)

x=0:30
dens.melange = apply(sapply(1:3,FUN=function(i) pik[i]*dpois(x,lambda[i])),1,sum)
par(mfrow=c(1,2))
plot(x,dens.melange,type="l",lwd=2,ylab="")
plot(x,pik[1]*dpois(x,lambda[1]),type="l",col=2,ylim=c(0,0.15),ylab="")
lines(x,pik[2]*dpois(x,lambda[2]),col=3)
lines(x,pik[3]*dpois(x,lambda[3]),col=4)
lines(x,dens.melange,col=1)

gpe         = sample(1:3,size=3000,replace=TRUE,pik)
donnees.sim = sapply(gpe,FUN=function(k) rpois(1,lambda[k]))

par(mfrow=c(1,1))
hist(donnees.sim,breaks=50,freq=FALSE,ylim=c(-0.1,0.5))
points(donnees.sim,rep(-0.05,length(donnees.sim)),type="p",pch="|",col=4)
lines(density(donnees.sim),col=2)

######### En 2D
plot(1:5,1:5,type="n")
mu = as.matrix(as.data.frame(locator(3)))
sigma = 0.6*c(1,0.5,0.8)

gpe         = sample(1:3,size=500,replace=TRUE,pik)
donnees.sim = sapply(gpe,FUN=function(k) rnorm(2,as.vector(mu[k,]),rep(sigma[k],2)) )

par(mfrow=c(1,2))
plot(t(donnees.sim),col=1,pch=20,main="Donnees incompletes",xlab="",ylab="")
points(mu,col=6,pch=15)
plot(t(donnees.sim),col=gpe+1,pch=20,main="Donnees completes",xlab="",ylab="")
points(mu,col=6,pch=15)

