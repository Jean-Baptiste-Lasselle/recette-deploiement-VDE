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

# 
# 
# 
# 
# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< #
# >>>>>>>>>>>>>> CREATION DU SWITCH VDE SUR HÔTE VIRTUZALISATION <<<<<<<<<<<<<<< #
# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< #
# - 
# Dixit [http://wiki.v2.cs.unibo.it/wiki/index.php?title=VDE_Basic_Networking]
# Each switch has a directory where it keeps all its temporary files. This directory is also used as the name of the switch. 
sudo vde_switch -s /tmp/switch1
# le process reste en suspens, et si on presse une seule fois la touche entrée, on
# tombe dans un nouveau shell interactif, avec comme invite de commande "vde$":






# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< #
# >>>>>>>>>>>>>>>>>> CREATION DE VLAN AVEC UN SWITCH VDE <<<<<<<<<<<<<<<<<<<<<<< #
# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< #
# Voir aussi: [http://wiki.v2.cs.unibo.it/wiki/index.php?title=Introduction#View_OS] 
# À voir les utilsiations que je peux faire de cet OS de switch virtuel.
# >>>>> Quand on a lancé la commande de création du switch virtuel:
#			[sudo vde_switch -s /tmp/switch1]
# le process reste en suspens, et si on presse une seule fois la touche entrée, on
# tombe dans un nouveau shell interactif, avec comme invite de commande "vde$":
# C'est alors qu'on peut exécuter les commandes:
# 
# 
# 
# 
# 
# 					vde$ vlan/create $VLAN_ID
# 					vde$ port/setvlan $VLAN_PORT1 $VLAN_ID
# 
# 
# 
# 
# 
# Le documentation officielle VDE appelle ce shelle interactif:
#                "(the VDE switch CLI)"






# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< #
# >>>>>>>>>>>>>> CONFIGURATION DES VMs BRANCHEMENT AU LAN/VLAN <<<<<<<<<<<<<<<<< #
# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< #
# 
# ----->>>> Donc, ici, la suite de la recette suppose que M1 et M2 soit les hôtes de virtualisation VirutalBox:
#            
#            Il faut que VBoxManage.exe ait localement accès sur le système de fichiers, à [/tmp/switch1], et en plus, que
#            ce dossier ait la même  sémantique de méta-données que dans un syustèle linux Ubuntu, (version Ubuntu testée
#            pour ces sciripts). 
#            TODO: convertir ces appels locaux VBoxMAnage, en appel de la REST API VirutalBox.
# -
# Dixit [https://www.virtualbox.org/manual/ch06.html]
# 
# Avec l'exécutable (inclut dans le distribution VirtualBox) VBoxManage:
export ID_VM_VIRTUALBOX
export NUMERO_NIC_VM_VIRTUALBOX
VBoxManage modifyvm "$ID_VM_VIRTUALBOX" --nic<$NUMERO_NIC_VM_VIRTUALBOX> generic
VBoxManage modifyvm "$ID_VM_VIRTUALBOX" --nicgenericdrv<$NUMERO_NIC_VM_VIRTUALBOX> VDE

# To connect to automatically allocated switch port, use:
VBoxManage modifyvm "$ID_VM_VIRTUALBOX" --nicproperty<$NUMERO_NIC_VM_VIRTUALBOX> network=/tmp/switch1

# To connect to specific switch port <n>, use:
# (le  port doit donc être créé, et il peut être créé avec les commandes précisées ci-dessous, dans la partie :
# >>>>>>>>>>>>>>>>>> CREATION DE VLAN AVEC UN SWITCH VDE <<<<<<<<<<<<<<<<<<<<<<< #
# Supposons que l'on ait créé un VLAN et configuré un port sur ce VLAN, et que le numéro de ce port soit:
# export VLAN_PORT1=5654
# Alors, pour connecter une machine VirtualBOx au VLAN, par ce numéro de port, on fait:
VBoxManage modifyvm "$ID_VM_VIRTUALBOX" --nicproperty<$NUMERO_NIC_VM_VIRTUALBOX> network=/tmp/switch1[<$VLAN_PORT1>]
# On rermarquera que la commande permet de désigner un switch particulier, et non un VLAN_ID particulier.
# Peut-il être possible de créer plusieurs VLANs définit sur le même switch VDE?


