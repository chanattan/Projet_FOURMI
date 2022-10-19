open Ast;;
open Printf;;


let process_program (program, span:Ast.program CodeMap.Span.located) = ()


let rec get_function_label str values env = match env with
    | (_,[]) -> (str,[str,values,str])
    | (_, a::b) -> let (name, arg, labels) = a in
                    if str = name && values = arg then (label, env)
                    else get_function_label str values b


let rec eval_list list env = match list with
|[] -> []
|a::b -> (eval a env) :: (eval_list b env)


(* process_command va traiter les commandes primitives concernant une fourmi*)
let rec process_command cmd file_out env = match cmd with
	| Move(((func_name, sp1),([arg_list, sp2], sp3))) -> (*les sp sont les Span : on ne les utilise pas*)
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