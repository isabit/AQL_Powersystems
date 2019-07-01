function summary_2_aql(summary, path)
% converts summary struct to files which can be imported in aql
% This is slightly different from matpower_2_aql

bus_labels = {'id', 'BUS_I','BUS_TYPE','PD','QD','GS','BS','BUS_AREA',...
    'VM','VA','BASE_KV','ZONE','VMAX','VMIN','VM_INIT','VA_INIT'};
    
gen_labels = {'id', 'GEN_BUS','PG','QG','QMAX','QMIN','VG','MBASE',...
    'GEN_STATUS','PMAX','PMIN','PC1','PC2','QC1MIN','QC1MAX','QC2MIN',...
    'QC2MAX','RAMP_AGC','RAMP_10','RAMP_30','RAMP_Q','APF','PG_INIT',...
    'QG_INIT'};

branch_labels = {'id','F_BUS','T_BUS','BR_R','BR_X','BR_B','RATE_A',...
    'RATE_B','RATE_C','TAP','SHIFT','BR_STATUS','ANGMIN','ANGMAX','PF',...
    'QF','PT','QT'}; 

pf_solver_labels = {'id','ALG','TOL','MAX_IT','ET','ITERATIONS'};

%% buses

fid = fopen(strcat(path,'/bus.csv'),'w');
fprintf(fid, '%s,',  bus_labels{1:end-1} );
fprintf(fid, '%s\n', bus_labels{end} );
fclose(fid);

dlmwrite(strcat(path,'/bus.csv'),[(1:size(summary.bus,1)).', summary.bus],'-append');

%% generators

fid = fopen(strcat(path,'/gen.csv'),'w');
fprintf(fid, '%s,', gen_labels{1:end-1} );
fprintf(fid, '%s\n', gen_labels{end} );
fclose(fid);

dlmwrite(strcat(path,'/gen.csv'),[ (1:size(summary.gen,1)).', summary.gen] ,'-append');

%% branches

fid = fopen(strcat(path,'/branch.csv'),'w');
fprintf(fid, '%s,', branch_labels{1:end-1} );
fprintf(fid, '%s\n', branch_labels{end} );
fclose(fid);

dlmwrite(strcat(path,'/branch.csv'),[ (1:size(summary.branch,1)).', summary.branch],'-append');

%% options & other data

fid = fopen(strcat(path,'/pf_solver.csv'),'w');

if strcmp(summary.opt.alg,'NR')
    max_it = summary.opt.nr.max_it;
elseif strcmp(summary.opt.alg,'FDXB')
    max_it = summary.opt.fd.max_it;
elseif strcmp(summary.opt.alg,'FDBX')
    max_it = summary.opt.fd.max_it;
elseif strcmp(summary.opt.alg,'GS')
    max_it = summary.opt.gs.max_it;
end

fprintf(fid, '%s,',  pf_solver_labels{1:end-1} );
fprintf(fid, '%s\n', pf_solver_labels{end} );
fprintf(fid, '1,');
fprintf(fid, '%s,', summary.opt.alg);
fprintf(fid, '%e,', summary.opt.tol);
fprintf(fid, '%d,', max_it);
fprintf(fid, '%e,', summary.et);
fprintf(fid, '%d', summary.iterations);
fclose(fid);
end