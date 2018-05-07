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

# ANNEXE Dernière partie de code implémentée

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

```