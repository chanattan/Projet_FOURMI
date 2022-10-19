open CodeMap
open Ast

type valueEnv = (string * value) list
type functionEnv = (string * (value list) * string) list (* nom de la fct, les arguments en value, le label *)
type environment = valueEnv * functionEnv

val processProgram : program -> environment -> out_channel -> unit
val eval : expression Span.located -> environment -> out_channel -> value * environment
val createFunctionLabel : string -> (value list) -> environment -> out_channel -> environment (* Met à jour l'environnement de fonction *)
val bindValue : string -> value -> environment -> environment (* Ajoute une variable dans l'environment *)