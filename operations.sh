#!/bin/bash
# Hôte Ubuntu 16.x
																						

# DOCKER BARE-METAL-INSTALL - CentOS 7
# sudo systemctl stop docker
# sudo systemctl start docker


# --------------------------------------------------------------------------------------------------------------------------------------------
##############################################################################################################################################
#########################################							ENV								##########################################
##############################################################################################################################################
# --------------------------------------------------------------------------------------------------------------------------------------------
export MAISON_OPERATIONS
MAISON_OPERATIONS=$HOME/provision-vde
# -
export NOMFICHIERLOG
NOMFICHIERLOG="$MAISON_OPERATIONS/provision-vde.log"



######### -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -
######### -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -
# -
									# export ADRESSE_IP_SRV_GOGS
									# export ADRESSE_IP_SRV_GOGS_PAR_DEFAUT
									# ADRESSE_IP_SRV_GOGS_PAR_DEFAUT=0.0.0.0
# - 
# export ADRESSE_IP_SRV_GOGS
# export ADRESSE_IP_SRV_GOGS_PAR_DEFAUT
# ADRESSE_IP_SRV_GOGS_PAR_DEFAUT=0.0.0.0
# - 
# export NO_PORT_SRV_GOGS
# export NO_PORT_SRV_GOGS_PAR_DEFAUT
# NO_PORT_SRV_GOGS_PAR_DEFAUT=4000
# - 
# export NO_PORT_SSH_SRV_GOGS
# export NO_PORT_SSH_SRV_GOGS_PAR_DEFAUT
# NO_PORT_SSH_SRV_GOGS_PAR_DEFAUT=23
# - 
# export VARIABLE_D_ENVIRONNEMENT
# export VARIABLE_D_ENVIRONNEMENT_PAR_DEFAUT
# VARIABLE_D_ENVIRONNEMENT_PAR_DEFAUT=0.0.0.0
# -
# export NO_PORT_BDD_GOGS
# export NO_PORT_BDD_GOGS_PAR_DEFAUT
# NO_PORT_BDD_GOGS_PAR_DEFAUT=8564
# -
# export MOTDEPASSEBDDGOGS
# export MOTDEPASSEBDDGOGS_PAR_DEFAUT
# MOTDEPASSEBDDGOGS_PAR_DEFAUT=punkybrewster
######### -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -
######### -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -


export REPERTOIRE_VDE
export REPERTOIRE_VDE_PAR_DEFAUT
REPERTOIRE_VDE_PAR_DEFAUT=/opt/vde


# --------------------------------------------------------------------------------------------------------------------------------------------
##############################################################################################################################################
#########################################							FONCTIONS						##########################################
##############################################################################################################################################

# --------------------------------------------------------------------------------------------------------------------------------------------
# Cette fonction permet de ...
nomDeFonction () {

	# echo "Quelle adresse IP souhaitez-vous que le SGBDR de la BDD Gogs utilise?"
	# echo "Cette adresse est à  choisir parmi:"
	# echo " "
	# ip addr|grep "inet"|grep -v "inet6"|grep "enp\|wlan"
	# echo " "
	# read VALEUR_CHOISIE_PAR_UTILISATEUR
	# if [ "x$VALEUR_CHOISIE_PAR_UTILISATEUR" = "x" ]; then
       # VARIABLE_D_ENVIRONNEMENT=VARIABLE_D_ENVIRONNEMENT_PAR_DEFAUT
	# else
	# VARIABLE_D_ENVIRONNEMENT=$VALEUR_CHOISIE_PAR_UTILISATEUR
	# fi
	# echo " Binding Adresse IP choisit pour le SGBDR de la BDD Gogs: $VARIABLE_D_ENVIRONNEMENT";
}
# --------------------------------------------------------------------------------------------------------------------------------------------
# Cette fonction permet de demander quelquechose interactivement à l'utilisateur...
demander_QuelqueChose () {

	# echo "Quelle est votre question?"
	# echo "Indication:"
	# echo " "
	# # une comande qui affiche des informations donnant des indications
	# echo " "
	# read VALEUR_CHOISIE_PAR_UTILISATEUR
	# if [ "x$VALEUR_CHOISIE_PAR_UTILISATEUR" = "x" ]; then
       # VARIABLE_D_ENVIRONNEMENT=VARIABLE_D_ENVIRONNEMENT_PAR_DEFAUT
	# else
	# VARIABLE_D_ENVIRONNEMENT=$VALEUR_CHOISIE_PAR_UTILISATEUR
	# fi
	# echo " Binding Adresse IP choisit pour le SGBDR de la BDD Gogs: $VARIABLE_D_ENVIRONNEMENT";
}

