% Solve power flow problem for -< shaped diagram on paper

mpc = create_DER_mpc();

mpopt = mpoption('pf.nr.max_it', 10, 'verbose', 0, 'out.all', 0);

soln = runpf(mpc, mpopt);

% Get P, Q data for a battery
battpath = 'C:/Users/jsn1/Documents/AQL/DER/battery';
typetable = readtable(strcat(battpath, '/DERtype.csv'));
statetable = readtable(strcat(battpath, '/state.csv'));
transtable = readtable(strcat(battpath, '/transition.csv'));

[battP, battQ] = get_steady_PQ(typetable.id{1},statetable,transtable);

% Find where to place the battery to minimize loss

[~, ~, ~, ~, ~, ~, PD, QD, ~, ~, ~, ~, ~, ...
    ~, ~, ~, ~, ~, ~, ~, ~] = idx_bus;

losses = zeros(1,3);
for bus_i = 2:4
    mpc2 = mpc;
    mpc2.bus(bus_i,PD) = mpc2.bus(bus_i,PD) + battP;
    mpc2.bus(bus_i,QD) = mpc2.bus(bus_i,QD) + battQ;
    soln2 = runpf(mpc2, mpopt);
    losses(bus_i-1) = sum(abs(get_losses(soln2)));
end

[~, minbusm1] = min(losses);

minbus = minbusm1 + 1;