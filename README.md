# Projet Fourmi OCAMRD

Projet des fourmis du groupe : Gaëtan Regaud, Timmerman Jules, Sok Chanattan

# Documentation du langage OCAMRD
> OCAMRD : Outil de Conception et d'Amélioration de Machine Rustiquement Développé

> ## I/ Présentation
Ce compilateur permet de transformer un langage de haut niveau en "langage fourmi", un langage réduit à de simples instructions compréhensibles par une fourmi.\
La fourmi ne peut que se déplacer, regarder son environnenemt et poser ou enlever des phéromones.
La grammaire est fournie dans le fichier lang.grammar.\
Le fichier en sortie est un .brain et contient le code de base compréhensible par la fourmi.\
La partie décrivant le paradigme du langage éclaircit la syntaxe du langage.

# Implémentations réussies
Le code du compilateur actuel ne semble pas porter de problèmes et a été traité dans son ensemble.\
Ont été implémentées les tâches suivantes :
- Fonctions avec arguments et valeur de retour de la fonction
- Variables globales statiques
- Environnements
- Structures de contrôle
- Commandes primaires
- Typage
- Else optionnel
- 
---

> ## II/ Syntaxe basique

> ### Types de base :
- \<**expression**\> : instructions de déclaration de variables et fonctions, deréférencement de variables, application de fonctions et expressions à évaluer (comparaisons, commandes primaires de fourmi) ainsi que de structures de contrôle. La syntaxe est décrite plus bas.
- \<**program**\> : suite non vide d'expressions séparées par des ";". La dernière expression évaluée de cette suite est le type de retour du programme.\
Les expressions qui précédent la dernière doivent s'évaluer au type **unit** (cf. value) (le détail est expliqué dans la partie paradigme).
- \<**value**\> : Valeur de plusieurs sous types :

        int : entier naturel (ex : 5, 18).
        bool : booléen (true ou false).
        unit : expression sans type (ex : while).

- \<**ident**\> : identificateur qui définit le nom des fonctions et des variables *(chaîne de caractères)*.
- \<**direction**\> : direction vers laquelle une fourmi va se tourner.

*Directions* :

        R : tourner à droite d'un sixième de tour.
        L : tourner à gauche d'un sixième de tour.

- On utilise la syntaxe <name*,> lorqu'on veut transmettre une liste de \<name\> (éventuellement vide). (span located?)
- Appeler une fonction nécessite de connaître son nom de type \<**ident**\> et ses arguments de type \<**expression,**\>.
<br><br/>
> ### Expressions :
> Ce sont les instructions principales du programme. Elle se terminent toutes par ';'.
        
- **Const** :
    \<value\>

Décrit une valeur constante : un int, bool ou unit.\
Elle décrit surtout le type de l'évaluation d'une expression. (ex : add 5 6 donne un type **int**).

- **Var** :
        
        let <ident> = <expression>

Déclaration d'une variable par son identifiant \<**ident**\> et une \<**expression**\> qui une fois évaluée donnera la valeur de la variable de type \<**value**\>. La valeur est associée à l'identifiant \<**ident**\> dans l'environnement du programme actuel (cf. paradigme).

- **Déréférencement** :
        
        !<ident>

Déréference la variable identifiée par \<**ident**\> et renvoie la valeur associée dans l'environnement actuel (cf. paradigme).

- **If** :
        
        if (<expression>) {<program>}

Permet d'exécuter le programme \<**program**\> seulement si l'évaluation de \<**expression**> donne le \<**bool**> **true**.

- **Else** :

        else {<program>}

Ne peut exister qu'après un bloc if sous peine d'une erreur de syntaxe.\
Permet d'exécuter le programme \<**program**\> seulement si l'évaluation de l'expression \<*expression**\> du if associé a renvoyé le \<**bool**\> **false**.

- **While** :

        while (<expression>) {<program>}
        
Execute le \<**program**\> tant que l'expression \<**expression**\> est évaluée en le \<**bool**\> **true** (on commence par évaluer l'expression).

- **DoWhile** :

        do {<program>} while (<expression>)

Exécute une première fois le < program > puis le rexecute tant que l'expression < expression > est évaluée en le < bool > true (on commence par executer le programme).

