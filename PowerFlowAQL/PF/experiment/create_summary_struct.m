function summary = create_summary_struct(prob, soln, mpopt)
% Creates a struct summarizing results of experiment for given problem and
% solution Matpower cases. Works by appending initial conditions to ends of
% arrays in soln and by appending data describing solver, etc.

% Constants
num_buses = length(soln.bus(:,1));
BUS_NUM_COLS = length(soln.bus(1,:));
BUS_VM_COL = 8;
BUS_VA_COL = 9;

num_gens = length(soln.gen(:,1));
GEN_NUM_COLS = length(soln.gen(1,:));
GEN_PG_COL = 2;
GEN_QG_COL = 3;

% Initialize summary object
summary = struct('bus',[],'gen',[],'branch',[],...
    'opt',struct,'et',0,'iterations',0);

% Add initial VM, VA to end of soln.bus
newbus = zeros(num_buses, BUS_NUM_COLS + 2);
newbus(1:num_buses, 1:BUS_NUM_COLS) = soln.bus;
newbus(:, BUS_NUM_COLS + 1) = prob.bus(:, BUS_VM_COL);
newbus(:, BUS_NUM_COLS + 2) = prob.bus(:, BUS_VA_COL);
summary.bus = newbus;

% Add initial PG, QG to end of soln.gen
newgen = zeros(num_gens, GEN_NUM_COLS + 2);
newgen(:, 1:GEN_NUM_COLS) = soln.gen;
newgen(:, GEN_NUM_COLS + 1) = prob.gen(:, GEN_PG_COL);
newgen(:, GEN_NUM_COLS + 2) = prob.gen(:, GEN_QG_COL);
summary.gen = newgen;

summary.branch = soln.branch;

summary.opt = mpopt.pf; % Only taking PF options

summary.et = soln.et;

summary.iterations = soln.iterations;
end

