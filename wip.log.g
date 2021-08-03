gap> G := SmallGroup(256, 10);
<pc group of size 256 with 8 generators>
gap> colorZero := WeisfeilerLeman(G);; time;
89483
gap> Length(DuplicateFreeList(Concatenation(colorZero)));
13
gap> time;
45
gap> colorOne := WeisfeilerLemanRecursion(colorZero);; time; Length(DuplicateFreeList(Concatenation(colorOne)));
212285
328
Time of last command: 2510 ms


gap> G := OneSmallGroup(256, RankPGroup, [3]);;
gap> IdSmallGroup(G);
[ 256, 542 ]
gap> colorZero := WeisfeilerLeman(G);; time;
87714
gap> niceZero := Collected(Concatenation(colorZero));
[ [ [ 1, 1 ], 1 ], [ [ 2, 1 ], 93 ], [ [ 4, 1 ], 1344 ], [ [ 4, 2 ], 930 ],
  [ [ 8, 2 ], 20160 ], [ [ 16, 2 ], 6144 ], [ [ 32, 2 ], 36864 ] ]
Time of last command: 178 ms
