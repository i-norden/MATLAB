function old_to_current_SMART(filename)



% conferts old .traces to new .traces
% converts old .proc to new .proc



% convertst .traces prior to SMART publication to the final .traces format
if ~isempty(strfind(filename,'.traces'))
        
load(filename,'-mat')    
temp_struct = struct;
  
for i=1:size(group_data,1)
   
%Fill in first cell
temp_struct.name = group_data{i,1}.name;
temp_struct.gp_num = group_data{i,1}.gp_num;
temp_struct.movie_num = group_data{i,1}.movie_num;
temp_struct.movie_ser = group_data{i,1}.movie_ser;
temp_struct.trace_num = group_data{i,1}.trace_num;
temp_struct.spots_in_movie = group_data{i,1}.trace_num;
temp_struct.position_x = group_data{i,1}.accept_positions_x;
temp_struct.position_y = group_data{i,1}.accept_positions_y;
temp_struct.positions = group_data{i,1}.positions;
temp_struct.fps = NaN;
temp_struct.len = size(group_data{i,2},1);
temp_struct.nchannels = size(group_data{i,2},2);
group_data{i,1}=temp_struct;

end

filename = ['new_' filename];
save(filename, 'group_data')
     
elseif ~isempty(strfind(filename,'.proc'))
    
    
    load(filename,'-mat')
    old_proc_data = proc_data;
    for i=1:size(proc_data,1)
    
    old_proc_data{i,1} = [old_proc_data{i,5}.movie_num old_proc_data{i,5}.movie_ser old_proc_data{i,5}.trace_num 1];
    
    old_proc_data{i,4} = {};
   
    temp_struct = struct;
    %Fill in first cell
    temp_struct.name = old_proc_data{i,5}.name;
    temp_struct.gp_num = old_proc_data{i,5}.gp_num;
    temp_struct.movie_num = old_proc_data{i,5}.movie_num;
    temp_struct.movie_ser = old_proc_data{i,5}.movie_ser;
    temp_struct.trace_num = old_proc_data{i,5}.trace_num;
    temp_struct.spots_in_movie = old_proc_data{i,5}.trace_num;
    temp_struct.position_x = old_proc_data{i,5}.accept_positions_x;
    temp_struct.position_y = old_proc_data{i,5}.accept_positions_y;
    temp_struct.positions = old_proc_data{i,5}.positions;
    temp_struct.fps = old_proc_data{i,5}.fps;
    temp_struct.len = size(old_proc_data{i,2},1);
    temp_struct.nchannels = size(old_proc_data{i,2},2);
    temp_struct.params = old_proc_data{i,5}.params;
    old_proc_data{i,5}=temp_struct;
    
    
    temp_struct = struct;

    temp_struct.thresholded = [3     1   NaN    -3; 0     1   NaN     3];
    temp_struct.k2to1_single = [];
    temp_struct.k2to1_xval = NaN;
    temp_struct.k2to1_single_yval = [];
    temp_struct.k2to1_single_residuals = NaN;
    temp_struct.k2to1_dobule = [NaN NaN NaN];
    temp_struct.k2to1_dobule_yval = [];
    temp_struct.k2to1_dobule_residuals = NaN;
    temp_struct.k1to2_single = [];
    temp_struct.k1to2_xval = NaN;
    temp_struct.k1to2_single_yval = [];
    temp_struct.k1to2_single_residuals = NaN;
    temp_struct.k1to2_dobule = [NaN NaN NaN];
    temp_struct.k1to2_dobule_yval = [];
    temp_struct.k1to2_dobule_residuals = NaN;
    temp_struct.snr = NaN;
    temp_struct.mean_total_i = NaN;
    temp_struct.dltg = NaN;
    old_proc_data{i,6} = temp_struct;
    


    end
    
    filename = ['new_' filename];
    
    proc_data = old_proc_data;
    save(filename, 'proc_data')
    
    
else
    
end