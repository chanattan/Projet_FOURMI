# Documentation Projet compilateur fourmi

## I/ Présentation
Ce compilateur permet de transformer un langage de haut niveau en "langage fourmi", un langage réduit à de simples instructions compréhensibles par une fourmi.\
La fourmi ne peut que se déplacer, regarder son environnenemt et poser ou enlever des phéromones.
La grammaire est fournie dans le fichier lang.grammar.\
Le fichier en sortie est un .brain et contient le code de base compréhensible par la fourmi.\

### Types de base :
- \<**expression**\> : instructions de déclaration de variables et fonctions, deréférencement de variables, application de fonctions et expressions à évaluer (comparaisons, commandes primaires de fourmi) ainsi que de structures de contrôle. La syntaxe est décrite plus bas.
- \<**program**\> : suite non vide d'expressions séparées par des ";".
- \<**value**\> : Valeur de plusieurs sous types :

        int : entier naturel.
        bool : booléen (true ou false).
        unit : expression sans type.

- \<**ident**\> : identificateur qui définit le nom des fonctions et des variables *(chaîne de caractères)*.
- \<**direction**\> : direction vers laquelle une fourmi va se tourner.

*Directions* :

        R : tourner à droite d'un sixième de tour.
        L : tourner à gauche d'un sixième de tour.


- On utilise la syntaxe <name*,> lorqu'on veut transmettre une liste de \<name\> (éventuellement vide). (span located?)
- Appeler une fonction nécessite de connaître son nom de type \<**ident**\> et ses arguments de type \<**expression,**\>.


### Opérations arithmétiques :
Les opérations arithmétiques se font entre \<**expression**\> et produisent un \<**int**\>.\
Etant donné deux expressions \<**expr1**\> et \<**expr2**\> le compilateur évaluera les deux expressions de manière à les réduire en \<**int**\> pour
effectuer l'opération entre entiers.\
Dans le cas d'une évaluation d'une expression qui ne se réduit pas en \<**int**\> alors le compilateur produit une erreur de type.

        [Type Error] there was an error while trying to sum up two values.

On ne s'autorise pas l'algèbre de Boole.

Les opérations :

- add <expr1> <expr2> : évalue les deux expressions en des entiers et ajoute deux entiers
- sub <expr1> <expr2> : évalue les deux expressions en des entiers et soustrait deux entiers
- mul <expr1> <expr2> : évalue les deux expressions en des entiers et multiplie deux entiers
- div <expr1> <expr2> : évalue les deux expressions en des entiers et divise deux entiers (division euclidienne)
- mod <expr1> <expr2> : évalue les deux expressions en des entiers et donne le reste de la division euclidienne de deux entiers

### Comparaisons :
Les comparaisons se font entre \<**expression**\> et produisent un \<**bool**\>.\
Etant donné deux expressions \<**expr1**\> et \<**expr2**\> le compilateur évaluera les deux expressions de manière à déduire leur type \<**value**\> pour effectuer la comparaison.
- Dans le cas d'une évaluation entre valeurs de type **unit**, seule l'**égalité** est tolérée et renvoie true à condition que les expressions comparées terminent (cas de comparaison de while).\
Si le type **unit** est comparé avec un autre type que **unit**, alors pour toute comparaison cela échouera et produira un message d'erreur de ce type :

        [Type Error] : Trying to compare unit with something.

- Dans le cas d'une évaluation entre valeurs de type **int** alors la comparaison est une comparaison d'entiers.\
Si le type **int* est comparé avec un autre type que **int**, alors pour toute comparaison cela échouera et produira un message d'erreur de type.
- Dans le cas d'une évaluation entre valeurs de type **bool** alors la seule comparaison est une comparaison d'égalité de booléens.\
Si le type **bool** est comparé avec un autre type que **bool**, alors pour toute comparaison cela échouera et produira un message d'erreur de type.

- **égalité** :
    eq \<expression\> \<expression\>
- **strictement inférieur** :
    lt \<expression\> \<expression\>
- **strictement supérieur** :
    gt \<expression\> \<expression\>
- **supérieur ou égal** :
    le \<expression\> \<expression\>
- **inférieur** :
    ge \<expression\> \<expression\>
   
### Commandes primaires :
(Type : \<**expression**\>)\
\
Les commandes de base ou primaires décrivent les comportements primitifs des fourmis.
- **Move** :

        move(<ident>, [<expression>*,])
        
Permet de bouger la fourmi.\
Dans le cas où la fourmi n'a pas réussi à avancer (présence d'un obstacle, d'une autre fourmi, ...), on appelle la fonction renseignée par \<ident\> et on lui passe les arguments passés dans [\<expression\>*,], il peut avoir 0 expression et chaque expression est séparée par une virgule.

- **Mark** :

        mark(i)

Permet de mettre le bit i de la cellule visée à 1.

- **Unmark** :

        unmark(i)

Permet de mettre le bit i de la cellule visée à 0.

- PickUp :

        pickup(<ident>, [<expression*,>])

Permet de prendre une nourriture sur la cellule où est la fourmi.\
Dans le cas où cette action est impossible, on appelle la fonction renseignée par \<ident\> en lui passant les arguments passés dans [\<expression\>*,].

- Turn :
        
        turn(<direction>)

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


## II/ Détails du compilateur et paradigme du langage

Environnement : c'est un couple de deux listes. La première liste est un environnement de variables. La deuxième liste est un environnement de fonctions

- Environnement de variables : liste de couples (< string >,< value >) qui permet d'associer à la variable du label renseigné dans < string > une valeur < value >.

- Environnement de fonctions : liste de triplets (< string >,<expression*,>, < string >) qui permet d'associer à la fonction appelée avec <string> et des arguments <expression*,> un label renseigné dans le dernier < string >
On cherche une variable dans un environnement en partant du début de la liste. Cela permet de modifier sa valeur en temps constant juste en réécrivant un nouveau couple (< string >,< value >) en début de liste avec la valeur < value > modifiée.

- Les variables ont une portée et une durée de vie infinie.

- Une même fonction peut être écrite plusieurs fois à la compilation si elle est appelée avec plusieurs arguments différents

- L'environnement est modifié à chaque évalution d'expression

- Lorsqu'on appelle une commande de base, on peut executer la fonction passée en argument avec ses paramètres mais on revient forcément à l'instruction de la commande de base après

- Dans les instructions while, lorsqu'on évalue l'expression, on retourne un nouvel environnement dans lequel on appelle process program sur le corps de la boucle qui retourne un new_Env2 dans lequel on évalue une nouvelle fois < expression >, etc.
Por le doWhile, on évalue le programme et on a un new_Env dans lequel on évalue la condition expr qui retourne une newEnv2 et un booleen qui si vaut true alors on reevalue l'ensemble de l'instruction (tout le doWhile) dans le nouvel environnement newEnv2. (on souligne le fait que l'evaluation dans newEnv2 garantit la terminsaison de la boucle s'il y a)
(La derniere evaluation de toute l'expresssion pourrait aussi se faire dans new_Env, car la condition n'est supposée qu'être évaluée que en des booleens. Par sécurité, on crée un new_env2. Cette même remarque s'applique aussi pour le while)

- Le compilateur cherche toujours à commencer par le main

- Les span permettent de repérer les erreurs

## III/ Tests

Dans le dossier test_brains, les fichiers test.ant peremettent de faire des tests unaires

## IV/ Evolutions

Le compilateur ne possède pas beaucoup de macros. On pourrait rajouter des fonctions implémentées dans le compilateur permettant de faire des actions plus évoluées et qui seraient appelées par un simple < ident >


