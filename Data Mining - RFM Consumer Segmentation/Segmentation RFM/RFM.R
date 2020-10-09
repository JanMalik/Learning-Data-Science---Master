########################
###    Malik  Jan    ###
### 16 February 2018 ###
########################

#####################################
###          Data Mining          ###
#####################################
###       Segmentation  RFM       ###
#####################################
### Recence - Frenquece - Montant ###
#####################################

#install.packages("data.table")
library(data.table)
#install.packages("dplyr")
library(dplyr)                        #si packages non instalees !
#install.packages("readr")
library(readr)
#install.packages("tidyverse")
library(tidyverse)


############################################################
# PROGRAMME INITIAL PERMETTANT DE DECLARER LES PARAMETRES  #
############################################################

# Pour vider la memoire de R
# rm(list=ls())


#################################################
# PARAMETRES PERMETTANT DE DEFINIR LE PERIMETRE #

# Date de la periode 
Date_debut = as.Date("2014-09-01");
Date_fin   = as.Date("2016-08-31")
annee      = 2016 ; 




#################################################
# PARAMETRES PERMETTANT DE DEFINIR LE PERIMETRE #
# Import des donnees
getwd()  
setwd(dir="C:/Users/Jan Malik/Desktop/MAS/DataMining/Data");
getwd()

# Fichiers R_COMPLEMENT_INDIVIDU_2016.csv
R_COMPLEMENT_INDIVIDU_2016 <- read.csv("R_COMPLEMENT_INDIVIDU_2016.csv",sep=";",header=TRUE,stringsAsFactors=FALSE) 
names(R_COMPLEMENT_INDIVIDU_2016)
head(R_COMPLEMENT_INDIVIDU_2016)

# Fichiers R_INDIVIDU_2016.csv
R_INDIVIDU_2016<-read.csv("R_INDIVIDU_2016.csv",sep=";",header=TRUE,stringsAsFactors=FALSE) 
names(R_INDIVIDU_2016)
head(R_INDIVIDU_2016)

# Fichiers R_MAGASIN.csv
R_MAGASIN<-read.csv("R_MAGASIN.csv",sep=";",header=TRUE,stringsAsFactors=FALSE) 
names(R_MAGASIN)
head(R_MAGASIN)

# Fichiers R_REFERENTIEL.csv
R_REFERENTIEL<-read.csv("R_REFERENTIEL.csv",sep=";",header=TRUE,stringsAsFactors=FALSE)
names(R_REFERENTIEL)
head(R_REFERENTIEL)

# Fichiers R_TICKETS_2016.csv
#require(bit64)
R_TICKETS_2016<-read.csv("R_TICKETS_2016.csv",sep=";",header=TRUE,stringsAsFactors=FALSE) 
names(R_TICKETS_2016)
head(R_TICKETS_2016)

# Fichiers R_TYPO_PRODUIT.csv
R_TYPO_PRODUIT<-read.csv("R_TYPO_PRODUIT.csv",sep=";",header=TRUE,stringsAsFactors=FALSE) 
names(R_TYPO_PRODUIT)
head(R_TYPO_PRODUIT)



#############################################################################################################
#############################################################################################################

R_INDIVIDU <- left_join(
                #Supprimer la variable ID_FOYER de la table individu
                  select(R_INDIVIDU_2016,-ID_FOYER)
                #Selectionner uniquement ID_INDIVIDU et CODE_MAGASIN
                , select(R_COMPLEMENT_INDIVIDU_2016,ID_INDIVIDU,CODE_MAGASIN)
                #Variable de jointure
                , by = "ID_INDIVIDU")

#Renommer Code_magasin
R_INDIVIDU = rename(R_INDIVIDU, MAGASIN_GESTIONNAIRE=CODE_MAGASIN)

#### RESTRICTION DU PERIMETRE
# ne garder que les lignes qui vérifient date creation < date
R_INDIVIDU<-filter(R_INDIVIDU,as.Date(DATE_CREATION_CARTE, "%d/%m/%Y")<=Date_fin)

