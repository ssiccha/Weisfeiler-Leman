nrSmallGroupsPerOrderLookupTable := List([1..512], n -> NrSmallGroups(n));
nrSmallGroupsUpToOrder := List([1..512], n -> Sum(nrSmallGroupsPerOrderLookupTable{[1..(n-1)]}));

invariantUsedForColoring := function(G)
    id := IdSmallGroup(G);
    return nrSmallGroupsUpToOrder[id[1]] + id[2];
end;

elementToNumber := function(g)
    local powers, number, e;
    powers := ExtRepOfObj(g);
    powers := powers{[1, 3 .. Length(powers) - 1]};
    number := 0;
    for e in powers do
        number := number + 2 ^ (e - 1);
    od;
    return number + 1;
end;

# This improves time from 45s to 35s for a group of order 256.
TwoProfileViaConjugacyClasses := function(G)
    local elementsOfGroup, conjugacyClasses, positionOfConjugates, conjugatorsForClasses, i, representative, conjugators, conjugator, positionConjugator, allColors, conjugacyClassRepresentatives, k, position, id, j, class, elm, g1, g2, r;
    elementsOfGroup := Elements(G);
    conjugacyClasses := ConjugacyClasses(G);
    positionOfConjugates
        := List(elementsOfGroup,
                x -> List(elementsOfGroup,
                          y -> Position(elementsOfGroup, x ^ y)));
    conjugatorsForClasses := List([1..Length(conjugacyClasses)], x -> []);
    i := 0;
    for class in conjugacyClasses do
        i := i  +  1;
        representative := Representative(class);
        # conjugators[j] is an element conjugating representative to
        # AsList(class)[j].
        conjugators := conjugatorsForClasses[i];
        for elm in AsList(class) do
            conjugator := RepresentativeAction(G, representative, elm);
            positionConjugator := Position(elementsOfGroup, conjugator);
            Add(conjugators,
                rec(positionConjugate := Position(elementsOfGroup, elm),
                    positionConjugator := positionConjugator));
        od;
    od;
    # Next idea: also use the centralizer of g ^ x. Namely Group(g ^ x, h ^ x)
    # is isomorphic to Group(g ^ x, h ^ (x * c)) where c centralizes g ^ x.
    allColors := List([1..Order(G)], x -> EmptyPlist(Order(G)));
    conjugacyClassRepresentatives := List(conjugacyClasses, Representative);
    k := 0;
    for g1 in conjugacyClassRepresentatives do
        k := k + 1;
        position := Position(elementsOfGroup, g1);
        conjugators := conjugatorsForClasses[k];
        for g2 in elementsOfGroup do
            id := invariantUsedForColoring(Group(g1, g2));
            # We identify each group element with its Position in
            # elementsOfGroup. For each conjugate g1 ^ x we write id into
            # allColors[g1 ^ x, g2 ^ x].
            for r in conjugators do;
                # i := Position(elementsOfGroup, g1 ^ r.conjugator);
                # j := Position(elementsOfGroup, g2 ^ r.conjugator);
                i := r.positionConjugate;
                j := positionOfConjugates[
                    Position(elementsOfGroup, g2),
                    r.positionConjugator
                ];
                allColors[i, j] := id;
            od;
        od;
    od;
    return allColors;
end;

TwoProfile := function(G)
    local allColors, elementsOfGroup, i, j, g1, g2;
    allColors := List([1..Order(G)], x -> EmptyPlist(Order(G)));
    elementsOfGroup := Elements(G);
    i := 0;
    for g1 in elementsOfGroup do
        i := i + 1;
        j := 0;
        for g2 in elementsOfGroup do
            j := j + 1;
            if j < i then
                allColors[i, j] := allColors[j, i];
            else
                allColors[i, j] := invariantUsedForColoring(Group(g1, g2));
            fi;
        od;
    od;
    return allColors;
end;

TwoProfileHumanReadable := function(G)
    local coloringZero;
    coloringZero := TwoProfile(G);
    return Collected(Concatenation(coloringZero));
end;

TwoProfileRecursion := function(allColors, G)
    local nextStepAllColors, i, j, newColor, k, g1, g2, x;
    nextStepAllColors := List([1..Order(G)], x -> EmptyPlist(Order(G)));
    i := 0;
    for g1 in G do
        i := i + 1;
        j := 0;
        for g2 in G do
            j := j + 1;
            newColor := [];
            newColor[1] := allColors[i,j];
            newColor[2] := EmptyPlist(Length(allColors[1]));
            k := 0;
            for x in G do
                k := k  +  1;
                newColor[2][k] := [allColors[k, j], allColors[i, k]];
            od;
            # Form the multi-set of colors
            newColor[2] := Collected(newColor[2]);
            nextStepAllColors[i,j] := newColor;
        od;
    od;
    return nextStepAllColors;
end;


timeSHOWMIN := 100;
ColorPrompt(true, rec(
  PrePrompt := function()
   # show the 'time' automatically if at least timeSHOWMIN
   if CPROMPT() = "gap> " and time >= timeSHOWMIN then
    Print("Time of last command: ", time, " ms\n");
   fi;
end)
);
