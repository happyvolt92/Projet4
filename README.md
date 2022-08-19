# Projet4
Développez Instagrid : une application de montage photo !

Instagrid est une application iPhone permettant aux utilisateurs de combiner des photos en
choisissant parmi plusieurs dispositions. Le résultat final est au format carré et partageable
avec ses amis.


## Compétences évaluées
- Interpréter les gestes sur un écran tactile
- Créer un design responsive à partir d'un mockup
- Mettre en place une architecture adaptée à son projet

Fonctionnalités
1. Sélection de la disposition des photos
Les photos sont organisés selon une disposition que l’utilisateur peut choisir. Les trois
dispositions disponibles
  
  En tapant sur l’une de ces dispositions :
1. La précédente disposition sélectionnée n’est plus marquée comme sélectionnée.
2. La sélection tapée est marquée comme sélectionnée.
3. La grille centrale (en bleu foncé) s’adapte en fonction de la nouvelle disposition.

2. Ajout de photos
En tapant sur un bouton plus, l’utilisateur a accès à sa photothèque et peut choisir une des
photos de son téléphone. Une fois choisie, celle ci vient prendre la place de la case
correspondante au bouton plus tapé.
La photo doit être centrée, sans être altérée (les proportions sont maintenues) et prendre
tout l’espace possible (pas de “blanc”).
Si l’utilisateur clique sur une photo dans la grille, il peut choisir dans la photothèque une
nouvelle image pour la remplacer.

3. Swipe to share
L’utilisateur peut partager la création qu’il vient de réaliser. Pour cela il peut réaliser un
swipe vers le haut (en mode portrait) ou vers la gauche (en mode paysage).
Le swipe lance une animation qui fait glisser la grille principale vers le haut (ou vers la
gauche) jusqu’à disparaître de l’écran.
Une fois l’animation terminée, la vue UIActivityController s’affiche et permet à l’utilisateur
de choisir son application préférée pour partager sa création.
Une fois le partage effectué, annulé ou échoué, la grille principale revient automatiquement
à sa place d’origine par l’animation inverse.

Contraintes techniques
- Le langage utilisé doit être Swift 4 ou supérieur
- L’application doit être disponible à partir d’iOS 11.0
- L’application est supportée par toutes les tailles d’iPhone (de l’iPhone SE à l’iPhone
XS Max)
- L’application n’a pas à être disponible sur iPad
- L’application supporte l’orientation Portrait et Paysage
