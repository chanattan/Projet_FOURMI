open CodeMap
open Ast

(** commentaire fonction *)
type value_env = (string * value) list
type function_env = (string * (string list) * program) list (* nom de la fct, les arguments en nom pour remplacer, le label *)
type environment = value_env * function_env

val process_program : program -> environment -> out_channel -> value * environment
val start_program : program -> environment -> out_channel -> unit
val eval : expression Span.located -> environment -> out_channel -> value * environment
val eval_list : expression Span.located list-> environment -> out_channel -> value list * environment

val process_command : command -> out_channel -> environment -> environment
val process_compare : compare -> out_channel -> bool
(*val process_apply : string -> (expression Span.located list) -> environment -> out_channel -> value*)
val process_condition : cond -> environment -> out_channel -> unit
val process_operation : operation -> environment -> out_channel -> value