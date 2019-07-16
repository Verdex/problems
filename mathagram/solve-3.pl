
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

solve(H1, T1, O1, H2, T2, O2, H3, T3, O3, H4, T4, O4, H5, T5, O5, H6, T6, O6) :-
    gen(O1, [1, 2, 3, 4, 5, 6, 7, 8, 9,
             1, 2, 3, 4, 5, 6, 7, 8, 9], O1Rem),
    gen(O2, O1Rem, O2Rem),
    gen(O3, O2Rem, O3Rem),
    gen(O4, O3Rem, O4Rem),
    gen(O5, O4Rem, O5Rem),
    gen(O6, O5Rem, O6Rem),
    LO is (O1 + O2 + O3 + O4) mod 10,
    RO is (O5 + O6)  mod 10,
    LO is RO,
    gen(T1, O6Rem, T1Rem),
    gen(T2, T1Rem, T2Rem),
    gen(T3, T2Rem, T3Rem),
    gen(T4, T3Rem, T4Rem),
    gen(T5, T4Rem, T5Rem),
    gen(T6, T5Rem, T6Rem),
    LT is (T1 + T2 + T3 + T4 + ((O1 + O2 + O3 + O4) // 10)) mod 10,
    RT is (T5 + T6 + ((O5 + O6) // 10)  mod 10,
    LT is RT,
    gen(H1, T6Rem, H1Rem),
    gen(H2, H1Rem, H2Rem),
    gen(H3, H2Rem, H3Rem),
    gen(H4, H3Rem, H4Rem),
    gen(H5, H4Rem, H5Rem),
    gen(H6, H5Rem, _),
    L is ((H1 + H2 + H3 + H4) * 100) + ((T1 + T2 + T3 + T4) * 10) + O1 + O2 + O3 + O4,
    R is ((H5 + H6) * 100) + ((T5 + T6) * 10) + O5 + O6,
    L is R.

