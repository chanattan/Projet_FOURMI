# Documentation Projet compilateur fourmi

## I/Overview
Ce compilateur permet de transformer un lanage de haut niveau en "langage fourmi", un langage réduit à de simples instructions compréhensibles pour une fourmi.
La fourmi ne peut que se déplacer, regarder son environnenemt et poser ou enlever des pheromones.
La grammaire est fournie dans le fichier lang.grammar.
Le fichier en sortie est un .brain et contient le code de base compréhensible pour la fourmi

### Types de base :
- < expression > : désigne une instruction du programme
- < program > : ensemble de toutes les instructions qui composent le programme (liste non vide d'expression < expression >)
- < value >: < int > : entiers
            < bool > : booleens
                true : vrai
                false : faux
            unit : expression sans type
                unit
- < ident > : sert à renseigner le nom des fonctions et des variables (chaine de caracteres)
- < direction > : désigne une direction vers laquelle une fourmi va se tourner
        R : tourner à droite d'un sixième de tour
        L : tourner à gauche d'un sixième de tour


- On utilise la syntaxe <name*,> lorqu'on veut transmettre une liste de < name > (éventuellement vide)
- Appeler une fonction nécessite de connaître son nom de type < ident > et ses arguments de type < expression >


### Opérations de base: (renvoient un <int>)
- add < expression > < expression > : évalue les deux expressions en des entiers et ajoute deux entiers
- sub < expression > < expression > : évalue les deux expressions en des entiers et soustrait deux entiers
- mul < expression > < expression > : évalue les deux expressions en des entiers et multiplie deux entiers
- div < expression > < expression > : évalue les deux expressions en des entiers et divise deux entiers (division euclidienne)
- mod < expression > < expression > : évalue les deux expressions en des entiers et donne le reste de la division euclidienne de deux entiers

### Comparaisons: (renvoient un bool)
/!\ Non utilisées par l'utilisateur. Ne sert que pour la construction de dans le compilateur. Renvoie un type bool de OCaml.

- égal :
    eq < expression >, < expression >
- inférieur ou égal :
    lt < expression >, < expression >
- supérieur ou égal :
    gt < expression >, < expression >
- strictement supérieur :
    le < expression >, < expression >
- strictement inférieur :
    ge < expression >, < expression >
Permet de comparer deux expressions après leur évaluation. Elles doivent être de type < int > pour être comparées.

### Commandes de base : (renvoient un unit)
- Move :
    move(< ident > < expression >)
Dans le cas où la fourmi n'a pas réussi à avancer (présence d'un obstacle, d'une autre fourmi, ...), on appelle la fonction renseignée avec ident et on lui passe les arguments passés dans expression

- Mark :
    mark(i)
Permet de mettre le bit i de la case visée à 0

- Unmark :
    unmark(i)
Permet de mettre le bit i de la case visée à 0

- PickUp :
    pickup(< ident >, [ < expression*, > ])
Permet de prendre une nourriture sur la case où est la fourmi.
Dans le cas où cette action est impossible, on appelle la fonction renseignée avec ident en lui passant les arguments passés dans < expression >

- Turn :
    turn(< direction >)
Tourne d'un sixième de tour la fourmi dans la direction fournie en argument(L ou R)

- Sense :
    sense(< sensedir >, < cond >, < ident >, [<expression*,>], < ident >, [<expression*,>])
Test effectué directement sur le terrain : on regarde vers sensdir si la condition cond est vérifiée.
Si c'est le cas, on appelle la première fonction avec ses arguments. Sinon, on appelle la deuxième fonction avec ses arguments

- Flip :
    flip(< int >, < ident >, [<expression*,>], < ident >, [<expression*,>])
Permet d'effectuer un choix de manière aléatoire.
On a 1 chance sur < int > d'appeler la première fonction avec ses arguments. Dans l'autre cas, c'est l'autre fonction qui est appelée



### Conditions : (renvoient un unit)
Ce sont les constatnes qui permettent de se renseigner sur l'environnement proche de la fourmi.
Ces conditions ne sont utilisables que dans la fonction sense. Elles sont toujours accompagnées d'une case sur laquelle on teste ces conditions (cf sense)
- Friend :
    IS_FRIEND
Détecte si la fourmi sur la case renseignée est dans la même équipe

- Foe :
    IS_FOE
Détecte si la fourmi sur la case renseignée est dans l'équipe adverse

- FriendWithFood :
    IS_FRIEND_WITH_FOOD
Détecte si la fourmi sur la case renseignée est un allié et si elle porte de la nourriture

- FoeWithFood :
    IS_FOE_WITH_FOOD
Détecte si la fourmi sur la case renseignée est un ennemi et porte de la nourriture

- Food :
    IS_FOOD
Détecte s'il y a de la nourriture sur la case renseignée

- Rock :
    IS_ROCK
Détecte s'il y a un rocher(cases non franchissable) sur la case renseignée

- Marker(< expression >)) :
    IS_MARKER
