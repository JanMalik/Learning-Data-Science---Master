######################
###   Jan Malik   ###
### 04 April 2018 ###
######################

###############################################################
### fonction algoEM : algorithme EM pour donnees univariees ###
###############################################################

algoEM = function(xdata,nbcomp,epsilon){
  n   = length(xdata)
  eps = 1
  #initialisation k-means
  km.init = kmeans(xdata,centers=nbcomp,nstart=30) 
  pik     = km.init$size/n
  muk     = as.vector(km.init$centers)
  sigma2k = km.init$withinss/km.init$size
  
  resM.old = c(pik,muk,sigma2k)
  llik     = sum(log(apply(sapply(1:nbcomp,FUN=function(j) pik[j]*dnorm(xdata,muk[j],sqrt(sigma2k[j]))),1,sum)))
  
  while (eps>epsilon){
    #Etape E
    tauik  = 
      
      #Etape M
      pik = 
      muk = 
      sigma2k = 
      
      #calcul critere d'arret
      eps = sum((c(pik,muk,sigma2k)-resM.old)^2)/sum(resM.old^2) 
    resM.old = c(pik,muk,sigma2k)
    
    #calcul log-vraisemblance
    llik = c(llik,sum(log(apply(sapply(1:nbcomp,FUN=function(j) pik[j]*dnorm(xdata,muk[j],sqrt(sigma2k[j]))),1,sum))))
    #eps  = (rev(llik)[1]-rev(llik)[2])/abs(rev(llik[2]))
  }  
  resEM = list(tauik = tauik, pik = pik, muk = muk, sigma2k = sigma2k, llik = llik) 
}

