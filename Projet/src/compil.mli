open CodeMap
open Ast

(** commentaire fonction *)
type value_env = (string * value) list (* Environnement de variables avec le nom de la variable * sa valeur. La première occurence du nom dans la liste est renvoyé donc on peut contenir des doublons*)
type function_env = (string * (string list) * program) list (* Nom de la fonction, le nom des arguments en tant que variables, le programme à exécuter (le corps de la fonction) *)
type environment = value_env * function_env (* Un environnement produit pour transmettre toutes les informations nécessaire *)

val process_program : program -> environment -> out_channel -> value * environment
val start_program : program -> environment -> string -> unit
val eval : expression Span.located -> environment -> out_channel -> value * environment
val eval_list : expression Span.located list-> environment -> out_channel -> value list * environment

val process_command : command -> environment -> out_channel -> value * environment
val process_compare : compare -> environment ->out_channel -> bool*environment
val process_apply : string -> (expression Span.located list) -> environment -> out_channel -> value * environment
val process_condition : cond -> environment -> out_channel -> string * environment
val process_operation : operation -> environment -> out_channel -> value * environment