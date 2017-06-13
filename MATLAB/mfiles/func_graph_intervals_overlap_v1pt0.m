function graph=func_graph_intervals_overlap_v1pt0(file_path1,file_path2,header_path,min_frame,max_frame,spot_number,nodata,nopeaks,peak1,peak2,peaks,matchup_matrix)
%This function calls func_graph_intervals on the two files.
%It overlaps the graphs and saves the 9 possible states as different
%colors. The no data will always be replaced by data.
%File 1:    File2:  Result:(0=no peak, 1=peak -1=no data)
%-1         -1      -1
%-1         0       -1
%-1         1       -1
%0          -1      -1
%0          0       0      
%0          1       1
%1          -1      -1
%1          0       2
%1          1       3

%file_path= file path
%the size of the graph will be [spot_number x (max_frame-min_frame)]
%if the area requested is bigger than the file, you will get a border of
%unused space.
%header_path= the path to a header file to use for the frames to time change. 
                %this should be a matlab .mat file
                %NOTE: IF you want the x axis to be frames, set header_path
                %to be empty. If you want time, set a header path.
%spot_number= number of spots to graph
%nodata= rgb matrix (1x3) of values 0-1. This will represent no data.
%nopeaks= rgb matrix (1x3) of values 0-1. This will represent no peaks in either file.
%peak1= rgb matrix (1x3) of values 0-1. This will represent a peak in file 1 and no peak in file 2.
%peak2= rgb matrix (1x3) of values 0-1. This will represent a peak in file2 and no peak in file 1.
%peaks= rgb matrix (1x3) of values 0-1. This will represent a peak in file1 and also a peak in file 2.
%matchup_matrix= matrix used to match aoi numbers between the two interval
%files being used. set this to an n by 2 matrix for matches or to 
%'auto match' to use the aoi numbers that came with the two files.  Leave
%empty '[]' to match the intervals in order without reference to aoi
%number.



%example:
%fpath1='C:\Users\Alex\Documents\MATLAB\hoskins100409_cy5tmp_600uW_intervals.dat'
%fpath2='C:\Users\Alex\Documents\MATLAB\hoskins100409_cy5tmp_600uW_intervals.dat'
%hpath='header.mat'
%out=func_graph_intervals_overlap2(fpath1,fpath2,hpath,1223,2403,49,[0 0 0],[0 0 1],[0 1 0],[1 0 0],[1 1 0],[]);
%this gives the entire file.


%[name path]=uigetfile('D:\matlab\images','pick an interval file to load');
%if path==0 %do not proceed if uigetfile is cancelled
%    'cancelled loading file!'
%    return;
%end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%V.1.0  Alex O   3/1/10
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%now uses non consistent time information and graphs as rectangles instead
%of as a matrix for the graphing
%V.2  Alex O   3/2/10
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%now has inputs for the colors to be used
%V.2.1  Alex O   3/9/10
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%now has a matrix to match up the aois in the two files
%V.2.2  Alex O   3/26/10

%create the two graphs
g1=func_graph_intervals_nooverlap_v1pt0(file_path1,header_path,min_frame,max_frame,spot_number,nodata,nopeaks,peaks,1);
g2=func_graph_intervals_nooverlap_v1pt0(file_path2,header_path,min_frame,max_frame,spot_number,nodata,nopeaks,peaks,1);

%set unique values for graph 2
g2(find(g2==-4))=100;
g2(find(g2==4))=200;
g2(find(g2==16))=300;

%adding matrix order here, matching up in order of matrix [1 1; 2 2; ...]
if isempty(matchup_matrix) %empty matrix, use 1 to 1 matching
    matchup_matrix=[1:spot_number;1:spot_number]';
elseif max(matchup_matrix=='auto_match') %use auto matching
    %i'm assuming larry puts this in column 7 of
    %Intervals.CumulativeIntervalArray
    i1=load(file_path1,'-mat');
    i2=load(file_path2,'-mat');
    matchup_matrix=[i1.Intervals.CumulativeIntervalArray(1:spot_number,7) i2.Intervals.CumulativeIntervalArray(1:spot_number,7)]; 
elseif max(size(matchup_matrix) ~= [spot_number 2]) %improper size of matchup matrix
    'wrong size for matchup_matrix!'
    graph=[];
    return;
end %else the matrix is correct (hopefully)
g1_ordered=zeros(size(g1));
g2_ordered=zeros(size(g2));
%order the graph rows by the matrix orders
for i=1:spot_number
    g1_ordered(matchup_matrix(i,1),:)=g1(i,:);
    g2_ordered(matchup_matrix(i,2),:)=g2(i,:);
end 
g1=[];
g2=[];
%add the graphs together (they should be the same size)
graph=g1_ordered+g2_ordered;

%now to set the values of graph to the output values
graph(find(graph==96))=-1;
graph(find(graph==196))=-1;
graph(find(graph==296))=-1;
graph(find(graph==104))=-1;
graph(find(graph==204))=0;
graph(find(graph==304))=1;
graph(find(graph==116))=-1;
graph(find(graph==216))=2;
graph(find(graph==316))=3;

%get matrix of time info
time2frames=[];
if ~isempty(header_path)
    header=load(header_path,'-mat');
    time2frames=header.vid.ttb(min_frame:max_frame)/1000;
end

%now to graph the result
func_graph_intervals_time_graph(graph,time2frames,-1,0,1,2,3,nodata,nopeaks,peak1,peak2,peaks);