- **Compare** :
        
        <compare> <expr1> <expr2>

Compare deux expressions qui s'évaluent en \<**value**\> et renvoie une valeur de type \<**bool**\>. (cf. Comparaisons pour \<**compare**\>)

- **Operation** :

        <operation> <expr1> <expr2>

Effectue une opération entre deux expressions qui doivent s'évaluer en des \<**int**\> (cf. Opérations pour \<**operation**\>) et renvoie une valeur de type \<**int**\>.

- **Command** :

        <command>

Exécute une commande primaire que peut effectuer la fourmi (cf. Commandes primaires).


- **Func** :

        fun <ident>(<ident*,>) {<program>}

Déclare une fonction de label \<**ident**\> prenant en argument une liste de variables \<**ident*,**\> qui exécute le programme \<**program**\>.
La fonction retourne la valeur du programme \<**program**\> donc de la dernière expression évaluée dans \<**program**\> (cf. types et cf. paradigme).

- Apply :

        <ident> (<expression*,>)

Applique la fonction identifiée par \<**ident**\> par les arguments passés dans \<**expression***,\> et renvoie la valeur de retour de la fonction.
<br><br/>
> ### Opérations arithmétiques :
> Les opérations arithmétiques se font entre \<**expression**\> et produisent un \<**int**\>.\
Etant donné deux expressions \<**expr1**\> et \<**expr2**\> le compilateur évaluera les deux expressions de manière à les réduire en \<**int**\> pour
effectuer l'opération entre entiers.

Dans le cas d'une évaluation d'une expression qui ne se réduit pas en \<**int**\> alors le compilateur produit une erreur de type.

        [Type Error] there was an error while trying to sum up two values.

On ne s'autorise pas l'algèbre de Boole.

Les opérations :

- *Addition* : évalue les deux expressions en des entiers et ajoute deux entiers

        add <expr1> <expr2>

- *Soustraction* : évalue les deux expressions en des entiers et soustrait deux entiers

        sub <expr1> <expr2> 

- Multiplication : évalue les deux expressions en des entiers et multiplie deux entiers

        mul <expr1> <expr2> 

- Division : évalue les deux expressions en des entiers et divise deux entiers (division euclidienne)

        div <expr1> <expr2>

- Modulo : évalue les deux expressions en des entiers et donne le reste de la division euclidienne de deux entiers

        mod <expr1> <expr2>

> ### Comparaisons :
> Les comparaisons se font entre \<**expression**\> et produisent un \<**bool**\>.\
Etant donné deux expressions \<**expr1**\> et \<**expr2**\> le compilateur évaluera les deux expressions de manière à déduire leur type \<**value**\> pour effectuer la comparaison.

- Dans le cas d'une évaluation entre valeurs de type **unit**, seule l'**égalité** est tolérée et renvoie true à condition que les expressions comparées terminent (cas de comparaison de while).\
Si le type **unit** est comparé avec un autre type que **unit**, alors pour toute comparaison cela échouera et produira un message d'erreur de ce type :

        [Type Error] : Trying to compare unit with something.

- Dans le cas d'une évaluation entre valeurs de type **int** alors la comparaison est une comparaison d'entiers.\
Si le type **int* est comparé avec un autre type que **int**, alors pour toute comparaison cela échouera et produira un message d'erreur de type.
- Dans le cas d'une évaluation entre valeurs de type **bool** alors la seule comparaison est une comparaison d'égalité de booléens.\
Si le type **bool** est comparé avec un autre type que **bool**, alors pour toute autre comparaison cela échouera et produira un message d'erreur de type.

- **égalité** :
        
        eq <expr1> <expr2>

Si **expr1** et **expr2** se réduisent en **v1** et **v2** de type **int** alors cela renvoie un **bool** résultat de : **v1** = **v2**.

- **strictement inférieur** :
        
        lt <expr1> <expr2>
        
Si **expr1** et **expr2** se réduisent en **v1** et **v2** de type **int** alors cela renvoie un **bool** résultat de : **v1** < **v2**.

- **strictement supérieur** :
        
        gt <expr1> <expr2>
        
