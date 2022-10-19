open Ast;;
open Printf;;


let rec processProgram (program,span:Ast.program CodeMap.Span.located) =  ()

let rec processCommand comm out_chan env = match comm with
	| Move(((str,sp1),([expr, sp2],sp3))) ->
        let lVal = listEval expr env in
        let (label, newEnv) = getFunctionLabel str lVal env in
        fprintf  out_chan "Move %t" label;
        newEnv
	| Mark((i, sp)) ->
        fprintf out_chan "Mark %t" i;
        env
	| Unmark((i, sp)) ->
        fprintf out_chan "Unmark i";
        env
	| Pickup(str,expr) ->
        let lVal = listEval expr env in
        let (label, newEnv) = getFunctionLabel str lVal env in
        fprintf  out_chan "Pickup %t" label;
        newEnv
	| Turn(dir, sp) ->
        fprintf out_chan "Turn %t" dir;
        env
	| Sense(sensd, condition, strOui, exprOui, strNon, exprNon) ->
        let lValOui = listEval exprOui env in
        let (labelOui, newEnv) = getFunctionLabel strOui lValOui env in
        let lValNon = listEval exprNon newEnv in
        let (labelOui, newEnv2) = getFunctionLabel strOui lValNon newEnv in

        fprintf out_chan "Sense %t %t %t %t" sesd labelOui labelNon condition;




let rec getFunctionLabel str values env = match env with
    | (_,[]) -> (str,[str,values,str])
    | (_, a::b) -> let (nom, arg, labels) = a in
                    if str=nom && values=arg then (label, env)
                    else getFunctionLabel str values b



let rec listEval liste env = match liste with
|[] -> []
|a::b -> (eval a) :: (ListEval b env)
