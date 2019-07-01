% Experiment / simulation testing MATPOWER solutions for IEEE case118 using
% different initializations (without changing the problem statement).

% Turn off warning messages
warning('off', 'MATLAB:MKDIR:DirectoryExists');

% Set up constants for referencing Matpower case columns
define_constants;

% Creates case, options from CSV
run('aql_2_matpower.m');

% Import case, options
prob = loadcase('matpower_storage/mpc_from_aql');
mpopt = load('matpower_storage/opt_from_aql','mpopt');
opt = mpoption(mpopt.mpopt, 'out.all', 0);

% Set up ranges for indices
num_buses = length(prob.bus(:, 1));
num_gens = length(prob.gen(:, 1));

prob2 = runpf(prob,opt);

% Offset for initialization
epsilon = [0.1, 0.01, 0.001, 0.0001, 0.00001, 0.000001, 0.0000001];

for n = 1:length(epsilon)
    % Change initialization of case118
    % Initialize PQ buses
    for i = 1:num_buses
        if prob2.bus(i, BUS_I) == 1
            prob2.bus(i, VM) = prob2.bus(i, VM) + epsilon(n);
            prob2.bus(i, VA) = prob2.bus(i, VA) + epsilon(n);
        end
    end
    
    % Initialize PV buses
    for j = 1:num_gens
        i = prob2.gen(j, GEN_BUS); % GEN_BUS
        if prob2.bus(i, BUS_TYPE) == 2
            prob2.gen(j, QG) = prob2.gen(j, QG) + epsilon(n);
            prob2.bus(i, VA) = prob2.bus(i, VA) + epsilon(n);
        end
    end
    
    % Initialize slack bus
    for j = 1:num_gens
        i = prob2.gen(j, GEN_BUS);
        if prob2.bus(i, BUS_TYPE) == 3
            prob2.gen(j, PG) = prob2.gen(j, PG) + epsilon(n);
            prob2.gen(j, QG) = prob2.gen(j, QG) + epsilon(n);
        end
    end
    
    % Solve power flow problem
    soln = runpf(prob2, opt);
    
    % Turn solution + initialization + options into a summary
    summary = create_summary_struct(prob2, soln, opt);
    
    % Export to CSV
    path = strcat('solution', int2str(n), '/');
    mkdir(path);
    summary_2_aql(summary, path);
end

% Turn warning messages back on
warning('on', 'MATLAB:MKDIR:DirectoryExists')