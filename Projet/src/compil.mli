open CodeMap
open Ast

type value_env = string * value list
type function_env = string * (value list) * string list (* nom de la fct, les arguments en value, le label *)
type environment = value_env * function_env

val process_program : program -> unit
val eval : expression Span.located -> environment -> value
val eval_list : expression Span.located list-> environment -> value list
val create_function_label : string -> (value list) -> environment -> out_channel -> environment (* Met à jour l'environnement de fonction *)
val get_function_label : string -> (value list) -> environment -> string * environment


val process_command : command -> environment -> environment
