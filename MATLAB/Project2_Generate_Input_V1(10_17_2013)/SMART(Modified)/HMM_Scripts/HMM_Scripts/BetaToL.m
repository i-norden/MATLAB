function L = BetaToL(beta)
nStates = round((-1+sqrt(1+8*length(beta)))/2);
L = tril(ones(nStates,nStates));
ixSet = find(L);
for i = 1:length(ixSet),
    L(ixSet(i)) = beta(i);
end