function plot_all_rawint(file_path,col_num,min_frames,max_frames,y_scale,aoi_num)
%UNTITLED Summary of this function goes here
%   This function plots all of the traces from an integrated AOI set
%   into one figure using the subplot function.  

%   Required inputs are:
        
        % file_path = location of integrated file
        % col_num = number of columns (this determines width of subplots)
        % min_frames = start of frames for x-axis of traces
        % max_frames = end of frames for x-axis of traces
        % y_scale = height of y-axis relative to minimum y-axis value (this
        %           sets each plot to the same scale)
        % aoi_num = number of aois specified by user (see examples below) 

%   An example:
%   plot_all_rawint('C:\matlab\data\4-5-1_wt_INT_022210.dat',12,1,3000,3000,150);
%      with 12 columns, frames 1 to 3000
%      with a y-axis scale of y_min + 3000
%      plots out as if there 150 aois to compare to another data set that
%      has 150 aois (this keeps the plot sizes the same)
%
%   Alternatively:
%   plot_all_rawint('C:\matlab\data\4-5-1_wt_INT_022210.dat',12,1,3000,3000,0);
%      with 12 columns, frames 1 to 3000
%      with a y-axis scale of y_min + 3000
%      plots out using the number of aois in the set 
        
    loaded=load(file_path,'-mat');
    
    aoi_num_max=max(loaded.aoifits.data(:,1)); % determine number of aois     
    
    if aoi_num<aoi_num_max || aoi_num==0
       
        aoi_num=aoi_num_max;
    end
    
    row_num=ceil(aoi_num/col_num); % determine number of rows
    
    figure;

    for aoi_count=1:aoi_num_max % loop for each AOI
    
        aoi_num2=loaded.aoifits.data(:,1)==aoi_count;
        
        frames=loaded.aoifits.data(aoi_num2,2);
        
        int_aoi=loaded.aoifits.data(aoi_num2,8);
    
        subplot(row_num,col_num,aoi_count);  % specifies which subplot
      
        plot(frames(min_frames:max_frames),int_aoi(min_frames:max_frames));
        
        y_min=min(int_aoi(min_frames:max_frames));
        y_max=y_min+y_scale;
        
        set(gca,'xtick',[],'ytick',[]); % important to get rid of tickmarks
        axis ([min_frames max_frames y_min y_max]);
        
        %axis tight % scales axes to fit trace
    end
  
end

