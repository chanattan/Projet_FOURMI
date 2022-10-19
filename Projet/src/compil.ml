open Ast;;
open Printf;;
open CodeMap;;

type value_env = (string * value) list
type function_env = (string * (value list) * string) list (* nom de la fct, les arguments en value, le label *)
type environment = value_env * function_env

let bind_value (str:string) (v:value) (env:environment) : environment = let (val_env, fun_env) = env in ((str,v)::val_env, fun_env)

let rec eval (expr : expression Span.located) (env : environment) :  = match expr with
  | Const(v, _),_ ->  v, env
  | Var((str, _), exprsp), _ -> let (v, new_env) = eval exprsp env out in (Unit, bvalue * environmentind_value str v new_env)
  | _ -> failwith "WIP"

let rec eval_list list env : value list = match list with
  |[] -> []
  |a::b -> (eval a env) :: (eval_list b env)

let rec get_function_label str values env : string * environment = match env with
    | (val_env,[]) -> (str,(val_env,[(str,values,str)]))
    | (val_env, a::b) -> let (name, arg, label) = a in
                    if str = name && values = arg then (label, (val_env,a::b))
                    else get_function_label str values (val_env,b)


(* process_command va traiter les commandes primitives concernant une fourmi*)
let rec process_command cmd file_out env = match cmd with
	| Move(((func_name, sp1),(arg_list, sp3))) -> (*les sp sont les Span : on ne les utilise pas*)
        let l_val = eval_list arg_list env in
        let (label, new_env) = get_function_label func_name l_val env in
        fprintf file_out "Move %t" label;
        new_env
	| Mark((i, sp)) -> (*i représente le ième bit à modifier sur la case marquée*)
        fprintf file_out "Mark %t" i;
        env
	| Unmark((i, sp)) -> (*de même pour unmark*)
        fprintf file_out "Unmark i";
        env
	| Pickup(func_name, arg_list) ->
        let l_val = eval_list arg_list env in
        let (label, new_env) = get_function_label func_name l_val env in
        fprintf file_out "Pickup %t" label;
        new_env
	| Turn(dir, sp) -> (*dir représente la direction dans laquelle la fourmi va tourner*)
        fprintf file_out "Turn %t" dir;
        env
	| Sense(sensd, condition, func_name_true, arg_list_true, func_name_false, arg_list_false) -> (*Sense va, selon la condition et pour une direction sensd donnée, évaluer la fonction func_name_true sur arg_list_true ou func_name_false sur arg_list_false*)
        let l_val_true = eval_list arg_list_true env in
        let (label_true, new_env) = get_function_label func_name_true label_true env in
        let l_val_false = eval_list arg_list_false new_env in
        let (label_false, new_env2) = get_function_label func_name_true l_val_false new_env in
        fprintf file_out "Sense %t %t %t %t" sensd label_true label_false condition

let rec process_program (Program(program):Ast.program) = match program with
  |[],_ -> print_string "Fin de la compilation"
  |expr::q, sp -> let v = eval expr in (process_program (Program(q, sp)))


let rec process_compare comp file_out = match comp with
  | Eq(expr_left, expr_right) ->  let v1 = eval(expr_left) in
                                  let v2 = eval(expr_right) in
                                  if v1=v2 then true
                                  else false
  | Inf(expr_left, expr_right) ->  let v1 = eval(expr_left) in
                                  let v2 = eval(expr_right) in
                                  if v1<=v2 then true
                                  else false
  | Sup(expr_left, expr_right) ->  let v1 = eval(expr_left) in
                                  let v2 = eval(expr_right) in
                                  if v1=>v2 then true
                                  else false
  | StInf(expr_left, expr_right) ->  let v1 = eval(expr_left) in
                                  let v2 = eval(expr_right) in
                                  if v1>v2 then true
                                  else false
  | StSup(expr_left, expr_right) ->  let v1 = eval(expr_left) in
                                  let v2 = eval(expr_right) in
                                  if v1>v2 then true
                                  else false