Si **expr1** et **expr2** se réduisent en **v1** et **v2** de type **int** alors cela renvoie un **bool** résultat de : **v1** > **v2**.
- **supérieur ou égal** :
    
        le <expr1> <expr2>
        
Si **expr1** et **expr2** se réduisent en **v1** et **v2** de type **int** alors cela renvoie un **bool** résultat de : **v1** <= **v2**.
- **inférieur** :
    
        ge <expr1> <expr2>
        
Si **expr1** et **expr2** se réduisent en **v1** et **v2** de type **int** alors cela renvoie un **bool** résultat de : **v1** >= **v2**.
<br><br/>
> ### Commandes primaires :
> Type : \<**expression**\>\
\
> Les commandes de base ou primaires décrivent les comportements primitifs des fourmis.

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

- **PickUp** :

        pickup(<ident>, [<expression*,>])

Permet de prendre une nourriture sur la cellule où est la fourmi.\
Dans le cas où cette action est impossible, on appelle la fonction renseignée par \<ident\> en lui passant les arguments passés dans [\<expression\>*,].

- **Turn** :
        
        turn(<direction>)

Tourne d'un sixième de tour la fourmi dans la direction fournie en argument (L ou R).

- **Sense** :

        sense(<sensedir>, <cond>, <ident>, [<expression*,>], <ident>, [<expression*,>])

Test effectué directement sur le terrain : on regarde vers \<sensdir\> si la condition \<cond\> est vérifiée.\
Si c'est vrai, on appelle la première fonction par avec ses arguments qui suivent l'ident. Sinon, on appelle la deuxième fonction avec ses arguments.

Directions **sensedir** :
        
        LEFTAHEAD : devant à gauche
        RIGHTAHEAD : devant à droite
        HERE : position actuelle
        AHEAD : devant

- **Flip** :
        
        flip(<int>, <ident>, [<expression*,>], <ident>, [<expression*,>])

Permet d'effectuer un choix de manière aléatoire.\
On a 1 chance sur \<int\> d'appeler la première fonction avec ses arguments. Dans l'autre cas, c'est l'autre fonction qui est appelée.

- **Wait** :

        wait(<expression>)

Permet d'attendre n itérations où n est un \<**int**\> résultat de l'évaluation d'\<**expression**\>.\
Dans le cas où l'évaluation échoue alors il y a une erreur de type.
<br><br/>
> ### Conditions d'environnement :
> Type : \<**expression**\>\
\
Les conditions d'environnement sont les constantes qui permettent de se renseigner sur l'environnement proche de la fourmi.
Ces conditions ne sont utilisables que dans la fonction **sense**. Elles sont toujours accompagnées d'une case sur laquelle on teste ces conditions (cf sense).

> Les expressions peuvent (et doivent parfois) être parenthésées pour désambiguïser les expressions, particulièrement dans le cas d'expressions imbriquées multiples.
Exemple : add (6 mod 3) 1
Les expressions parenthésées sont évaluées en priorité, la priorité maximale est donnée à l'expression parenthésée la plus profonde.

- **Allié** :

        ISFRIEND

Détecte si la fourmi sur la case renseignée est dans la même équipe.

- **Ennemi** :

        ISFOE

Détecte si la fourmi sur la case renseignée est dans l'équipe adverse.

- **Allié avec nourriture** :

        ISFRIENDWITHFOOD

Détecte si la fourmi sur la case renseignée est un allié et si elle porte de la nourriture.

- **Ennemi avec nourriture** :

        ISFOEWITHFOOD

Détecte si la fourmi sur la case renseignée est un ennemi et porte de la nourriture.

- **Nourriture** :

        ISFOOD

Détecte s'il y a de la nourriture sur la case renseignée.

- **Rocher** :
        
        ISROCK

Détecte s'il y a un rocher (case non franchissable) sur la case renseignée.

- **Marquer par une expression** :
        
        Marker(<expression>)

Evalue l'expression en un entier i et marque la cellule au bit i à 1 sur laquelle la fourmi se trouve.
        
- **Est marquée** :
        
        ISMARKER

Vérifie si la cellule sur laquelle la fourmi se trouve est marquée.

- **Marqué par un ennemi** :
        
        ISFOEMARKER