#Validation
summarise(R_INDIVIDU,sortie=min(as.Date(as.Date(DATE_CREATION_CARTE, "%d/%m/%Y"))))
summarise(R_INDIVIDU,sortie=max(as.Date(as.Date(DATE_CREATION_CARTE, "%d/%m/%Y"))))

head(R_INDIVIDU)


###############################
## TRAITEMENT AU NIVEAU TICKET
###############################

## PERIMETRE DE L'ANALYSE
Tickets_perim<-filter(R_TICKETS_2016,
                      #Date achat superieure a date deebut
                      Date_debut<=as.Date(DATE_ACHAT, "%d/%m/%Y")
                    &
                      #Date achat inf
                      as.Date(DATE_ACHAT, "%d/%m/%Y")<=Date_fin)
dim(Tickets_perim)
names(Tickets_perim)

## JOINTURE AVEC MAGASIN
Tickets_mag = left_join(Tickets_perim
                        # Filtre sur les colonnes
                        ,select(R_MAGASIN,-ID_BOUTIQUE,-VILLE,-CDP,-CONCEP,-MER_TERRE,-QUOTA)
                        ,by="CODE_BOUTIQUE")
head(Tickets_mag)

# JOINTURE AVEC REFERENTIEL
Tickets_mag$EAN = as.character(Tickets_mag$EAN)
R_REFERENTIEL$EAN = as.character(R_REFERENTIEL$EAN)
Tickets_mag_ref = left_join(Tickets_mag
                            , select(R_REFERENTIEL,EAN,MODELE)
                            , by = "EAN")

# JOINTURE AVEC PRODUIT 
r_Matrice_travail = left_join(Tickets_mag_ref
                              , select(R_TYPO_PRODUIT,MODELE,Ligne,Famille)
                              , by = "MODELE")

names(r_Matrice_travail)
dim(r_Matrice_travail)

############################ 
# On clean la memoire de R
rm(Tickets_mag)
rm(Tickets_mag_ref)
rm(Tickets_perim)

rm(R_TYPO_PRODUIT)
rm(R_REFERENTIEL)




########################################################################################################### 
########################################################################################################### 


############################# 
# Sur les individus 
############################# 
# Calcul de l'age
r_individu_OK=mutate(R_INDIVIDU
                     , AGE = trunc(as.numeric((as.Date(Date_fin)
                                               -as.Date(paste(DATE_NAISS_J,"/",DATE_NAISS_M,"/",DATE_NAISS_A,sep="")
                                                        , format="%d/%m/%Y"))/365.25)))
# Calcul de l'anciennete en mois
r_individu_OK=mutate(r_individu_OK
                     ,ANCIENNETE = floor(as.numeric((as.Date(Date_fin)
                                                     -as.Date(DATE_CREATION_CARTE, format="%d/%m/%Y"))/30))) 

# Borne metier pour l'age 
r_individu_OK$AGE=ifelse(r_individu_OK$AGE < 15, NA, r_individu_OK$AGE)
r_individu_OK$AGE=ifelse(r_individu_OK$AGE >90, NA, r_individu_OK$AGE)

# Date superieure a la creation du programme
r_individu_OK$ANCIENNETE=ifelse(r_individu_OK$ANCIENNETE >130, NA, r_individu_OK$ANCIENNETE)


# Validation
summarise_at(r_individu_OK
             ,vars(AGE,ANCIENNETE)
             ,funs(min(., na.rm = TRUE),mean(., na.rm = TRUE),max(., na.rm = TRUE)))

rm(R_INDIVIDU)

##############################################################################
# Sur les TICKETS : correction des tickets gratuits 
##############################################################################
# Si le modele est dans FAVO FAVORI alors le PRIX_OK = 0
Matrice_travail_OK = mutate(r_Matrice_travail
                            ,PRIX_OK = ifelse(MODELE %in% c("FAVO","FAVORI"),0,PRIX_AP_REMISE))
#Validation
Matrice_travail_OK %>% filter(MODELE %in% c("FAVO","FAVORI")) %>% group_by(MODELE) %>% summarise(sortie = max(PRIX_OK))
View(Matrice_travail_OK)

