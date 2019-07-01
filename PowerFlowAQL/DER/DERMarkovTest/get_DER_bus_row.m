function row = get_DER_bus_row(folderpath, busid)
% Returns row of "bus" array in a Matpower case corresponding to aggregate 
% bus of DERs in given folder (treats as PQ bus)
% BUS_I is set to busid from input
% Folder contains CSV files with necessary information

% Define constants for accessing column names
[PQ, ~, ~, ~, BUS_I, BUS_TYPE, PD, QD, GS, BS, BUS_AREA, VM, VA, ...
    BASE_KV, ZONE, VMAX, VMIN, ~, ~, ~, ~] = idx_bus;

% Import all files for the given bus
DERtable = readtable(strcat(folderpath, '/DER.csv'));
typetable = readtable(strcat(folderpath, '/DERtype.csv'));
statetable = readtable(strcat(folderpath, '/state.csv'));
transtable = readtable(strcat(folderpath, '/transition.csv'));

% Iterate over all DER types, calculating steady state P and Q
steadyP = containers.Map;
steadyQ = containers.Map;
for i = 1:height(typetable)
    typeid = typetable.id{i};
    [steadyP(typeid), steadyQ(typeid)] = ...
        get_steady_PQ(typeid, statetable, transtable);
end

% Add together expectation P, Q for each DER in the system
totalP = 0;
totalQ = 0;
for i = 1:height(DERtable)
    DERtype = DERtable.of_type{i};
    totalP = totalP + steadyP(DERtype);
    totalQ = totalQ + steadyQ(DERtype);
end

% Create output
row = zeros(1,13);

row(BUS_I) = busid;
row(BUS_TYPE) = PQ;

row(PD) = totalP;
row(QD) = totalQ;

row(GS) = 0;
row(BS) = 0;
row(BUS_AREA) = 1; % same as in 9-bus

row(VM) = 1;
row(VA) = 0;
row(BASE_KV) = 345; % same as in 9-bus
row(ZONE) = 1; % ditto
row(VMAX) = 2.0;
row(VMIN) = 0.5;

end