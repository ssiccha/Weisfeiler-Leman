WeisfeilerLeman := function(G)
    local groupIdOfG, i, allColors, j, g1, g2;
    groupIdOfG := IdGroup(G);
    i := 0;
    allColors := List([1..Order(G)], x -> EmptyPlist(Order(G)));
    for g1 in G do
        i := i+1;
        j := 0;
        for g2 in G do
            j := j+1;
            # This check has to be thrown out eventually, since 2-generated G
            # are solved by the zero-th coloring.
            if IsSubgroup(Group(g1, g2), G) then
                allColors[i, j] := groupIdOfG;
            else
                allColors[i, j] := IdGroup(Group(g1, g2));
            fi;
        od;
    od;
    return allColors;
end;

WeisfeilerLemanRecursion := function(allColors)
    local nextStepAllColors, i, j, newColor, k, g1, g2, x;
    nextStepAllColors := List([1..Order(G)], x -> EmptyPlist(Order(G)));
    i := 0;
    for g1 in G do
        i := i+1;
        j := 0;
        for g2 in G do
            j := j+1;
            newColor := [];
            newColor[1] := allColors[i,j];
            newColor[2] := EmptyPlist(Length(allColors[1]));
            k := 0;
            for x in G do
                k := k + 1;
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
# usually cyan bold, see ?TextAttr
  PrePrompt := function()
   # show the ‘time’ automatically if at least timeSHOWMIN
   if CPROMPT() = "gap> " and time >= timeSHOWMIN then
    Print("Time of last command: ", time, " ms\n");
   fi;
end)
);
