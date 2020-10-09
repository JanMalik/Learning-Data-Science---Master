#####################
###   Malik Jan   ###
### 06 April 2018 ###
#####################


#################################
### Donnees Agriculture #########
#################################

library(cluster)
data(agriculture)
agri = agriculture
help(agriculture)

plot(agri,xlab="GNP",ylab="tx agriculture",type="n")
text(agri,labels=row.names(agri))

## calcul des distances entre individus
d = dist(agri)
# individus les plus proches : Belgique et Pays-Bas

## CAH avec distance min
cah.single = hclust(d,method="single")
plot(cah.single,hang=-1)
plot(rev(cah.single$height),type="b")
plot(rev(cah.single$height),type="s")

plot(cah.single,hang=-1)
rect.hclust(cah.single, 4, border ="magenta")
# dans l'aide, on conseille deux classes
rect.hclust(cah.single, 2, border ="blue")
# resultats sur donnees
gpe.single = cutree(cah.single,k=4)
plot(agri,type="p",xlab="GNP",ylab="tx agriculture",pch=gpe.single,col=gpe.single)

## CAH avec ward
cah.ward = hclust(d,method="ward.D2")
plot(cah.ward,hang=-1)
plot(rev(cah.ward$height),type="b")

plot(cah.ward,hang=-1)
rect.hclust(cah.ward, 2, border ="blue")

gpe.ward = cutree(cah.ward,k=2)
plot(agri,type="p",xlab="GNP",ylab="tx agriculture",pch=gpe.ward,col=gpe.ward)

#################################
##### Donnees Exemple CAH #######
#################################

Exdata = read.table("ExdataCAH.txt")

plot(Exdata,ylim=c(1,5),xlim=c(0,5))

d = dist(Exdata)

## CAH avec ward
cah.ward = hclust(d,method="ward.D2")
plot(cah.ward,hang=-1)
plot(rev(cah.ward$height),type="b")

plot(cah.ward,hang=-1)
rect.hclust(cah.ward, 4, border ="blue")

gpe.ward = cutree(cah.ward,k=4)
plot(Exdata,type="p",xlab="GNP",ylab="tx agriculture",pch=gpe.ward,col=gpe.ward)

## CAH avec dist max
cah.comp = hclust(d,method="complete")
plot(cah.comp,hang=-1)
plot(rev(cah.comp$height),type="b")

plot(cah.comp,hang=-1)
rect.hclust(cah.comp, 4, border ="blue")

gpe.comp = cutree(cah.comp,k=4)
plot(Exdata,type="p",xlab="GNP",ylab="tx agriculture",pch=gpe.comp,col=gpe.comp)

## CAH avec dist min
cah.sing = hclust(d,method="single")
plot(cah.sing,hang=-1)
plot(rev(cah.sing$height),type="b")

plot(cah.sing,hang=-1)
rect.hclust(cah.sing, 2, border ="blue")

gpe.sing = cutree(cah.sing,k=2)
plot(Exdata,type="p",xlab="GNP",ylab="tx agriculture",pch=gpe.sing,col=gpe.sing)

#################################
### Donnees Fromages    #########
#################################

fromage = read.table("fromage.txt",header=TRUE,row.names = 1)

head(fromage)
summary(fromage)

pairs(fromage)

fromage = apply(fromage,2,FUN=function(x) (x-mean(x))/sd(x))

d=dist(fromage)

cah.ward = hclust(d,method="ward.D2")
plot(cah.ward,hang=-1)
plot(rev(cah.ward$height),type="b")

plot(cah.ward,hang=-1)
rect.hclust(cah.ward, 4, border ="blue")
rect.hclust(cah.ward, 5, border ="magenta")

gpe.ward = cutree(cah.ward,k=4)
sort(gpe.ward)

stat.comp = function(x,y){
  #nombre de groupes
  K = length(unique(y))  
  #nb. d'observations
  n = length(x) 
  #moyenne globale
  m = mean(x)  
  #variabilité totale
  TSS = sum((x-m)^2) 
  #effectifs conditionnels
  nk = table(y) 
  #moyennes conditionnelles
  mk = tapply(x,y,mean)  
  #variabilité expliquée
  BSS = sum(nk*(mk-m)^2) 
  #moyennes + prop. variance expliquée
  result = c(mk,100.0*BSS/TSS) 
  #nommer les élements du vecteur 
  names(result) = c(paste("G",1:K),"%epl.")
  #renvoyer le vecteur résultat
  return(result)
}
#appliquer stat.comp aux variables de la base originelle fromage
#et non pas aux variables centrées et réduites
fromage = read.table("fromage.txt",header=TRUE,row.names = 1)
print(sapply(fromage,stat.comp,y=gpe.ward))

sapply(1:9,FUN=function(i) summary(aov(fromage[,i]~gpe.ward)))

### ACP pour l'interpretation
library(FactoMineR)
fromage$groupe = gpe.ward
par(mfrow=c(1,2))
acp = PCA(fromage,scale.unit=TRUE,graph=T,quali.sup=10)
plot(acp,choix="ind",habillage = 10,col.hab=c("green","blue","red","orange"),autoLab="no")
plot(acp,choix="var")

plot(1:9,acp$sdev^2,type="b",xlab="Nb. de facteurs",ylab="Val. Propres")


par(mfrow=c(1,1))
acp = princomp(fromage,cor=T,scores=T)
biplot(acp)
plot(acp$scores[,1],acp$scores[,2],type="n",xlim=c(-5,5),ylim=c(-5,5))
text(acp$scores[,1],acp$scores[,2],col=gpe.ward,cex=0.65,labels=rownames(fromage))