# Retouche du decoupage Centre ville 
table(Matrice_travail_OK$CENTRE_VILLE)
Matrice_travail_OK$CENTRE_VILLE = case_when(Matrice_travail_OK$CENTRE_VILLE=="" ~ "NC"
                                            , Matrice_travail_OK$CENTRE_VILLE %in% c("Centre Co","Centre Commercial")~"CENTRE_COMMERCIAL"
                                            , Matrice_travail_OK$CENTRE_VILLE %in% c("Centre ville")~"CENTRE_VILLE")
#Validation
count(Matrice_travail_OK,CENTRE_VILLE)

rm(r_Matrice_travail)


########################################################################################################### 
########################################################################################################### 

#/****************************************/
#/*****  ANALYSE PAR VISITE       	*****/
#/****************************************/

# Statistiques par visite
r_Visite = Matrice_travail_OK %>% group_by(ID_INDIVIDU,CODE_BOUTIQUE,DATE_ACHAT,NUM_TICKET) %>% 
  summarise(NB_PRODUITS = sum(QUANTITE), CA_VISITE = sum(PRIX_OK))
#Calcul du prix moyen
r_Visite = mutate(r_Visite, PRIX_MOYEN=CA_VISITE/NB_PRODUITS)

# Validation
r_Visite[1:10,]
filter(r_Visite, ID_INDIVIDU==4)

#/****************************************/
#/*****  ANALYSE PAR VISITE PAYANTE  *****/
#/****************************************/
r_Indicateurs_achats = r_Visite %>% group_by(ID_INDIVIDU) %>%
  summarise(
    MONTANT_CUMULE = sum(CA_VISITE)
    , NB_VISITE = n()
    , CA_MOY_VISITE = mean(CA_VISITE)
    , NB_PRDT_MOY_VISITE = mean(NB_PRODUITS)
  )

#Validation
filter(r_Indicateurs_achats, ID_INDIVIDU==4)

dim(r_Indicateurs_achats)


#/***************************************/
#/******	INDICATEURS PAR INDIVIDU	*****/
#/***************************************/

#/************************/
#	RECENCE ACHAT	
# On conserve la visite la plus recente
r_Recence = r_Visite %>% group_by(ID_INDIVIDU) %>% summarise(
  date_plus_recente = max(as.Date(DATE_ACHAT, "%d/%m/%Y"))) %>%
  mutate(RECENCE = trunc(as.numeric((as.Date(Date_fin)-as.Date(date_plus_recente, format="%d/%m/%Y"))))) %>%
  select(ID_INDIVIDU,RECENCE)



#/************************/
# NB MAG DIFFERENTS / NB LIGNES / NB FAMILLES / NB CADEAUX
r_Indicateurs_supplementaire = Matrice_travail_OK %>% 
  group_by(ID_INDIVIDU) %>%
  summarise(
    # ECLECTISME : nombre de magasins differents
    NB_MAG_DIFF=n_distinct(CODE_BOUTIQUE,na.rm=TRUE)
    # NB lignes differentes
    , NB_LIGNE_DIFF=n_distinct(Ligne,na.rm=TRUE)
    # NB familles diferentes             
    , NB_FAM_DIFF = n_distinct(Famille,na.rm=TRUE)
    # Nb_cadeaux
    , NB_CADEAUX = sum(ifelse(MODELE %in% c("FAVO","FAVORI") | PRIX_OK == 0,1,0))
  )

filter(r_Indicateurs_supplementaire,ID_INDIVIDU == "1396")

#/************************/
# PART MAGASIN GESTIONNAIRE

# L'information du magasin gestionnaire est dans la table r_individu_OK mais 
# Pas dans la table des visites donc on l'ajoute

# Ajout de l'information du magasin gestionnaire
Part_mag_gestion = left_join(r_Visite
                             , select(r_individu_OK,ID_INDIVIDU,MAGASIN_GESTIONNAIRE)
                             , by = "ID_INDIVIDU") %>%
  # creation d'une variable = 1 si achat dans le magasin gestionnaire 
  mutate(Top_mag = ifelse(MAGASIN_GESTIONNAIRE==CODE_BOUTIQUE,1,0)) %>%
  # Part des achats dans le magasin gestionnaire
  group_by(ID_INDIVIDU) %>%
  summarise(PART_VIST_MAG_GEST = sum(Top_mag)/n())

