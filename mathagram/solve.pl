equal(LhsHun1, LhsTen1, LhsOne1, 
      LhsHun2, LhsTen2, LhsOne2,
      RhsHun1, RhsTen1, RhsOne1) :-
    0 is (LhsHun2 + LhsHun1) // 10,
    Rhs is (RhsHun1 * 100) + (RhsTen1 * 10) + RhsOne1,
    Lhs1 is (LhsHun1 * 100) + (LhsTen1 * 10) + LhsOne1,
    Lhs2 is (LhsHun2 * 100) + (LhsTen2 * 10) + LhsOne2,
    Rhs is Lhs1 + Lhs2. 

solve(LhsHun1, LhsTen1, LhsOne1, 
      LhsHun2, LhsTen2, LhsOne2,
      RhsHun1, RhsTen1, RhsOne1) :-
    permutation([LhsHun1, LhsTen1, LhsOne1, 
                 LhsHun2, LhsTen2, LhsOne2,
                 RhsHun1, RhsTen1, RhsOne1],
                 [1, 2, 3, 4, 5, 6, 7, 8, 9]),
    equal(LhsHun1, LhsTen1, LhsOne1, 
      LhsHun2, LhsTen2, LhsOne2,
      RhsHun1, RhsTen1, RhsOne1).

