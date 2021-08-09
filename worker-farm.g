if not IsBound(workerId) then
    ErrorNoReturn("Must set workerId via -c command line option!");
fi;
if not IsBound(nrTotalWorkers) then
    ErrorNoReturn("Must set nrTotalWorkers via -c command line option!");
fi;

Read("wip.g");

nrSmallGroups := NrSmallGroups(256);
quotient := QuoInt(nrSmallGroups, nrTotalWorkers);
myShare := rec(first := (workerId - 1) * quotient + 1);
if workerId <> nrTotalWorkers then
    myShare.last := workerId * quotient;
else
    myShare.last := nrSmallGroups;
fi;
Print(myShare, "\n");

fileName := Concatenation("TwoProfileMultisetsOrder256-", String(workerId));
Print("Clearing ", fileName, "\n");
PrintTo(fileName, "");
for i in [myShare.first .. myShare.last] do
    G := SmallGroup(256, i);
    Print(i, "\n");
    AppendTo(fileName, TwoProfileMultiset(G));
    if i <> myShare.last then
        AppendTo(fileName, ",\n");
    fi;
od;
QuitGap(0);