filter(Part_mag_gestion,ID_INDIVIDU=="1396")



#/************************/
#/***** REGROUPEMENT	****/
#/************************/

# Retouche dans R_MAGASIN De l'information sur le centre ville
R_MAGASIN$CENTRE_VILLE = case_when(R_MAGASIN$CENTRE_VILLE=="" ~ "NC"
                                   , R_MAGASIN$CENTRE_VILLE %in% c("Centre Co","Centre Commercial")~"CENTRE_COMMERCIAL"
                                   , R_MAGASIN$CENTRE_VILLE %in% c("Centre ville")~"CENTRE_VILLE")
count(R_MAGASIN,CENTRE_VILLE)

r_Matrice_finale = select(r_individu_OK,ID_INDIVIDU,AGE,ANCIENNETE,MAGASIN_GESTIONNAIRE,SEXE,CIVILITE) %>%
  # Information sur le magasin
  left_join(select(R_MAGASIN,CODE_BOUTIQUE,REGIONS,CENTRE_VILLE,TYPE_MAGASIN)
            , by = c("MAGASIN_GESTIONNAIRE" = "CODE_BOUTIQUE")) %>%
  # Sur les achats
  left_join(r_Indicateurs_achats
            , by="ID_INDIVIDU") %>%
  # Sur la recence
  left_join(r_Recence
            , by="ID_INDIVIDU") %>%
  # Sur les indicateurs supplementaires
  left_join(r_Indicateurs_supplementaire
            , by="ID_INDIVIDU") %>%
  # Par magasin gestionnaire
  left_join(Part_mag_gestion
            , by="ID_INDIVIDU")

count(r_Matrice_finale,CENTRE_VILLE)




########################################################################################################### 
########################################################################################################### 
# Construction de la segmentation RFM

#/********************************/
#/***** FREQUENCE & MONTANT	*****/
#/********************************/

#/***** Decoupage Mtt *****/
Resultat_M = mutate(r_Matrice_finale
                    ,MONTANT_CUMUL_TR=cut(MONTANT_CUMULE
                                          , breaks=quantile(MONTANT_CUMULE, probs=c(0:3/3),na.rm=TRUE)
                                          , labels=0:2,include.lowest=TRUE))

#Validation
count(Resultat_M,MONTANT_CUMUL_TR)
Resultat_M %>% group_by(MONTANT_CUMUL_TR) %>%
  summarise(N=n(),
            Min=min(MONTANT_CUMULE),
            Max=max(MONTANT_CUMULE))


#/***** Decoupage Frequence *****/
#calcul_quantile
seuil = quantile(Resultat_M$NB_VISITE, probs=seq(0,1,1/3),na.rm=TRUE)
seuil[1]=0
Resultat_M = mutate(Resultat_M
                    ,FREQUENCE_TR=cut(NB_VISITE
                                      , breaks=seuil
                                      , labels=0:2,include.lowest=TRUE))

#Validation
count(Resultat_M,FREQUENCE_TR)
Resultat_M %>% group_by(FREQUENCE_TR) %>%
  summarise(N=n(),
            Min=min(NB_VISITE),
            Max=max(NB_VISITE))


