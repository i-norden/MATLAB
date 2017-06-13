function graph=func_graph_intensity(file_path,header_path,min_frame,max_frame,spot_number,type)
%This function lets you create a graph of intensities for various files.
%file_path= file path
%header_path= the path to a header file to use for the frames to time change. 
                %this should be a matlab .mat file
                %NOTE: IF you want the x axis to be frames, set header_path
                %to be empty. If you want time, set a header path.
%the size of the graph will be [spot_number x (max_frame-min_frame)]
%if the area requested is bigger than the file, you will get a border of
%unused space.
%header_path= the path to a header file to use for the frames to time change. 
                %this should be a matlab .mat file.
                
%spot number= the number of spots you want to graph
%type= a string containing an option for graphing.
%       the current acceptable values are:
%           'gaussian'= aoifits.data amplitude
%           'rawintensity'=aoifits.data with no background information
%           'minusbackground'= aoifits.data integratedaoi
%           'intensityfromintervals'= Intervals.Intervals.AllTracesCellArray(:,12)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%V.1.0  Alex O   3/9/10
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%now automatically subtracts the background from raw plots asusming the
%aoifits contains the field 'BackgroundData' containing the background
%info
%V.1.1  Alex O   3/9/10


load(file_path,'-mat');
graph=zeros(spot_number,max_frame-min_frame+1);
%have to use for loops to account for missing spots even though they're
%slow
switch lower(type)
    case 'gaussian'
        spots=unique(aoifits.data(:,1)); %number of unique spots
        for i=1:size(spots,1) %only by actual size of spots, request may be more so I do it this way
            peaks=aoifits.data(find(aoifits.data(:,1)==spots(i)),2:3);
            %rectangle('Position',[i-1,min_frame,max_frame-min_frame+1,1],'EdgeColor','k','FaceColor','k');
            %plot(i-1,peaks(:,1),'Color',[peaks(:,2)/scalediv 0 0]);
            for j=1:size(peaks,1)
                %plot(i-1,peaks(j,1),'Color',[peaks(j,2)/scalediv 0 0]);
                %rectangle('Position',[i-1,peaks(j,1),1,1],'EdgeColor',[peaks(j,2)/scalediv 0 0],'FaceColor',[peaks(j,2)/scalediv 0 0]);
                if peaks(j,1)>=min_frame && peaks(j,1)<=max_frame %if within range
                    graph(i,peaks(j,1)-min_frame+1)=peaks(j,2);
                end
            end
            if i>=spot_number %stop if the desired number of spots has been reached
                break;
            end
        end 
    case 'minusbackground'
        spots=unique(aoifits.data(:,1)); %number of unique spots
        sub_background=0;
        if ~isfield(aoifits,'BackgroundData') %if old version of aoifits
            'Cannot subtract background automatically, no background data'
        else
            sub_background=1; %use background subtraction 
        end
        for i=1:size(spots,1) %only by actual size of spots, request may be more so I do it this way
            found_peaks=find(aoifits.data(:,1)==spots(i));
            peaks=aoifits.data(found_peaks,[2 8]);
            if sub_background %if background subtraction is being used
                back_of_peaks=aoifits.BackgroundData(found_peaks,[2 8]);
                peaks(:,2)=peaks(:,2)-back_of_peaks(:,2); %subtract background from peaks
            end
            %rectangle('Position',[i-1,min_frame,max_frame-min_frame+1,1],'EdgeColor','k','FaceColor','k');
            %plot(i-1,peaks(:,1),'Color',[peaks(:,2)/scalediv 0 0]);
            for j=1:size(peaks,1)
                %plot(i-1,peaks(j,1),'Color',[peaks(j,2)/scalediv 0 0]);
                %rectangle('Position',[i-1,peaks(j,1),1,1],'EdgeColor',[peaks(j,2)/scalediv 0 0],'FaceColor',[peaks(j,2)/scalediv 0 0]);
                if peaks(j,1)>=min_frame && peaks(j,1)<=max_frame %if within range
                    graph(i,peaks(j,1)-min_frame+1)=peaks(j,2);
                end
            end
            if i>=spot_number %stop if the desired number of spots has been reached
                break;
            end
        end
    case 'intensityfromintervals'
        for i=1:size(Intervals.AllTracesCellArray(:,12)) %only by actual size of spots, request may be more so I do it this way
            peaks=Intervals.AllTracesCellArray{i,12};
            for j=1:size(peaks,1)
                if peaks(j,1)>=min_frame && peaks(j,1)<=max_frame %if within range
                    graph(i,peaks(j,1)-min_frame+1)=peaks(j,2);
                end
            end
            if i>=spot_number %stop if the desired number of spots has been reached
                break;
            end
        end
    
    
    otherwise %improper type
        'wrong type, check the function description'
        graph=[];
        return;
    
end
figure();
if ~isempty(header_path) %use time information
    header=load(header_path,'-mat'); %load header
    min_time=header.vid.ttb(min_frame)/1000;
    max_time=header.vid.ttb(max_frame)/1000;
    imagesc([min_time max_time],[1 spot_number],graph)
    xlabel('Time (Seconds)')
else %use frame number
    imagesc([min_frame max_frame],[1 spot_number],graph)
    xlabel('Frames');
end
ylabel('Spots')
colorbar


