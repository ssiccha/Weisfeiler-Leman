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
