function graph=func_graph_intervals_overlap2(file_path1,file_path2,header_path,min_frame,max_frame,spot_number)
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


%example:
%out=func_graph_2intervals('hoskins100409_cy5tmp_600uW_intervals.dat','hoskins100409_cy5tmp_600uW_intervals.dat',1223,2403,49);
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

%create the two graphs
g1=func_graph_intervals2(file_path1,header_path,min_frame,max_frame,spot_number,1);
g2=func_graph_intervals2(file_path2,header_path,min_frame,max_frame,spot_number,1);

%set unique values for graph 2
g2(find(g2==-4))=100;
g2(find(g2==4))=200;
g2(find(g2==16))=300;

%add the graphs together (they should be the same size)
graph=g1+g2;

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
header=load(header_path,'-mat');
time2frames=header.vid.ttb(min_frame:max_frame);

%now to graph the result
func_graph_intervals_time_graph(graph,time2frames,-1,0,1,2,3);




