let one_lhs = [ `Hun(Some(1), 1) ; `Ten(None, 1) ; `One(None, 1) 
              ; `Hun(None, 2) ; `Ten(None, 2) ; `One(None, 2) ] 
let one_rhs = [ `Hun(Some(4), 1) ; `Ten(Some(6), 1) ; `One(Some(8), 1) ]
;;

let p v = 
    match v with
    | `Hun(Some(v), _) -> Printf.sprintf "%d??" v
    | `Hun(None, _) -> "x??" 
    | `Ten(Some(v), _) -> Printf.sprintf "?%d?" v
    | `Ten(None, _) -> "?x?" 
    | `One(Some(v), _) -> Printf.sprintf "??%d" v
    | `One(None, _) -> "??x" 
;;

let rec skip l i = 
    match l with
    | [] -> []
    | h::t -> (match i with 
               | 0 -> h::t
               | _ -> skip t (i-1))
;;

let (|>) a b = b a
;;

let proj i = 
    match i with
    | `Hun(Some(v), _) -> v 
    | `Ten(Some(v), _) -> v 
    | `One(Some(v), _) -> v 
;;

let is_constant i =
    match i with
    | `Hun(Some(_), _) -> true
    | `Ten(Some(_), _) -> true
    | `One(Some(_), _) -> true
    | _ -> false
;;

let is_variable i = 
        match i with
        | `Hun(None, _) -> true
        | `Ten(None, _) -> true
        | `One(None, _) -> true
        | _ -> false
;;

let to_constant i v =
    match i with
    | `Hun(_,x) -> `Hun(Some(v), x)
    | `Ten(_,x) -> `Ten(Some(v), x)
    | `One(_,x) -> `One(Some(v), x)
;;

(* this sum probably only works in continue*)
let sum l = List.map proj l |> List.fold_left (+) 0
;;

let continue lhs rhs =
    let has_unknown = List.exists is_variable in
    let has_unknown_or_equal r l = 
        (has_unknown r || has_unknown l) || ((sum r) = (sum l))
    in
    let hun_lhs = List.filter (function `Hun(_,_) -> true | _ -> false) lhs in
    let ten_lhs = List.filter (function `Ten(_,_) -> true | _ -> false) lhs in
    let one_lhs = List.filter (function `One(_,_) -> true | _ -> false) lhs in
    let hun_rhs = List.filter (function `Hun(_,_) -> true | _ -> false) rhs in
    let ten_rhs = List.filter (function `Ten(_,_) -> true | _ -> false) rhs in
    let one_rhs = List.filter (function `One(_,_) -> true | _ -> false) rhs in
    (has_unknown_or_equal hun_lhs hun_rhs) 
    && (has_unknown_or_equal ten_lhs ten_rhs) 
    && (has_unknown_or_equal one_lhs one_rhs) 
;;

let rec solve lhs rhs numbers =
    let rec blarg v c r ns =
        match ns with
        | [] -> (false, [], [])
        | n::t -> (

        )

    if continue lhs rhs then
        let lhs_constants = List.filter is_constant lhs in
        let lhs_variables = List.filter is_variable lhs in
        let rhs_constants = List.filter is_constant rhs in
        let rhs_variables = List.filter is_variable rhs in

        if (List.length lhs_variables) <> 0 then
            let v = List.nth lhs_variables 0 in
            
            let n = List.nth numbers 0 in
            solve (lhs_constants @ (skip lhs_variables 1)) rhs (skip numbers 1) 
            (true, [], [])
        else if (List.length rhs_variables) <> 0 then
            (true, [], [])
        else
            (true, lhs_constants, rhs_constants) 
    else
        (false, [], [])

;;
List.iter (fun x -> Printf.printf "%s\n" (p x)) one_rhs
;;
Printf.printf "%B\n" (continue one_lhs one_rhs)
;;
let (b, lhs, rsh) = solve one_lhs one_rhs [1,2,3] in
    Printf.printf "success %B\n" b
