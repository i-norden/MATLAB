function graph=func_graph_intervals(file_path,min_frame,max_frame,spot_number)
%file_path= file path
%the size of the grapgh will be [spot_number x (max_frame-min_frame)]
%if the area requested is bigger than the file, you will get a border of
%unused space.


%example:
%out=func_graph_intervals('C:\Users\Alex\Documents\MATLAB\hoskins100409_cy5tmp_600uW_intervals.dat',1223,2403,49);
%this gives the entire file.


%[name path]=uigetfile('D:\matlab\images','pick an interval file to load');
%if path==0 %do not proceed if uigetfile is cancelled
%    'cancelled loading file!'
%    return;
%end
loaded=load(file_path,'-mat');
intervals_1=loaded.Intervals.CumulativeIntervalArray;
graph=zeros(spot_number,max_frame-min_frame)-4;
spot=[];
spot_counter=0;
frame_counter=0;
for i=1:size(intervals_1,1)
   if intervals_1(i,1)== -2 || intervals_1(i,1)== -3 %start of new spot
       spot_counter=spot_counter+1;
       frame_counter=0;
       if spot_counter>spot_number %graphed the number of spots wanted
          break; 
       end
   end
   %now will set rgb values of pixels at (x,y)=(spot_counter,frame_counter)
   %set rgb values depending on spot 
   for j=1:intervals_1(i,3)-intervals_1(i,2)+1 %for each frame of spot
       if j+intervals_1(i,2)>=min_frame %not less than min frame
           if j+intervals_1(i,2)<=max_frame %not greater than max frame
               frame_counter=frame_counter+1;
               graph(spot_counter,frame_counter)=intervals_1(i,1);
               %[spot_counter frame_counter intervals_1(i,1)]

           end
       end
   end
end
%graph(:,1:10)
%now to replace all -2, 0, +2 with fours, 
graph(find(graph==-2))=4;
graph(find(graph==-0))=4;
graph(find(graph==2))=4;
%now to replace all -3, +1, +3 with eights
graph(find(graph==-3))=16;
graph(find(graph==1))=16;
graph(find(graph==3))=16;
%i have to append the results to a matrix to make the image display
%properly
graph=[zeros(spot_number,min_frame-1) graph];
%now to graph the results
imagesc(graph);
axis([min_frame max_frame 1 spot_number]);
colormap(hsv(3));
