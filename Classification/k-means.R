#####################
###   Malik Jan   ###
### 06 April 2018 ###
#####################

#################################
### Donnees Agriculture #########
#################################

data(agriculture,package="cluster")
agri = agriculture

##### algo k-means step by step
centers = agri[sample(12,2),]  # choix alea
centers = agri[c(2,9),] # choix particulier
assign = sapply(1:nrow(agri),FUN=function(ind){
  which.min(apply(centers,1,FUN=function(x) sum((agri[ind,]-x)^2)))
})
old.part = as.vector(assign)
part = rep(0,nrow(agri))

par(mfrow=c(1,1))
plot(agri,xlab="GNP",ylab="tx agriculture",type="n")
text(agri,labels=row.names(agri))
points(centers,col=c(2,4),pch=15)
text(agri,labels=rownames(agri),col=2*assign)

i=1
while (any(old.part != part)){
  print(i)
  old.part = as.vector(assign)
  # calcul nouveaux centres
  centers = sapply(1:ncol(agri),FUN=function(i) tapply(agri[,i],as.factor(assign),mean))
  colnames(centers) = c("x","y")
  # plot
  plot(agri,xlab="GNP",ylab="tx agriculture",type="n")
  text(agri,labels=rownames(agri),col=2*assign)
  points(centers,col=c(2,4),pch=15)
  
  # assignation
  assign = sapply(1:nrow(agri),FUN=function(ind){
    which.min(apply(centers,1,FUN=function(x) sum((agri[ind,]-x)^2)))
  })
  part = as.vector(assign)
  # plot
  plot(agri,xlab="GNP",ylab="tx agriculture",type="n")
  points(centers,col=c(2,4),pch=15)
  text(agri,labels=rownames(agri),col=2*assign)
  i=i+1
}

cl = kmeans(agri,2)
plot(agri,xlab="GNP",ylab="tx agriculture",type="n")
text(agri,labels=row.names(agri),col=cl$cluster)
points(cl$centers, col = 1:2, pch = 15,cex = 1.5)

#################################
### Donnees Exemple     #########
#################################

Exdata = read.table("ExdataCAH.txt")

plot(Exdata,ylim=c(1,5),xlim=c(0,5))

cl = kmeans(Exdata,2)
cl
plot(Exdata,xlab="x",ylab="y",type="p",col=cl$cluster)
points(cl$centers, col = 1:2, pch = 15,cex = 1.5)

varintra = sapply(1:15,FUN=function(k){ kmeans(Exdata,k,nstart=50)$tot.withinss })
plot(varintra,type="b")
K=4
cl = kmeans(Exdata,K)
plot(Exdata,xlab="x",ylab="y",type="p",col=cl$cluster)
points(cl$centers, col = 1:K, pch = 15,cex = 1.5)

#################################
### Donnees Fromages    #########
#################################

fromage = read.table("fromage.txt",header=TRUE,row.names = 1)

cl = kmeans(fromage,4)
pairs(fromage,col=cl$cluster)

cl = kmeans(fromage,4,nstart=50)
pairs(fromage,col=cl$cluster)

acp = princomp(fromage,cor=TRUE,scores=TRUE)

d=dist(fromage)
cah.ward = hclust(d,method="ward")
gpe.ward = cutree(cah.ward,k=4)

par(mfrow=c(1,2))
plot(acp$scores[,1],acp$scores[,2],type="n",xlim=c(-5,5),ylim=c(-5,5),xlab="Axe1",ylab="Axe2",main="K-means")
text(acp$scores[,1],acp$scores[,2],col=cl$cluster,cex=0.65,labels=rownames(fromage))

plot(acp$scores[,1],acp$scores[,2],type="n",xlim=c(-5,5),ylim=c(-5,5),xlab="Axe1",ylab="Axe2",main="CAH")
text(acp$scores[,1],acp$scores[,2],col=gpe.ward,cex=0.65,labels=rownames(fromage))

library(cluster)
par(mfrow=c(1,2))
clusplot(fromage,cutree(cah.ward,4),labels=2)
clusplot(fromage,cl$cluster,labels=2)
