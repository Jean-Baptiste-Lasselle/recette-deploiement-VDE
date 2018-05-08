# recette-deploiement-VDE
Une recette de déploiement de VDE dans une VM centos 7 VirtualBox

# Utilisation de la recette

```
mkdir -p recette-provision-vde
cd recette-provision-vde
git clone "https://github.com/Jean-Baptiste-Lasselle/recette-deploiement-VDE" .
sudo chmod +x ./operations.sh
./operations.sh
```

# Structure du repo

* [operations.sh] : lance script à exécuter en premier
* [provision-vde.sh] : lance script à exécuter en premier
* [operations-1-sur-vde.sh] : provisionne un swith VDE sur l'hôte de virtualisation, et y connecte une machine virutelle virutalbox, soit en LAN, soit en VLAN.

# Plus de détails, et résultats premiers tests



## Création du switch VDE

```

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

```
Ce qui donne:

![Mon premier switch VDE, hung up](https://github.com/Jean-Baptiste-Lasselle/recette-deploiement-VDE/raw/master/doc/impr/mon-premier-switch-vde.png)

Lorsque l'on a  exécuté `sudo vde_switch -s /tmp/switch1` le process reste en suspens, et si on presse une seule fois la touche entrée, on tombe dans le shell interactif "VDE switch CLI":

![Mon premier switch VDE, entrée et passage au shell vde](https://github.com/Jean-Baptiste-Lasselle/recette-deploiement-VDE/raw/master/doc/impr/mon-premier-switch-vde-SHELL-INTERACTIF-VDE-1.png)


### Première Remarque

Lorsque la comande `sudo vde_switch -s /tmp/switch1`  est exécutée, le process de son exécution reste en suspens:

Puis, si l'on presse une seule fois la touche entrée, on entre dans une sorte de chel interactif:

Dans ce shell interactif, on peut faire diférentes choses, comme:

* Créer des VLAN et port VLAN cf. [Création d'un VLAN dans le switch VDE](#création-dun-vlan-dans-le-switch-vde)
* Sortir du shell interactif, pour revenir à la session linux de l'hôte de virutalisation (ubuntu en l'occurrence, masi j'ai vu qu'il y a des packages faits pour fedora, à voir le backport sur centos)

![shutdown-vde](https://github.com/Jean-Baptiste-Lasselle/recette-deploiement-VDE/raw/master/doc/impr/mon-premier-switch-vde-SHELL-INTERACTIF-VDE-5-QLQ-COMMANDES-commande-pour-eteindre-un-switch-VDE.png)

* exécuter toutes les commandes possibles, indiquées par l'aide:
  * aide vde dans le shell interactif `vde$`: (simplement taper la comande `help`). Première partie:
  
  ![Aide VDE, partie 1](https://github.com/Jean-Baptiste-Lasselle/recette-deploiement-VDE/raw/master/doc/impr/mon-premier-switch-vde-SHELL-INTERACTIF-VDE-6-vde-HELP1.png)
  
  * aide vde dans le shell interactif `vde$`: (simplement taper la comande `help`). Seconde partie:
  
  ![Aide VDE, partie 2](https://github.com/Jean-Baptiste-Lasselle/recette-deploiement-VDE/raw/master/doc/impr/mon-premier-switch-vde-SHELL-INTERACTIF-VDE-6-vde-HELP2.png)
  
  * Exemple de commandes VDE trouvées dans la doc, sagement appliquées:
  
  ![Aide VDE, partie 2](https://github.com/Jean-Baptiste-Lasselle/recette-deploiement-VDE/raw/master/doc/impr/mon-premier-switch-vde-SHELL-INTERACTIF-VDE-6-vde-HELP3-exemples.png)
  
## Branchement des VMs au switch (donc au LAN)
 
```
# ----->>>> Donc, ici, la suite de la recette suppose que M1 et M2 soit les hôtes de virtualisation VirutalBox:
#            
#            Il faut que VBoxManage.exe ait localement accès sur le système de fichiers, à [/tmp/switch1], et en plus, que
#            ce dossier ait la même  sémantique de méta-données que dans un syustèle linux Ubuntu, (version Ubuntu testée
#            pour ces sciripts). 
#            TODO: convertir ces appels locaux VBoxMAnage, en appel de la REST API VirutalBox.
# -
# Dixit [https://www.virtualbox.org/manual/ch06.html]
# 
# Avec l'exécutable (inclut dans la distribution VirtualBox) VBoxManage:
export ID_VM_VIRTUALBOX
export NUMERO_NIC_VM_VIRTUALBOX
VBoxManage modifyvm "$ID_VM_VIRTUALBOX" --nic<$NUMERO_NIC_VM_VIRTUALBOX> generic
VBoxManage modifyvm "$ID_VM_VIRTUALBOX" --nicgenericdrv<$NUMERO_NIC_VM_VIRTUALBOX> VDE

# To connect to automatically allocated switch port, use:
VBoxManage modifyvm "$ID_VM_VIRTUALBOX" --nicproperty<$NUMERO_NIC_VM_VIRTUALBOX> network=/tmp/switch1

```

Aucune impression écran fiate, le test doit être fait sur un hôte de virtualisation, pour être validé.


## Création d'un VLAN dans le switch VDE

```

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
# 					vde$ # -------------------------------------------------------
# 					vde$ # N.B.: malheureusement, il n'est pas possible de définir
# 					vde$ # N.B.: des variables d'environnements dans le
# 					vde$ # N.B.: shell interactif VDE, mais il faudra regarder 
# 					vde$ # N.B.: d'autres angles opérationnels possibles.
# 					vde$ # -------------------------------------------------------
# 					vde$ # --- Par contre, les commentaires lignes avec dièses 
# 					vde$ # --- sont possibles
# 					vde$ # -------------------------------------------------------
# 					vde$ # --- TODO: exécuter un script VDE?
# 					vde$ # -------------------------------------------------------
# 					vde$ vlan/create $VLAN_ID
# 					vde$ port/setvlan $VLAN_PORT1 $VLAN_ID
# 
# 
# 
# 
# 
# Le documentation officielle VDE appelle ce shelle interactif:
#                "(the VDE switch CLI)"

```


### Exemples d'exécution de commandes pour créer un VLAN

* aide vde dans le shell interactif `vde$`: (simplement taper la comande `help`) - Première partie:
  ![vue 1](https://github.com/Jean-Baptiste-Lasselle/recette-deploiement-VDE/raw/master/doc/impr/mon-premier-switch-vde-SHELL-INTERACTIF-VDE-2-QLQ-COMMANDES.png)
* aide vde dans le shell interactif `vde$`: (simplement taper la comande `help`) - Seconde partie:
  ![vue 2](https://github.com/Jean-Baptiste-Lasselle/recette-deploiement-VDE/raw/master/doc/impr/mon-premier-switch-vde-SHELL-INTERACTIF-VDE-3-QLQ-COMMANDES.png)

### Exemple de création de numéros de port pour ce VLAN:

* Erreur intéresante:

  ![Erreur intéressante, numéro de port VLAN dans switch VDE, dans VM VirtualBox](https://github.com/Jean-Baptiste-Lasselle/recette-deploiement-VDE/raw/master/doc/impr/mon-premier-switch-vde-SHELL-INTERACTIF-VDE-4-QLQ-COMMANDES-on-voit-pb-creatrion-VLAN-DANS-VM-ubuntu.png)

   blablablabla
   
* Création avec succès, d'un port VLAN avec un numéro de port spécifique en suivant les indications de `HELP`:

  ![Création avec succès, en suivant les indications de l'aide VDE](https://github.com/Jean-Baptiste-Lasselle/recette-deploiement-VDE/raw/master/doc/impr/mon-premier-switch-vde-CREATION_VLAN_PORT_AVEC_NO_PORT_CHOISIT.png)

   Il faudra refaire le test pour exécuter ensuite `vlan/printall` pour voir l'affichage de toutes les infos de tous les VLAN définis (donc sur le VLAN `33`, on devrait voir un port de numéro `2`)
   

## Branchement des VMs à un VLAN créé dans le switch VDE

```

# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< #
# >>>>>>>>>>>>>>>>>> CONFIGURATION DES VMs BRANCHEMENT AU VLAN <<<<<<<<<<<<<<<<< #
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
# export ID_VM_VIRTUALBOX
# ->  On ajoute une seconde "NIC" (une carte réaseau) à la VM VirtualBox
export NUMERO_NIC_VM_VIRTUALBOX_VLAN
VBoxManage modifyvm "$ID_VM_VIRTUALBOX" --nic<$NUMERO_NIC_VM_VIRTUALBOX_VLAN> generic
VBoxManage modifyvm "$ID_VM_VIRTUALBOX" --nicgenericdrv<$NUMERO_NIC_VM_VIRTUALBOX_VLAN> VDE

# To connect to specific switch port <n>, use (technique utilisée pour connecter au VLANs):
# (le  port doit donc être créé, et il peut être créé avec les commandes précisées ci-dessous, dans la partie :
# >>>>>>>>>>>>>>>>>> CREATION DE VLAN AVEC UN SWITCH VDE <<<<<<<<<<<<<<<<<<<<<<< #
# Supposons que l'on ait créé un VLAN et configuré un port sur ce VLAN, et que le numéro de ce port soit:
export VLAN_PORT1=5654
# Alors, pour connecter une machine VirtualBOx au VLAN, par ce numéro de port, on fait:
VBoxManage modifyvm "$ID_VM_VIRTUALBOX" --nicproperty<$NUMERO_NIC_VM_VIRTUALBOX_VLAN> network=/tmp/switch1[<$VLAN_PORT1>]
# On rermarquera que la commande permet de désigner un switch particulier, et non un VLAN_ID particulier.
# Peut-il être possible de créer plusieurs VLANs définit sur le même switch VDE?


```


# TODOs

## évolution code

Le code de la recette a été modifié dans la docn, les mdoifications doivent être reportées sur le code lui-même, pour préparer la modularisation.
Bref, colle les trucs de code propre de ce README.md dans les scripts bash, stp.


# ANNEXE: kytes-green-grid


L'idée est d'un point du vue général, d'essayer de tirer le maximum du hardware présent, y compris en propsoant l'idée à des collègues qui ne
travaillent pas sur le même sujet, dans une même entreprise.

"
À midi, quand tu fermes ton pc, tu le switch en mode `kytes-green-grid-node`, ce qui reviens à donner ton autorisation à l'instance Kytes d'exploiter ta machine. Tudonnes cette autorisation impliciatement, en utilsiant l'application que je t'ai donnée sur ton téléphone portable, ou depuis ton poste lui-même.
"
L'appli mobile appelle un backend kytes, qui appelle l'agent installé sur le poste de la personne, etc...

Et pendant que tout le monde mange, les builds se font plus puissamment.


## OS sans disque dur
Puisque l'installation de l'OS sur les postes d'une entreprise  tierce peut-être compliquée à gérer en opérations, l'idéeest de se ddemander si 'lon peut faire la même chiose, en restant dans la RAM, sans jamais utiliser le disque dur?
Si entiuèrement dans la RAM, je peux faire tourner VDE et virutalbox et faire qu'ils utilsient un sysst-ème de fichiers entièrement dans la RAM, et qu'en plus l'hôte virutalbox 100% dans la RAM, puisse accéder au réseau, c'est bon
je peux faire l'exploitation du noeud kytes sans jamais tocuher au disque dur, jeuste à développer un pre execution  boot environnement, qui permet de swwitch en mode DHCP partiulier, avec un instrallateur anaconda customisé qui fait une installation 100% en RAM de lma distribution mlinux contenant VDE et virutalBOx.

Donc l'idée serait de ne jamais installer le linux dans lequel j'installe virtualbox et VDE
Mais au contraire de faire tourner l'OS entièrement en RAM, avec le serveur REST api virtual Box (comment configurer son authentification SAML Oauth2 ?)
Et la persistance des VM et des snapshots de VM, se fait par le réseau, le restore se fait par le réseau, et la VM est chargée dans un SGF entièrement en RAM (qui lui -même est sauvegardé /restauré) par le réseau.

On fait juste du compute à cet endroit, et les résultats partent là où ils  doivent partir dans l'usine logicielle, pour leur persistance.

### Exemple: Accès réseau et SGF avec Ubuntu 100%en RAM

à l'installation d'un ubuntu "desktop", on a deux options, "install Ubuntu", ou "Try Ubunutu". Cette deuxième option permet d'exécuter Ubuntu à 100% dans la RAM, en utilsiant un utilisateur spécifique, dit "guest".
Dans ce mode, et avec cet utilisateur, il n'est pas possible d'apporter le moindre changement au SGF dans la RAM.
Mais dans ce mode, on peut sans aucun problème accéder à Internet avec Mozilla:
Donc cette instance de mozilla (à vérifier) , modifie bel et bien le SGF en RAM:
TEST ==>> pour le vérifier, lje peux me connecter à la mon compte GMAIL, et avec firefox, faire "se souvenir de mon mot de passe", et consulter avec bash, en lecture seule, le SGF en RAM pour véirifier si des fichiers cookies on été créés etc...

SI c'eszt le cas, mozila utilsie certainement un autre utilsiateur linux que l'utilsiateur guest, pour faire ces modificatiuons de SGF à 100% en RAM.
Et je peux forcément packager un Ubuntu qui sera capable d'exécutr VDE et VRitualBOX en ne modifiant que le SGF en RAM, rien de plus que Mozilla Firefox.)

![Accès réseau et SGF avec Ubuntu 100%en RAM](https://github.com/Jean-Baptiste-Lasselle/recette-deploiement-VDE/raw/master/doc/impr/keytes-green-grid/vm-ubuntu-100-pourcent-RAM.png)

## Conteneurs natif
Les conteneurs Windows (les retourver dans le .NET framewworks, ils vont apparaître, et avec le PowerShell, puis ansible et chef.io)
 et Heroku peuvent donner des renfort de 2 périmètres réseaux différents.


