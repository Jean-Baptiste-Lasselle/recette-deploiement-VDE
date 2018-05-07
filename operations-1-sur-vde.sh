#!/bin/bash
# Hôte Ubuntu 16.x


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
# Donc juste pour faire quelques petits tests de commandes, dont l'étape 1 du process de provision suivant:
# (M1 et M2 peuvent-elles être des machoin es virtuelles, montées en bridge su rle réseau ethernet local, elle pourraient permettre d'éumler un switch....?)
# 1 - créer un switch virtuel sur la machine M1
# 2 - créer un switch virtuel sur la machine M2
# 3 - configurer les 2 switchs en mode fast tree span (requis pour pouvoir brancher 2 switchs, sans provoquer de routage ethernet circulaire)
# 4 - configurer une machine virtuel VM1 dans l'hôte de virutalisation de M1, et configurer son branchement au switch de la machine M1
# 5 - configurer une machine virtuel VM dans l'hôte de virutalisation de M1, et configurer son branchement au switch de la machine M2
# 6 - TEST : mettre mon pixie node dans une dess 2 VMs, et tenter de pixie booter l'autre VM

# -
# Dixit [http://wiki.v2.cs.unibo.it/wiki/index.php?title=VDE_Basic_Networking]
# Each switch has a directory where it keeps all its temporary files. This directory is also used as the name of the switch. 
sudo vde_switch -s /tmp/switch1



# ----->>>> Donc, ici, la suite de la recette suppose que M1 et M2 soit les hôtes de virtualisation VirutalBox:
#            
#            Il faut que VBoxManage.exe ait localement accès sur le système de fichiers, à [/tmp/switch1], et en plus, que
#            ce dossier ait la même  sémantique de méta-données que dans un syustèle linux Ubuntu, (version Ubuntu testée
#            pour ces sciripts). 
#            TODO: convertir ces appels locaux VBoxMAnage, en appel de la REST API VirutalBox.
# -
# Dixit [https://www.virtualbox.org/manual/ch06.html]
# 
# Configuration via command-line:
export ID_VM_VIRTUALBOX
export NUMERO_NIC_VM_VIRTUALBOX
VBoxManage modifyvm "$ID_VM_VIRTUALBOX" --nic<$NUMERO_NIC_VM_VIRTUALBOX> generic
VBoxManage modifyvm "$ID_VM_VIRTUALBOX" --nicgenericdrv<$NUMERO_NIC_VM_VIRTUALBOX> VDE

# To connect to automatically allocated switch port, use:
VBoxManage modifyvm "$ID_VM_VIRTUALBOX" --nicproperty<$NUMERO_NIC_VM_VIRTUALBOX> network=/tmp/switch1

# To connect to specific switch port <n>, use:
# (le même port que pour les VLANs définits avec VDE)
VBoxManage modifyvm "$ID_VM_VIRTUALBOX" --nicproperty<$NUMERO_NIC_VM_VIRTUALBOX> network=/tmp/switch1[<n>]

# The latter option can be useful for VLANs.
# Optionally map between VDE switch port and VLAN: (from switch CLI)
# export VLAN_ID=kytes-vde-vlan
# export VLAN_PORT1=5654
# export VLAN_PORT2=5655
# export VLAN_PORT3=5656
# # etc...

# Possible que les 2 commandes ci-dessous, il faille les exécuter dans leur OS spécifique, cf.: [http://wiki.v2.cs.unibo.it/wiki/index.php?title=Introduction#View_OS] 
# vlan/create $VLAN_ID
# port/setvlan $VLAN_PORT1 $VLAN_ID
# - 
# Et hop, on connecterait une VM au VLAN, de la manière suivante:
VBoxManage modifyvm "$ID_VM_VIRTUALBOX" --nicproperty<$NUMERO_NIC_VM_VIRTUALBOX> network=/tmp/switch1[<$VLAN_PORT1>]
VBoxManage modifyvm "$ID_VM_VIRTUALBOX" --nicproperty<x> network=/tmp/switch1[<n>]
