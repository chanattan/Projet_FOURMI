open CodeMap
open Ast

type valueEnv = string * value list
type functionEnv = string * (value list) * string list (* nom de la fct, les arguments en value, le label *)
type environment = valueEnv * functionEnv

val processProgram : program -> unit
val eval : expression Span.located -> environment -> value
val createFunctionLabel : string -> (value list) -> environment -> functionEnv (* Met à jour l'environnement de fonction *)