Détecte si sur la case sur laquelle la fourmi se trouve un marqueur a été changé par l'équipe adverse.

- **Maison** :
        
        ISHOME

Détecte si la case sur laquelle la fourmi se trouve est une case de sa base.

- **Maison ennemie** :

        ISFOEHOME

Détecte si la case sur laquelle la fourmi se trouve est une case de la base adverse.

---
                
## III/ Détails du compilateur et paradigme du langage

> On décrira ici les choix du langage effectués qui constituent le paradigme mais également le comportement et les détails du compilateur.
> Cela permet d'éclaircir l'utilisation du langage et nos implémentations.

> **Environnement** : un environnement est un couple de deux listes de la forme *(var_env, func_env)*.\
La première liste est un environnement de variables. La deuxième liste est un environnement de fonctions.

**Environnement de variables** : liste de couples de la forme (\<**string**\>, \<**value**\>) qui permet d'associer à la variable du label renseigné dans \<**string**\> une valeur \<**value**\>.
<br><br/>
**Environnement de fonctions** : liste de triplets (\<**string**\>, <expression*,>, \<**string**\>) qui permet d'associer la fonction identifiée par le label \<**string**\> et des arguments \<**expression\*,**\> à un label renseigné dans le dernier \<**string**\>.
<br><br/>
Les **variables** ont une **portée** et une **durée** de vie **infinie**.
<br><br/>
L'environnement est **modifié** à chaque **évalution** d'expression.
La création d'une variable dans un environnement se fait en partant du début de la liste. Cela permet de modifier/associer sa valeur en temps constant juste en réécrivant un nouveau couple (\<**string**\>, \<**value**\>) en début de liste avec la nouvelle valeur \<**value**\>.

- Le déréférencement d'une variable dans un environnement se fait en partant du début de la liste aussi, afin de récupérer la dernière association de valeur à l'identifiant de la variable déréférencée.

Cela étant dit, la notion d'environnement décrit l'état des valeurs associées aux variables et les fonctions avec leurs arguments à un temps donné, il peut donc changer au cours du temps et en fonction du contexte.

