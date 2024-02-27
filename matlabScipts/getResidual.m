function residual = getResidual(input)

a = lpc(input, 3);

a_1 = [0 -a(2:end)]; %vector to estimate x with LP
est_x = filter(a_1, 1, input);

residual = input- est_x; %e[n]