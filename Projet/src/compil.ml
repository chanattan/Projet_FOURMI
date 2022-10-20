open Ast;;
open Printf;;
open CodeMap;;

type value_env = (string * value) list
type function_env = (string * (string list) * program) list (* nom de la fct, les arguments en nom pour remplacer, le label *)
type environment = value_env * function_env


let bind_value (str:string) (v:value) (env:environment) : environment = let (val_env, fun_env) = env in ((str,v)::val_env, fun_env)

let rec get_func_from_name (name:string) (val_env, fun_env : environment) : (string list) * program = match fun_env with
  |[] -> failwith "Fonction non existante..."
  |(str,_,_)::q when str <> name -> get_func_from_name name (val_env, q) 
  |(_,arg_list, prog)::_ -> arg_list,prog

let rec update_env_for_fun (arg_names:string list) (arg_values: value list) (val_env, fun_env: environment) : environment = match arg_names,arg_values with
  |[],[] ->  (val_env,fun_env)
  |[],_ | _, [] -> failwith "Eh ? Pas le même nombre"
  |name::qname, value::qvalue -> let new_val_env,new_fun_env = update_env_for_fun qname qvalue (val_env,fun_env) in ((name,value)::new_val_env, new_fun_env)



let rec eval (expr : expression Span.located) (env : environment) (file : out_channel) : value * environment = match expr with
  | Const(v, _), _ ->  v, env
  | Var((str, _), exprsp), _ -> let (v, new_env) = eval exprsp env file in (Unit, bind_value str v new_env)
  | Compare(comp, sp), _ -> let bool_val = (process_compare comp file) in (match bool_val with
                                                                | true -> Bool(True, sp), env
                                                                | false -> Bool(False, sp), env)
  | Operation(op, _), _ -> (process_operation op env file), env
  | Command(cmd, _), _ -> let new_env = (process_command cmd file env) in Unit, new_env
  | If((cond, spc), (prog, spp)), _ -> let bool_val, new_env = eval expr env file in (match bool_val with
                                                                | Bool(True, sp) -> process_program prog new_env file
                                                                | Bool(False, sp) -> Unit, env
                                                                | _ -> Span.print spc stderr; failwith "[Type Error] : the return value of the expression is not a boolean.\n")
  | Else(prog, sp), _ -> process_program prog env file
  | While((exp, spe), (prog, spp)), _ -> let bool_val, new_env = eval expr env file in (match bool_val with
                                                                | Bool(True, sp) -> let value, new_env2 = process_program prog new_env file in (match value with
                                                                                                                                | Unit -> eval (exp, spe) new_env2 file (*on réevalue l'expression dans le nouvel environnement*)
                                                                                                                                | _ -> Span.print spp stderr; failwith "[Type Error] : Inside while loop expression is not type unit.\n")
                                                                | Bool(False, sp) -> Unit, env
                                                                | _ -> Span.print spe stderr; failwith "[Type Error] : the return value of the expression is not a boolean.\n")
  | DoWhile((prog, spp), (exp, spe)), _ -> let value, new_env = process_program prog env file in (match value with
                                                                | Unit -> let bool_val = eval expr new_env file in (match bool_val with
                                                                                        | Bool(True, sp) -> eval exp new_env file (*on réevalue l'expression dans le nouvel environnement new_env*)
                                                                                        | Bool(False, sp) -> (), env (*value : vide unit??*)
                                                                                        | _ -> Span.print spe stderr; failwith "[Type Error] : the return value of the expression is not a boolean.\n")
                                                                | _ -> Span.print spp stderr; failwith "[Type Error] : Inside do while loop the expression is not type unit.\n")
  | Apply((name,_), (args_expr,_)),_ -> process_apply name args_expr env file
  (*| Func((ident, sp), (args, list), (prog, spp)) -> *)
  | _ -> failwith "WIP"

and process_condition (condi : cond) (env : environment) (file_out : out_channel) : unit = match condi with
  | Friend -> fprintf file_out "Friend"
  | Foe -> fprintf file_out "Foe"
  | FriendWithFood -> fprintf file_out "FriendWithFood"
  | FoeWithFood -> fprintf file_out "FoeWithFood"
  | Food -> fprintf file_out "Food"
  | Rock -> fprintf file_out "Rock"
  | Marker(expr)  -> let value, env = (eval expr env file_out) in (match value with
                                                        | Int(k, _) -> fprintf file_out "Marker %d" k
                                                        | _ -> failwith "[Type Error] : the marker's expression return value type is not integer.\n")
  | FoeMarker -> fprintf file_out "FoeMarker"
  | Home -> fprintf file_out "Home"
  | FoeHome -> fprintf file_out "FoeHome"

and process_operation (op : operation) (env : environment) (file : out_channel) : value = match op with
| Add((v1, sp), (v2, sp2)) -> let value, new_env = (eval (v1, sp) env file) in
                                let value2, new_env2 = (eval (v2, sp2) new_env file) in (match value, value2 with
                                                                                | Int(i, spp), Int(y, _) -> Int(i + y, spp)
                                                                                | _, _ -> Span.print sp stderr; failwith "[Type Error] : there was an error while trying to sum up two values.\n")
| Sub((v1, sp), (v2, sp2)) -> let value, new_env = (eval (v1, sp) env file) in
                                let value2, new_env2 = (eval (v2, sp2) new_env file) in (match value, value2 with
                                | Int(i, spp), Int(y, _) -> Int(i - y, spp)
                                | _, _ -> Span.print sp stderr; failwith "[Type Error] : there was an error while trying to substract two values.\n")
| Mul((v1, sp), (v2, sp2)) -> let value, new_env = (eval (v1, sp) env file) in
                                let value2, new_env2 = (eval (v2, sp2) new_env file) in (match value, value2 with
                                | Int(i, spp), Int(y, _) -> Int(i * y, spp)
                                | _, _ -> Span.print sp stderr; failwith "[Type Error] : there was an error while trying to multiply two values.\n")
| Div((v1, sp), (v2, sp2)) -> let value, new_env = (eval (v1, sp) env file) in
                                let value2, new_env2 = (eval (v2, sp2) new_env file) in (match value, value2 with
                                | Int(i, spp), Int(y, _) -> Int(i / y, spp)
                                | _, _ -> Span.print sp stderr; failwith "[Type Error] : there was an error while trying to divide two values.\n")
| Mod((v1, sp), (v2, sp2)) -> let value, new_env = (eval (v1, sp) env file) in
                                let value2, new_env2 = (eval (v2, sp2) new_env file) in (match value, value2 with
                                | Int(i, spp), Int(y, _) -> Int(i mod y, spp)
                                | _, _ -> Span.print sp stderr; failwith "[Type Error] : there was an error while trying to use modulo.\n")

and process_program (Program(program) : Ast.program) (env : environment) (file : out_channel) : value * environment = match program with
|[],_ -> Unit, env
|expr::q, sp -> let value, new_env = eval expr env file in match value with
                                              | Unit -> (process_program (Program(q, sp)) new_env file)
                                              | _ -> if q <> [] then failwith "[Type Error] : There is a non-last return value that is not type unit.\n"
                                                      else value, new_env (*On utilise un comportement similaire à Caml qui retourne la dernière valeur qui n'est pas de type unit.*)
and process_compare (comp : compare) (file_out : out_channel) : bool = match comp with
| Eq(expr_left, expr_right) ->  let v1 = eval (expr_left) in
                                let v2 = eval (expr_right) in
                                if v1=v2 then true
                                else false
| Inf(expr_left, expr_right) ->  let v1 = eval (expr_left) in
                                let v2 = eval (expr_right) in
                                if v1<=v2 then true
                                else false
| Sup(expr_left, expr_right) ->  let v1 = eval (expr_left) in
                                let v2 = eval (expr_right) in
                                if v1>=v2 then true
                                else false
| StInf(expr_left, expr_right) ->  let v1 = eval (expr_left) in
                                let v2 = eval (expr_right) in
                                if v1>v2 then true
                                else false
| StSup(expr_left, expr_right) ->  let v1 = eval (expr_left) in
                                let v2 = eval (expr_right) in
                                if v1>v2 then true
                                else false

and eval_list (list: (expression Span.located) list) (env: environment) (file: out_channel) = 
  let newEnv = ref env in
  let rec aux l = match l with
    | [] -> []
    | expr::q -> let v,tempEnv = eval expr (!newEnv) file in newEnv := tempEnv ; v::(aux q)
  in (aux list,!newEnv)

(* process_command va traiter les commandes primitives concernant une fourmi*)
and process_command (cmd : command) (file_out : out_channel) (env : environment) : environment = match cmd with
	(*| Move(((func_name, sp1),(arg_list, sp3))) -> (*les sp sont les Span : on ne les utilise pas*)
        let l_val, new_env = eval_list arg_list env file_out in
                let (label, new_env) = get_function_label func_name l_val env in
                        fprintf file_out "Move %t" label;
                                new_env*)
	| Mark((i, sp)) -> (*i représente le ième bit à modifier sur la case marquée*)
        fprintf file_out "Mark %d" i;
        env
	| Unmark((i, sp)) -> (*de même pour unmark*)
        fprintf file_out "Unmark %d" i;
        env
	(*| Pickup(func_name, arg_list) ->
        let l_val = eval_list arg_list env in
                let (label, new_env) = get_function_label func_name l_val env in
                        fprintf file_out "Pickup %t" label;
                                new_env*)
	| Turn(dir, sp) -> (*dir représente la direction dans laquelle la fourmi va tourner*)
        (match dir with
                | Left -> fprintf file_out "Turn Left"
                | Right -> fprintf file_out "Turn Right");
        env
	(*| Sense(sensd, condition, func_name_true, arg_list_true, func_name_false, arg_list_false) -> (*Sense va, selon la condition et pour une direction sensd donnée, évaluer la fonction func_name_true sur arg_list_true ou func_name_false sur arg_list_false*)
        let l_val_true = eval_list arg_list_true env in
                let (label_true, new_env) = get_function_label func_name_true label_true env in
                        let l_val_false = eval_list arg_list_false new_env in
                                let (label_false, new_env2) = get_function_label func_name_true l_val_false new_env in
                                        fprintf file_out "Sense %t %t %t %t" sensd label_true label_false condition*)

(** On traite le cas Apply d'appel d'une fonction name avec les arguments args_expr sous forme d'expression dans l'environnement spécifié *)
(** On va rajouter des labels pour s'occuper des sauts avant et après *)
and process_apply (name:string) (args_expr:expression Span.located list) (val_env,fun_env:environment) (file : out_channel) : value = 
  let arg_names,prog = get_func_from_name name (val_env,fun_env) in (* On récupère les informations de la fonction *)
  let (arg_values,(new_val_env,new_fun_env)) = eval_list args_expr  (val_env,fun_env) file in (* On évalue nos arguments *)
  let apply_val_env,apply_fun_env = update_env_for_fun arg_names arg_values  (new_val_env,new_fun_env) in (* On met à jour juste pour la fonction*)
  
  (* Il faut écrire le goto avec le nouveau label, le nouveau label quelque part (dans un tout nouveau fichier unique à chaque fois que l'on re-fusionne à la fin) *)
  let time = Int.to_string (Float.to_int (Sys.time ())) in
  let goto_label = "fun_"^name^time in (* On crée un label unique de la future fonction (avec le temps) *)
  let current_label = "current_"^name^time in (* On crée le label de retour de la fonction (ici) *)
  fprintf file "Goto %s \n\t" goto_label ; (* On fait "l'appel" à la fonction en allant à son label *)
  fprintf file "%s:\n\t" (current_label) ; (* On écrit dans le fichier le label de retour de la fonction ici *)
  let new_file = open_out_gen [Open_creat] 0o777 (goto_label^".temp") in (* On crée le flux pour le nouveau fichier *)
  fprintf new_file "%s:\n\t" (goto_label) ; (* On écrit au début du nouveau fichier le label associé à l'appel de la fonction *)
  let v,post_env = process_program prog (apply_val_env,apply_fun_env) new_file in (* On process ce qui signifie qu'on écrit le programme dans le fichier *)
  fprintf new_file "Goto %s\n\t" (current_label) ; (* On écrit le goto de retour (comme le return) à la fin du nouveau fichier *)
  v


let start_program (prog : program) (env: environment) (file_out : out_channel) : unit =
        let q = "ratio" in q;