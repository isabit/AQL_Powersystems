function summary_2_aql(summary, path)
% converts summary struct to te files which can be imported in aql
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

fid = fopen(strcat(path,'otherdata.txt'),'w');

if strcmp(summary.opt.alg,'NR')
    method = 'Newton-Raphson';
    max_it = summary.opt.nr.max_it;
elseif strcmp(summary.opt.alg,'FDXB')
    method = 'Fast-Decoupled XB';
    max_it = summary.opt.fd.max_it;
elseif strcmp(summary.opt.alg,'FDBX')
    method = 'Fast-Decoupled BX';
    max_it = summary.opt.fd.max_it;
elseif strcmp(summary.opt.alg,'GS')
    method = 'Gauss-Seidel';
    max_it = summary.opt.gs.max_it;
end

if summary.opt.enforce_q_lims == 1
    enf = 'Enforced - simultaneous';
elseif summary.opt.enforce_q_lims == 2
    enf = 'Enforced - one at a time';
else
    enf = 'Not enforced';
end

fprintf(fid, 'Method: %s\n', method);
fprintf(fid, 'Tolerance: %e\n', summary.opt.tol);

fprintf(fid, 'Gen reactive power limits: %s\n', enf);
fprintf(fid, 'Time elapsed (s): %f\n', summary.et);
fprintf(fid, 'Iterations: %d\n', summary.iterations);
fprintf(fid, 'Max Iterations: %d\n', max_it);
fclose(fid);
end