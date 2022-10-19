open CodeMap
open Ast

type valueEnv = (string * value) list
type functionEnv = (string * (value list) * string) list (* nom de la fct, les arguments en value, le label *)
type environment = valueEnv * functionEnv

let bindValue (str:string) (v:value) (env:environment) : environment = let (valEnv, funEnv) = env in ((str,v)::valEnv, funEnv)

let rec eval (expr:expression Span.located) (env:environment) (out:out_channel) = match expr with
  | Const(v,_),_ ->  v,env
  | Var((str,_),exprsp),_ -> let (v,newEnv) = eval exprsp env out in (Unit, bindValue str v newEnv)
  | _ -> failwith "WIP"

let rec processProgram (Program(program):Ast.program) = match program with
  |[],_ -> print_string "Fin de la compilation"
  |expr::q, sp -> let v = eval expr in (processProgram (Program(q, sp)))
