open Ast;;
open Printf;;


let rec processProgram (program,span:Ast.program CodeMap.Span.located) =  ()

let rec processCommand comm out_chan env = match comm with
	| Move(((nom_fonction,sp1),([liste_arg, sp2],sp3))) -> (*les sp sont les Span : on ne les utilise pas*)
        let l_val = listEval liste_arguments env in
        let (label, new_env) = getFunctionLabel nom_fonction l_val env in
        fprintf  out_chan "Move %t" label;
        newEnv
	| Mark((i, sp)) ->
        fprintf out_chan "Mark %t" i;
        env
	| Unmark((i, sp)) ->
        fprintf out_chan "Unmark i";
        env
	| Pickup(nom_fonction,liste_arg) ->
        let l_val = listEval liste_arg env in
        let (label, new_env) = getFunctionLabel nom_fonction l_val env in
        fprintf  out_chan "Pickup %t" label;
        new_env
	| Turn(dir, sp) ->
        fprintf out_chan "Turn %t" dir;
        env
	| Sense(sensd, condition, strOui, exprOui, strNon, exprNon) ->
        let lValOui = listEval exprOui env in
        let (labelOui, new_env) = getFunctionLabel strOui lValOui env in
        let lValNon = listEval exprNon new_env in
        let (labelOui, new_env2) = getFunctionLabel strOui lValNon new_env in

        fprintf out_chan "Sense %t %t %t %t" sensd labelOui labelNon condition;




let rec getFunctionLabel str values env = match env with
    | (_,[]) -> (str,[str,values,str])
    | (_, a::b) -> let (nom, arg, labels) = a in
                    if str=nom && values=arg then (label, env)
                    else getFunctionLabel str values b



let rec listEval liste env = match liste with
|[] -> []
|a::b -> (eval a) :: (ListEval b env)