En général, l'environnement s'enrichit (dans le sens s'élargit) séquentiellement dans le programme de haut en bas.
Dans le cas d'évaluations imbriquées l'environnement s'enrichit par profondeur d'expression.

Prenons un exemple :

        let a = (add (let b = 3; 3) 4)

ne fonctionne pas car (let b = 3; 3) est un programme (program) ou suite d'expressions et add ne prend que des expressions en arguments. Notons que cela pourrait être facilement ajouté en changeant la grammaire du langage mais cela ne rentrait pas dans nos priorités étant en temps limité.

Cependant cela fonctionne :

        fun foo(){
                let a = 3;
                3
        };
        
        fun main(){
                let a = 4;
                let a = (add foo() !a)
        }

A la fin du programme a vaut 6.
Etant donné la portée globale de nos variables, dans main on définit a qui vaut 4 à 3 par foo() auquel on ajoute 3, a vaut donc 6.

Prenons un autre exemple :

        fun foo(){
                let a = 3;
                3
        };

        fun main(){
                foo();
                while(lt !a 10){
                        let a = add !i 1
                }
        }

L'environnement du programme est mis à jour à chaque itération ce qui change la valeur de a et la boucle while va finir.

**Notons que la syntaxe des programmes précédents concernant les points virgules est correcte et doit être telle quelle : pas de point virgule à la fin d'un programme et donc pas à l'instruction de retour de fonction ou de structure de contrôle.**

- Une même fonction peut être écrite plusieurs fois à la compilation si elle est appelée avec plusieurs arguments différents.
- Lorsqu'on appelle une commande de base, on peut exécuter la fonction passée en argument avec ses paramètres mais on revient forcément à l'instruction de la commande de base après (par un Goto) et on continue le programme de la manière séquentielle.
- Dans les instructions while, lorsqu'on évalue l'expression (condition), on retourne un nouvel environnement dans lequel on appelle process_program qui évalue le corps de la boucle qui retourne un nouvel environnement new_env2 dans lequel on évalue une nouvelle fois <expression> (condition), etc.
- Pour le doWhile, on évalue le programme et on a un new_env dans lequel on évalue la condition expr qui retourne un nouvel environnement new_env2 et un booléen qui s'il vaut true alors on réevalue l'ensemble de l'instruction (tout le doWhile) dans le nouvel environnement new_env2 sinon on stoppe doWhile. (On souligne le fait que l'évaluation dans new_env2 garantit la terminaison de la boucle s'il y a car c'est dans ce dernier environnement que le corps de boucle susceptible de modifier la condition est évalué).\
(La dernière évaluation de toute l'expression pourrait aussi se faire dans new_env, car la condition n'est supposée qu'être évaluée que en des booléens qui ne modifient pas l'environnement. Par sécurité, on utilise new_env2 dans lequel tout est évalué. Cette même remarque s'applique aussi pour le while).

Les boucles **while** sont pré-exécutées de manière statique par le compilateur qui va écrire en boucle les instructions dans le fichier sortie.

Le while utilisé dans l'exemple précédent modifie l'environnement de manière classique.\
**!!!! Le while(true) a un comportement différent !!!!**

Prenons un exemple :

        fun main() {
                while(true) {
                        drop()
                }
        }

Etant donné que c'est une boucle infinie alors à la compilation on ne peut pré-exécuter la boucle sous-peine d'une compilation infinie*.

*en vérité la compilation infinie est possible et l'usage de notre langage veut prohibiter des expressions différentes de true mais qui s'évaluent à true tout le temps dans des conditions de boucle while.

Exemple :

        fun main() {
                while(eq 1 1){
                        drop()
                }
        }

ne compilera pas.

Par conséquent le cas spécifique est while(true) qui permet de faire des boucles infinies grâce à Goto. Le compilateur va donc écrire le programme (corps de boucle) de manière statique dans le fichier sortie et boucler par un label et Goto, cependant pour tout changement d'environnement, en raison de l'écriture statique du programme dans le fichier sortie on ne peut réevaluer l'environnement engendré par le programme dans l'itération courante dans l'itération suivante.\
Cela veut donc dire que l'environnement d'une boucle while est local et se réinitialise à chaque tour de boucle. Cela ne pose pas trop de problème dans notre usage de fourmis car la boucle while(true) est utilisée pour répéter les instructions en boucle de manière séquentielle comme un automate !
- Le compilateur cherche toujours à commencer par la fonction main.
- Les span permettent de repérer les erreurs dans le compilateur pour aller dans le noeud concerné dans l'AST.
- process_compare est la fonction spécifique du compilateur qui va évaluer des comparaisons entre valeurs et retourner un booléen de Caml qui sera évalué dans le compilateur pour être retraduit en <bool> du langage. C'est un choix arbitraire de développement aura permi de simplifier un peu de code.
- Le If then Else a été géré pour que le Else soit optionnel, cela est engendré par la grammaire et donc force l'usage du ; entre les deux structures (if else), le fonctionnement est géré par le compilateur.

---
                
## IV/ Tests

Dans le dossier test_brains, les fichiers test.ant peremettent de faire des tests unaires.
Les tests peuvent être lancés par la commande make tests dans le dossier src.\
On s'est principalement assuré de la vérification du code produit en langage fourmi par nous-même qui semble correct, mais la compilation et les tests semblent fonctionner.

---

## V/ Evolutions

- Le compilateur ne possède pas beaucoup de macros. On pourrait rajouter des fonctions implémentées dans le compilateur permettant de faire des actions plus évoluées et qui seraient appelées par un simple \<ident\>.\
- Il serait apprécié de donner une portée locale à nos fonctions même si dans le cadre du projet de fourmis il est plus intéressant de la laisser globale.
- On aurait aimé se concentrer plus sur la stratégie mais la partie langage restait essentielle pour nous.
- L'optimisation de code en langage fourmi n'a pas été gérée, malgré notre modeste compilateur qui ne semble pas produire tant de lignes langage fourmi, on aurait pu factoriser beaucoup de code.
- L'ajout d'une boucle for aurait pu être fait
- L'usage de la fonction sense aurait pu être mieux développé pour avoir des comportements plus intelligents
- Une grammaire plus complète ferait aussi un bon objet d'étude

