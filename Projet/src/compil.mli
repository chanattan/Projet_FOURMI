open CodeMap
open Ast

type value_env = (string * value) list
type function_env = (string * (string list) * program) list
type environment = value_env * function_env

val bind_value : string -> value -> environment -> environment
val get_func_from_name : string Span.located -> environment -> (string list) * program
val update_env_for_fun : Span.t -> string list -> value list -> environment -> environment
val create_fun_label : string -> program -> environment -> string*string*value*environment 


val start_program : program -> environment -> string -> unit 
val eval : expression Span.located -> environment -> out_channel -> value * environment
val eval_list : (expression Span.located) list -> environment -> out_channel -> value list * environment 

val process_deref : string Span.located -> value_env -> value 
val process_sensedir : sensedir -> string
val process_while_true : program -> environment ->out_channel -> value * environment
val process_condition : cond -> environment -> out_channel -> string * environment
val process_operation : operation -> environment -> out_channel -> value * environment
val process_program : program -> environment -> out_channel -> value * environment 
val process_compare : compare -> environment -> out_channel -> bool * environment
val process_command : command -> environment -> out_channel -> value * environment
val process_apply : string Span.located -> expression Span.located list -> environment -> out_channel -> value * environment 
val process_apply_nowrite : string Span.located -> expression Span.located list -> environment -> out_channel -> string * string *value * environment 
