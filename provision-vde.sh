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
# export MAISON_OPERATIONS
# MAISON_OPERATIONS=$(pwd)/provision-vde
# # -
# export NOMFICHIERLOG
# NOMFICHIERLOG="$(pwd)/provision-vde.log"


# export REPERTOIRE_VDE
# export REPERTOIRE_VDE_PAR_DEFAUT
# REPERTOIRE_VDE_PAR_DEFAUT=/opt/vde
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
##############################################################################################################################################
#########################################							OPS								##########################################
##############################################################################################################################################
# --------------------------------------------------------------------------------------------------------------------------------------------

sudo apt-get install -y vde2
sudo apt-get install -y umview umview-mod-umfuseiso9660 umview-mod-umfuseext2 umview-mod-umlwip umview-mod-umdevtap
