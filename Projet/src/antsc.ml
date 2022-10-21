open Printf;;

let write_file filename = (* Ceci est un exemple. *)
  let oc = open_out filename in (* Ouvre un fichier pour écrire dedans. *)
  let write_label (msg:string) : unit = (* Écriture d'un label. *)
    fprintf oc "%s:\n" msg in
  let write_command (msg:string) : unit = (* Écriture d'autres commandes. *)
    fprintf oc "  %s\n" msg in
  write_label   "start";
  write_command "Drop";
  write_command "Goto start";
  close_out oc

let process_file filename =
  (* Ouvre le fichier et créé un lexer. *)
  let file = open_in filename in
  let lexer = Lexer.of_channel file in
  (* Parse le fichier. *)
  let (program, span) = Parser.parse_program lexer in
  printf "successfully parsed the following program at position %t:\n%t\n" (CodeMap.Span.print span) (Ast.print_program program) ;
  program, span

(* Le point de départ du compilateur. *)
let _ =
  (* On commence par lire le nom du fichier à compiler passé en paramètre. *)
  let n = Array.length Sys.argv in
  if n <= 1 then begin
    (* Pas de fichier... *)
    eprintf "no file provided.\n";
    exit 1
  end else begin
    try
      (* On compile le fichier. *)
      let program,_ = process_file (Sys.argv.(1)) in 
      Compil.start_program (program) ([],[]) "out.brain"
    with
    | Lexer.Error (e, span) ->
      eprintf "Lex error: %t: %t\n" (CodeMap.Span.print span) (Lexer.print_error e)
    | Parser.Error (e, span) ->
      eprintf "Parse error: %t: %t\n" (CodeMap.Span.print span) (Parser.print_error e)
    | Failure(str) -> (* Dans le cas d'un crash *)
      let _ = Sys.command "rm -f *.temp" in (* On clean tous les fichiers .temp*)
      eprintf " : %s" str

  end
