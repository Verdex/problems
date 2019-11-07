
type z = Z
type 'a s = { dec : 'a }

let b : ((int list * 'a) -> 'b) -> 'b =
    fun next ->
    next ([], Z)

let p : (int list * 'a) -> int -> ((int list * 'b) -> 'c) -> 'c =
    fun (stack, tc) ->
    fun number ->
    fun next ->
    next ((List.cons number stack), { dec = tc })

let e : (int list * 'a s) -> int =
    fun (stack, _) ->
    List.hd stack

let a : (int list * ('a s) s) -> ((int list * 'b) -> 'c) -> 'c =
    fun (stack, tc) ->
    fun next ->
    match stack with
    | a::b::r -> next ((List.cons (a+b) r), tc.dec)

let p1 = b p 0 e

let p2 = b p 1 p 2 a e

let p3 = b p 1 p 2 a p 3 a e

let p4 = b p 0 p 0 a p 5 a p 10 e

let print (i:int) = Printf.printf "%d\n" i

;;

print p1

;;

print p2

;;

print p3

;;

print p4

