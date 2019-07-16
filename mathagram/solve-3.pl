
gen(X, Avail, NewAvail) :- member(X, Avail)
                         , subtract(Avail, [X], NewAvail).


solve(H1, T1, O1, H2, T2, O2, H3, T3, O3) :-
    gen(O1, [1, 2, 3, 4, 5, 6, 7, 8, 9], O1Rem),
    gen(O2, O1Rem, O2Rem),
    gen(O3, O2Rem, O3Rem),
    O3 is (O2 + O1) mod 10,
    gen(T1, O3Rem, T1Rem),
    gen(T2, T1Rem, T2Rem),
    gen(T3, T2Rem, T3Rem),
    T3 is (T1 + T2 + ((O2 + O1) // 10)) mod 10,
    gen(H1, T3Rem, H1Rem),
    gen(H2, H1Rem, H2Rem),
    gen(H3, H2Rem, _),
    L is ((H1 + H2) * 100) + ((T1 + T2) * 10) + O1 + O2,
    R is (H3 * 100) + (T3 * 10) + O3,
    L is R.

