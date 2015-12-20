##Etape 1 : remplir la base.
Executer le fichier populatedb qui se trouve dans le dossier bin qui va creer et remplir la base user et metrics_user
Pour information:
compte1=> login:root password:root
compte2=> login:root2 password:root2

##Etape2 : demarrer le serveur
Executer le fichier start qui se trouve dans bin
Lien pour acceder au serveur: localhost:1337

##Etape3 : creation de compte
cliquer sur le bouton signup et remplir les informations
Attention le mail doit contenir le caractere '@' pour etre valable.
##NE PAS METTRE DE POINT '.' DANS LE MAIL sinon probleme au niveau du split quand on va recuprer les données.

##Etape4: acces au compte
Apres avoir creer le compte clique sur le bouton login.
Rentrer les identifiants du compte que vous avez crée ou les comptes root ou root2

##Etape5: page user
Le premier formulaire vous permet de sauvegarder vos metrics
Le deuxieme formulaire les supprimées
Le bouton GetData permet de visualiser les metrics de manière brute.
Le bouton logout permet de se deconnecter de son compte.
Les fonctions delete user et delete metrics_user ne fonctionne pas.
