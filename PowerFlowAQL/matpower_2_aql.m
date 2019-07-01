function matpower_2_aql(mpc, path)
% converts matpower case-file or struct to csv files which can be imported in aql
% This is slightly different from the file Blake sent on 5/30
% Main difference is that this is a function. not a script

bus_labels = {'id', 'BUS_I','BUS_TYPE','PD','QD','GS','BS','BUS_AREA','VM','VA','BASE_KV','ZONE',...
		'VMAX','VMIN'};
    
gen_labels = {'id', 'GEN_BUS','PG','QG','QMAX','QMIN','VG','MBASE','GEN_STATUS','PMAX','PMIN',...
		'PC1','PC2','QC1MIN','QC1MAX','QC2MIN','QC2MAX','RAMP_AGC','RAMP_10','RAMP_30','RAMP_Q','APF'};

branch_labels = {'id','F_BUS','T_BUS','BR_R','BR_X','BR_B','RATE_A','RATE_B','RATE_C','TAP','SHIFT','BR_STATUS','ANGMIN','ANGMAX'}; 

%% buses

fid = fopen(strcat(path,'/bus.csv'),'w');
fprintf(fid, '%s,',  bus_labels{1:end-1} );
fprintf(fid, '%s\n', bus_labels{end} );
fclose(fid);

dlmwrite(strcat(path,'/bus.csv'),[(1:size(mpc.bus,1)).', mpc.bus],'-append');

%% generators

fid = fopen(strcat(path,'/gen.csv'),'w');
fprintf(fid, '%s,', gen_labels{1:end-1} );
fprintf(fid, '%s\n', gen_labels{end} );
fclose(fid);

dlmwrite(strcat(path,'/gen.csv'),[ (1:size(mpc.gen,1)).', mpc.gen] ,'-append');

%% branches

fid = fopen(strcat(path,'/branch.csv'),'w');
fprintf(fid, '%s,', branch_labels{1:end-1} );
fprintf(fid, '%s\n', branch_labels{end} );
fclose(fid);

dlmwrite(strcat(path,'/branch.csv'),[ (1:size(mpc.branch,1)).', mpc.branch],'-append');

end