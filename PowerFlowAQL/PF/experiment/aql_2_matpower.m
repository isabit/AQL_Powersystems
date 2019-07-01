% Takes 4 csv files exported from aql : bus.csv, gen.csv, branch.csv,
% pf_solver.csv
% generates struct for input to matpower

% index names of attributes for bus,branch, gen etc.
[PQ, PV, REF, NONE, BUS_I, BUS_TYPE, PD, QD, GS, BS, BUS_AREA, VM, ...
     VA, BASE_KV, ZONE, VMAX, VMIN, LAM_P, LAM_Q, MU_VMAX, MU_VMIN] = idx_bus;
 [GEN_BUS, PG, QG, QMAX, QMIN, VG, MBASE, GEN_STATUS, PMAX, PMIN, ...
     MU_PMAX, MU_PMIN, MU_QMAX, MU_QMIN, PC1, PC2, QC1MIN, QC1MAX, ...
     QC2MIN, QC2MAX, RAMP_AGC, RAMP_10, RAMP_30, RAMP_Q, APF] = idx_gen;
 [F_BUS, T_BUS, BR_R, BR_X, BR_B, RATE_A, RATE_B, RATE_C, ...
     TAP, SHIFT, BR_STATUS, PF, QF, PT, QT, MU_SF, MU_ST, ...
ANGMIN, ANGMAX, MU_ANGMIN, MU_ANGMAX] = idx_brch;
%[PW_LINEAR, POLYNOMIAL, MODEL, STARTUP, SHUTDOWN, NCOST, COST] = idx_cost;

bus_in = readtable('mpsdata/bus.csv');
bus_names = bus_in.Properties.VariableNames;
gen_in = readtable('mpsdata/gen.csv');
branch_in = readtable('mpsdata/branch.csv');
pf_solver_in = readtable('mpsdata/pf_solver.csv');
% line_in = readtable('mpsdata/line.csv');
% gencost_in = readtable('mpsdata/gencost.csv');


%%-----  Power Flow Data  -----%%

%% bus data

% subtracting so we don't count 'id' column
bus= zeros(size(bus_in) - [0, 1]);
for i = 1:height(bus_in)
    bus(i,BUS_I) = str2double(bus_in.BUS_I{i});
    bus(i,BUS_TYPE) = str2double(bus_in.BUS_TYPE{i});
    bus(i,PD) = str2double(bus_in.PD{i});
    bus(i,QD) = str2double(bus_in.QD{i});
    bus(i,GS) = str2double(bus_in.GS{i});
    bus(i,BS) = str2double(bus_in.BS{i});
    bus(i,BUS_AREA) = str2double(bus_in.BUS_AREA{i});
    bus(i,VM) = str2double(bus_in.VM{i});
    bus(i,VA) = str2double(bus_in.VA{i});
    bus(i,BASE_KV) = str2double(bus_in.BASE_KV{i});
    bus(i,ZONE) = str2double(bus_in.ZONE{i});
    bus(i,VMAX) = str2double(bus_in.VMAX{i});
    bus(i,VMIN) = str2double(bus_in.VMIN{i});
end

%% gen data