#/***** Regroupement *****/
Resultat_FM = Resultat_M 
Resultat_FM$FM = case_when(Resultat_FM$FREQUENCE_TR == 0 & Resultat_FM$MONTANT_CUMUL_TR == 0 ~ 0
                           ,  Resultat_FM$FREQUENCE_TR == 0 & Resultat_FM$MONTANT_CUMUL_TR == 1 ~ 0
                           ,  Resultat_FM$FREQUENCE_TR == 0 & Resultat_FM$MONTANT_CUMUL_TR == 2 ~ 1
                           ,  Resultat_FM$FREQUENCE_TR == 1 & Resultat_FM$MONTANT_CUMUL_TR == 0 ~ 0
                           ,  Resultat_FM$FREQUENCE_TR == 1 & Resultat_FM$MONTANT_CUMUL_TR == 1 ~ 1
                           ,  Resultat_FM$FREQUENCE_TR == 1 & Resultat_FM$MONTANT_CUMUL_TR == 2 ~ 2
                           ,  Resultat_FM$FREQUENCE_TR == 2 & Resultat_FM$MONTANT_CUMUL_TR == 0 ~ 1
                           ,  Resultat_FM$FREQUENCE_TR == 2 & Resultat_FM$MONTANT_CUMUL_TR == 1 ~ 2
                           ,  Resultat_FM$FREQUENCE_TR == 2 & Resultat_FM$MONTANT_CUMUL_TR == 2 ~ 2
                           ,  TRUE ~ 99)

#Validation
count(Resultat_FM,FM)


######################################
#              RECENCE 		
######################################
r_RFM = mutate(Resultat_FM
               ,RECENCE_TR=cut(RECENCE
                               , breaks=quantile(RECENCE, probs=c(0:3/3),na.rm=TRUE)
                               , labels=0:2
                               , include.lowest=TRUE))

#Validation
count(r_RFM,RECENCE_TR)
r_RFM %>% group_by(RECENCE_TR) %>%
  summarise(N=n(),
            Min=min(RECENCE),
            Max=max(RECENCE))


#/********************************/
#/***** Calcul des Segments	*****/
#/********************************/
# Construction des segments
names(r_RFM)
r_RFM$SEGMENTv2 = case_when(
  r_RFM$RECENCE_TR == 0 & r_RFM$FM == 2 ~ "9"
  , r_RFM$RECENCE_TR == 1 & r_RFM$FM == 2 ~ "8"
  , r_RFM$RECENCE_TR == 2 & r_RFM$FM == 2 ~ "7"
  , r_RFM$RECENCE_TR == 0 & r_RFM$FM == 1 ~ "6"
  , r_RFM$RECENCE_TR == 1 & r_RFM$FM == 1 ~ "5"
  , r_RFM$RECENCE_TR == 2 & r_RFM$FM == 1 ~ "4"
  , r_RFM$RECENCE_TR == 0 & r_RFM$FM == 0 ~ "3"
  , r_RFM$RECENCE_TR == 1 & r_RFM$FM == 0 ~ "2"
  , r_RFM$RECENCE_TR == 2 & r_RFM$FM == 0 ~ "1"
)


#NOUVEAUX
r_RFM$SEGMENTv2 =  ifelse(is.na(r_RFM$ANCIENNETE) == FALSE & r_RFM$ANCIENNETE <24,"10",r_RFM$SEGMENTv2)

#INACTIFS
r_RFM$SEGMENTv2 =  ifelse(r_RFM$MONTANT_CUMULE == 0,"11",r_RFM$SEGMENTv2)
r_RFM$SEGMENTv2 =  ifelse(is.na(r_RFM$MONTANT_CUMULE) =="TRUE","11",r_RFM$SEGMENTv2)

#Validation
table(r_RFM$FM,r_RFM$RECENCE_TR)
table(r_RFM$SEGMENTv2,useNA='ifany')

# Ecriture des libelles
r_RFM$TYPO    =  case_when(r_RFM$SEGMENTv2 %in% c("8","9") ~"01_TRES_BONS"
                           ,  r_RFM$SEGMENTv2 %in% c("5","6") ~"02_BONS"
                           ,  r_RFM$SEGMENTv2 %in% c("4","7") ~"03_PERTES"
                           ,  r_RFM$SEGMENTv2 %in% c("2","3") ~"04_PETITS"
                           ,  r_RFM$SEGMENTv2 %in% c("1") ~"05_FAIBLES"
                           ,  r_RFM$SEGMENTv2 %in% c("10") ~"06_NOUVEAUX"
                           ,  r_RFM$SEGMENTv2 %in% c("11") ~"07_INACTIFS")


# Comptages et 1ers resultats 
table(r_RFM$SEGMENTv2,useNA = "ifany")
table(r_RFM$TYPO,useNA = "ifany")




