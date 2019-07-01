function mpc = create_DER_mpc()
% Creates a Matpower case for use in solve_PF_DER

% Declare names for columns in MPC arrays
define_constants;

% Define slackbus
slackrow = zeros(1,13);
slackrow(BUS_I) = 1;
slackrow(BUS_TYPE) = REF;
slackrow(PD) = 0;
slackrow(QD) = 0;
slackrow(GS) = 0;
slackrow(BS) = 0;
slackrow(BUS_AREA) = 1;
slackrow(VM) = 1;
slackrow(VA) = 0;
slackrow(BASE_KV) = 345; % same as 9-bus
slackrow(ZONE) = 1;
slackrow(VMAX) = 1.5;
slackrow(VMIN) = 0.5;


% Get all buses
DERpath = 'C:/Users/jsn1/Documents/AQL/DER';
bus = zeros(4,13);
bus(1,:) = slackrow;
bus(2,:) = get_DER_bus_row(strcat(DERpath,'/busA'),2);
bus(3,:) = get_DER_bus_row(strcat(DERpath,'/busB'),3);
bus(4,:) = get_DER_bus_row(strcat(DERpath,'/busC'),4);

% Single generator for the slack bus
% Most values are based on those for 9-bus
gen = zeros(1,21);
gen(GEN_BUS) = 1;
gen(PG) = 0;
gen(QG) = 0;
gen(PMAX) = 300;
gen(PMIN) = -300;
gen(PMAX) = 300;
gen(PMIN) = -300;
gen(VG) = 1;
gen(MBASE) = 100;
gen(GEN_STATUS) = 1;
gen(PC1) = 0;
gen(PC2) = 0;
gen(QC1MIN) = 0;
gen(QC1MAX) = 0;
gen(QC2MIN) = 0;
gen(QC2MAX) = 0;
gen(RAMP_AGC) = 0;
gen(RAMP_10) = 0;
gen(RAMP_30) = 0;
gen(RAMP_Q) = 0;
gen(APF) = 0;

% Generic branch - fill all branches with this template and change from/to
% Most values are based on those for 9-bus
brtemplate = zeros(1,13);
brtemplate(BR_R) = 1;
brtemplate(BR_X) = 0;
brtemplate(BR_B) = 0;
brtemplate(RATE_A) = 250;
brtemplate(RATE_B) = 250;
brtemplate(RATE_C) = 250;
brtemplate(TAP) = 0;
brtemplate(SHIFT) = 0;
brtemplate(BR_STATUS) = 1;
brtemplate(ANGMIN) = -360;
brtemplate(ANGMAX) = 360;

% Create all branches
branch = zeros(3,13);
branch(1,:) = brtemplate;
branch(1,F_BUS) = 1;
branch(1,T_BUS) = 2;
branch(2,:) = brtemplate;
branch(2,F_BUS) = 1;
branch(2,T_BUS) = 3;
branch(3,:) = brtemplate;
branch(3,F_BUS) = 1;
branch(3,T_BUS) = 4;

baseMVA = 100;
version = '2';

mpc = struct('version',version,'baseMVA',baseMVA,'bus',bus,...
    'gen',gen,'branch',branch);

end