gen = zeros(size(gen_in) - [0, 2]);
for i = 1:height(gen_in)
    gen(i,GEN_BUS) = str2double(gen_in.GEN_BUS{i});
    gen(i,PG) = str2double(gen_in.PG{i});
    gen(i,QG) = str2double(gen_in.QG{i});
    gen(i,QMAX) = str2double(gen_in.QMAX{i});
    gen(i,QMIN) = str2double(gen_in.QMIN{i});
    gen(i,VG) = str2double(gen_in.VG{i});
    gen(i,MBASE) = str2double(gen_in.MBASE{i});
    gen(i,GEN_STATUS) = str2double(gen_in.GEN_STATUS{i});
    gen(i,PMAX) = str2double(gen_in.PMAX{i});
    gen(i,PMIN) = str2double(gen_in.PMIN{i});
    gen(i,PC1) = str2double(gen_in.PC1{i});
    gen(i,PC2) = str2double(gen_in.PC2{i});
    gen(i,QC1MIN) = str2double(gen_in.QC1MIN{i});
    gen(i,QC1MAX) = str2double(gen_in.QC1MAX{i});
    gen(i,QC2MIN) = str2double(gen_in.QC2MIN{i});
    gen(i,QC2MAX) = str2double(gen_in.QC2MAX{i});
    gen(i,RAMP_AGC) = str2double(gen_in.RAMP_AGC{i});
    gen(i,RAMP_10) = str2double(gen_in.RAMP_10{i});
    gen(i,RAMP_30) = str2double(gen_in.RAMP_30{i});
    gen(i,RAMP_Q) = str2double(gen_in.RAMP_Q{i});
    gen(i,APF) = str2double(gen_in.APF{i});
end

%% branches

branch = zeros( size(branch_in) - [0, 3] );
for i = 1:height(branch_in)
    branch(i, F_BUS) = str2double(branch_in.F_BUS{i});
    branch(i, T_BUS) = str2double(branch_in.T_BUS{i});
    branch(i, BR_R) = str2double(branch_in.BR_R{i});
    branch(i, BR_X) = str2double(branch_in.BR_X{i});
    branch(i, BR_B) = str2double(branch_in.BR_B{i});
    branch(i, RATE_A) = str2double(branch_in.RATE_A{i});
    branch(i, RATE_B) = str2double(branch_in.RATE_B{i});
    branch(i, RATE_C) = str2double(branch_in.RATE_C{i});
    branch(i, TAP) = str2double(branch_in.TAP{i});
    branch(i, SHIFT) = str2double(branch_in.SHIFT{i});
    branch(i, BR_STATUS) = str2double(branch_in.BR_STATUS{i});
    branch(i, ANGMIN) = str2double(branch_in.ANGMIN{i});
    branch(i, ANGMAX) = str2double(branch_in.ANGMAX{i});
    
end

%% gencost
% 
% gencost = zeros( size(gencost_in) );
% for i = 1:height(gencost_in)
%     gencost(i,MODEL) = str2double(gencost_in.gencost_MODEL{i});
%     gencost(i,STARTUP) = str2double(gencost_in.gencost_STARTUP{i});
%     gencost(i,SHUTDOWN) = str2double(gencost_in.gencost_SHUTDOWN{i});
%     gencost(i,NCOST) = str2double(gencost_in.gencost_NCOST{i});
%     gencost(i,COST) = str2double(gencost_in.gencost_COST{i});
% end
%     

%% solver options

alg = pf_solver_in.ALG{1};
tol = str2double(pf_solver_in.TOL{1});
max_it = str2double(pf_solver_in.MAX_IT{1});
mpopt = mpoption('pf.alg',alg,'pf.tol',tol);
if strcmp(alg,'NR')
    mpopt = mpoption(mpopt,'pf.nr.max_it',max_it);
elseif strcmp(alg,'FDXB')
    mpopt = mpoption(mpopt,'pf.fd.max_it',max_it);
elseif strcmp(alg,'FDBX')
    mpopt = mpoption(mpopt,'pf.fd.max_it',max_it);
elseif strcmp(summary.opt.alg,'GS')
    mpopt = mpoption(mpopt,'pf.gs.max_it',max_it);
end

mkdir('matpower_storage');

save('matpower_storage/opt_from_aql','mpopt');

%% Matpower case

mpc.version = '2';
baseMVA = 100;
mpc.baseMVA = baseMVA;
mpc.bus     = bus;
mpc.branch  = branch;
mpc.gen     = gen;
%mpc.gencost = gencost;
%mpc.bus_name = bus_name;
mpc = loadcase(mpc);    %% convert to internal (e.g. v. '2') case format

savecase('matpower_storage/mpc_from_aql',mpc);