Evalue l'expression en un entier i et regarde si le marqueur i de la case renseignée est à 1

- FoeMarker :
    IS_FOE_MARKER
Détecte si sur la case renseignée des marqueurs ont été changés par l'équipe adverse

- Home :
    IS_HOME
Détecte si la case renseignée est une case de sa base

- FoeHome :
    IS_FOE_HOME
Détecte si la case renseignée est une case de la base adverse


### Expressions : (renvoient une value(int, bool ou unit))
Ce sont les instructions du programme. Elle se terminent toutes par ';'
- Const :
    < value >
On renseigne une < value >

- Var :
    let < ident > = < expression >
On déclare une variable par son identifiant < ident > et une < expression > qui une fois évaluée donnera la valeur de la variable de type < value >.

- If :
    if (< expression >) {< program >}
Permet d'exécuter le programme < program > seulement si l'évaluation de < expression > a renvoyé le < bool > true

- Else :
    else {< program >}
Ne peut exister qu'après un if.
Permet d'exécuter le programme < program > seulement si l'évaluation de l'expression < expression > du if associé a renvoyé le < bool > false

- While :
    while (< expression >) {< program >}
Execute le < program > tant que l'expression < expression > est évaluée en le < bool > true (on commence par évaluer l'expression)

- DoWhile :
    do {< program >} while (< expression >)
Execute une première fois le < program > puis le rexecute tant que l'expression < expression > est évaluée en le < bool > true (on commence par executer le programme)

- Compare :
    < compare >
Renseigne une comparaison entre deux expressions qui doivent s'évaluer en des < int > (cf Comparaisons)

- Operation :
    < operation >
Effectue une opération entre deux expressions qui doivent s'évaluer en des < int > (cf Comparaisons)

- Command :
    < command >
Renseigne une commande de base que peut effectuer la fourmi (cf Commandes de base)

- Apply :
    < ident >(<expression*,>)
Renvoie la valeur de retour de la fonction < ident > appelée avec les arguments passés dans <expression*,>

- Func :
    fun < ident >(<ident*,>) {< program >}
Permet de déclarer une fonction de label < ident > prennant en argument une liste de variables (la liste <ident*,>) qui execute le programme < program >


## II/To go further

Environnement : c'est un couple de deux listes. La première liste est un environnement de variables. La deuxième liste est un environnement de fonctions

- Environnement de variables : liste de couples (< string >,< value >) qui permet d'associer à la variable du label renseigné dans < string > une valeur < value >.

- Environnement de fonctions : liste de triplets (< string >,<expression*,>, < string >) qui permet d'associer à la fonction appelée avec <string> et des arguments <expression*,> un label renseigné dans le dernier < string >
On cherche une variable dans un environnement en partant du début de la liste. Cela permet de modifier sa valeur en temps constant juste en réécrivant un nouveau couple (< string >,< value >) en début de liste avec la valeur < value > modifiée.

- Les variables ont une portée et une durée de vie infinie.

- Une même fonction peut être écrite plusieurs fois à la compilation si elle est appelée avec plusieurs arguments différents

- L'environnement est modifié à chaque évalution d'expression

## III/ Tests

Dans le dossier test_brains, les fichiers test.ant peremettent de faire des tests unaires

## IV/

Le compilateur ne possède pas beaucoup de macros. On pourrait rajouter des fonctions implémentées dans le compilateur permettant de faire des actions plus évoluées et qui seraient appelées par un simple < ident >


