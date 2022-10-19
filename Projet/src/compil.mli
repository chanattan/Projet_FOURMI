open CodeMap
open Ast

type valueEnv = string * value list
type functionEnv = string * (value list) * string list (* nom de la fct, les arguments en value, le label *)
type environment = valueEnv * functionEnv

val processProgram : program -> unit
val eval : expression Span.located -> environment -> value
val listeval : expression Span.located list-> environment -> value list
val createFunctionLabel : string -> (value list) -> environment -> out_channel -> environment (* Met à jour l'environnement de fonction *)
val getFunctionLabel : string -> (value list) -> environment -> string * environment


val processCommand : command -> environment -> environment