# --------------------------------------------------------------------------------------------------------------------------------------------
# Cette fonction permet de re-synchroniser l'hôte docker sur un serveur NTP, sinon# certaines installations dépendantes
# de téléchargements avec vérification de certtificat SSL
synchroniserSurServeurNTP () {
	# ---------------------------------------------------------------------------------------------------------------------------------------------
	# ------	SYNCHRONSITATION SUR UN SERVEUR NTP PUBLIC (Y-en-a-til des gratuits dont je puisse vérifier le certificat SSL TLSv1.2 ?)
	# ---------------------------------------------------------------------------------------------------------------------------------------------
	# ---------------------------------------------------------------------------------------------------------------------------------------------
	# ---	Pour commencer, pour ne PAS FAIRE PETER TOUS LES CERTIFICATS SSL vérifiés pour les installation apt-get
	# ---	
	# ---	Sera aussi utilise pour a provision de tous les noeuds d'infrastructure assurant des fonctions d'authentification:
	# ---		Le serveur Free IPA Server
	# ---		Le serveur OAuth2/SAML utilisé par/avec Free IPA Server, pour gérer l'authentification 
	# ---		Le serveur Let's Encrypt et l'ensemble de l'infrastructure à clé publique gérée par Free IPA Server
	# ---		Toutes les macines gérées par Free-IPA Server, donc les hôtes réseau exécutant des conteneurs Girofle
	# 
	# 
	# >>>>>>>>>>> Mais en fait la synchronisation NTP doit se faire sur un référentiel commun à la PKI à laquelle on choisit
	# 			  de faire confiance pour l'ensemble de la provision. Si c'est une PKI entièrement interne, alors le système 
	# 			  comprend un repository linux privé contenant tous les packes à installer, dont docker-ce.
	# 
	# ---------------------------------------------------------------------------------------------------------------------------------------------
	echo "date avant la re-synchronisation [Serveur NTP=$SERVEUR_NTP :]" >> $NOMFICHIERLOG
	date >> $NOMFICHIERLOG
	sudo which ntpdate
	sudo apt-get install -y ntp ntpdate
	sudo ntpdate 0.us.pool.ntp.org
	echo "date après la re-synchronisation [Serveur NTP=$SERVEUR_NTP :]" >> $NOMFICHIERLOG
	date >> $NOMFICHIERLOG
	# pour re-synchroniser l'horloge matérielle, et ainsi conserver l'heure après un reboot, et ce y compris après et pendant
	# une coupure réseau
	sudo hwclock --systohc
}
# synchroniserSurServeurNTP
# --------------------------------------------------------------------------------------------------------------------------------------------
##############################################################################################################################################
#########################################							OPS								##########################################
##############################################################################################################################################
# --------------------------------------------------------------------------------------------------------------------------------------------


rm  -rf $MAISON_OPERATIONS
mkdir -p $MAISON_OPERATIONS
cd $MAISON_OPERATIONS
rm -f $NOMFICHIERLOG
touch $NOMFICHIERLOG

echo " +++provision+VDE+  COMMENCEE  - " >> $NOMFICHIERLOG
synchroniserSurServeurNTP >> $NOMFICHIERLOG

# PARTIE INTERACTIVE
# clear
# echo " "
# echo "##########################################################"
# echo "##########################################################"
# echo " "

# demander_QuelqueChose


echo " " >> $NOMFICHIERLOG
echo "##########################################################" >> $NOMFICHIERLOG
echo "##########################################################" >> $NOMFICHIERLOG
echo "# Récapitulatif:" >> $NOMFICHIERLOG
echo " 		[VARIABLE_D_ENVIRONNEMENT=$VARIABLE_D_ENVIRONNEMENT]" >> $NOMFICHIERLOG
clear
echo " "
echo "##########################################################"
echo "##########################################################"
echo "# Récapitulatif:"
echo " 		[VARIABLE_D_ENVIRONNEMENT=$VARIABLE_D_ENVIRONNEMENT]"
echo " "
echo " "
echo " "
echo " "
echo "##########################################################"
echo "##########################################################"

echo "########### "
echo "########### "
echo "########### Installation vde en cours..."
echo "########### "

# PARTIE SILENCIEUSE

# on rend les scripts à exécuter, exécutables.
sudo chmod +x ./provision-vde.sh >> $NOMFICHIERLOG

# provision hôte docker
./provision-vde.sh >> $NOMFICHIERLOG


# Et là, on SAIT , que l'ensemble a été provisionné correctement)
echo " +++provision+vde+  Votre serveur Gogs est disponible à l'URI:" >> $NOMFICHIERLOG
echo " +++provision+vde+  	[http://$ADRESSE_IP_SRV_GOGS:$NO_PORT_SRV_GOGS/]" >> $NOMFICHIERLOG
clear
echo " +++provision+vde+  --- " >> $NOMFICHIERLOG
echo " +++provision+vde+  Votre serveur Gogs est disponible à l'URI:" >> $NOMFICHIERLOG
echo " +++provision+vde+  - " >> $NOMFICHIERLOG
echo " +++provision+vde+  	[http://$ADRESSE_IP_SRV_GOGS:$NO_PORT_SRV_GOGS/]" >> $NOMFICHIERLOG
echo " +++provision+vde+  --- " >> $NOMFICHIERLOG
echo " +++provision+vde+  Le log des opérations de provisions vde sont disponibles dans le fichier:" >> $NOMFICHIERLOG
echo " +++provision+vde+  - " >> $NOMFICHIERLOG
echo " +++provision+vde+  	[$NOMFICHIERLOG]" >> $NOMFICHIERLOG
echo " +++provision+vde+  - " >> $NOMFICHIERLOG
echo " +++provision+vde+  TERMINEE  - " >> $NOMFICHIERLOG
echo " +++provision+vde+  - " >> $NOMFICHIERLOG