function pc=EditBinaryTrace(UpDown,handles)
%
% function EditBinaryTrace(UpDown,handles)
%
% Used to edit the binary trace and AllTracesCellArray for the current trace 
% being displayed for the current Intervals structure.
%
% ATCA ==AllTracesCellArray storing all the input traces, binary traces and
%       event intervals.  Created in the plotargout gui
% FrameNumber == Frame number that will be edited in the binary trace.  The
%              function will either set the value of the frame specified by
%              this FrameNumber to a 1 (UpDown = 1) or a 0 (UpDown=0) 
% UpDown == +1 to set the edited FrameNumber in the binary trace to a 1 (landing event)
%           -1 to set the FrameNumber in the binary trace to a 0 (no landing event)
% handles == handles structure from the calling gui
FrameNumber=str2num(get(handles.EditFrame,'String'));       % Frame number being edited 
ATCA=handles.IntervalDataStructure.AllTracesCellArray;
TraceNum=handles.AllTracesDisplayNumber;                    % Fetch the row index of the ATCA being edited
set(handles.MiddleAOIPlot,'String',num2str(TraceNum))       % Display the proper row index
Bin2013=[ATCA{TraceNum,13}(:,2)  ATCA{TraceNum,13}(:,1)];   % Binary trace with low = -2,0,-3 and high = -3,1,3
                                        % [framenumber  low/hi]
Bin01=BinaryOnly01(Bin2013);                                % Creates trace with just low=0 and high=1;

cip=get(handles.CumulativeIntervalPopup,'Value');           % Get value of the popup menu
if cip==3
                % Here if popup mene says to edit a single point

    logfrm=(Bin01(:,1)==FrameNumber);                       % Index of the FrameNumber we wish to alter
    if UpDown>0
        Bin01(logfrm,2)=1;                                     % Edits the binary trace, specified frame number is now a 1 (high)
    elseif UpDown<=0
        Bin01(logfrm,2)=0;                                     % Edits the binary trace, specified frame number is now a 0 (low)
    end                                                         
    set(handles.EditFrame,'String',num2str(FrameNumber+UpDown));      % Increment/Decrement frame number to be next edited
            % alter the ATCA , CIA and replot
elseif cip==4
                % Here if popup menu says to edit an interval
    axes(handles.axes2)
    [xt yt]=ginput(2);                         % User clicks on middle plot trace to define an interval
    xt=sort(xt);                                % xt now in increasing order
                                          % Pick out indices between frame limits 
    logint=(Bin01(:,1)>=xt(1))&(Bin01(:,1)<=xt(2));
    if UpDown>0    
                    % Here to turn interval into 1 (high, => event)
        Bin01(logint,2)=1;
    elseif UpDown<=0
                    % Here to turn interval into 0 (low, => no event)
        Bin01(logint,2)=0;
    end
end

            
MultipleFrameIntervals=ATCA{TraceNum,8};                % Frame ranges over which to detect intervals
                                       % Next, use edited binary trace to recalculate intervals  
dat=Find_Landings_MultipleFrameIntervals(Bin01,MultipleFrameIntervals,0.5,0.5,1,1);
   

tb=ATCA{TraceNum,9};                         %Time base array
        % BinaryInputTrace= [(low/high=0 or 1) InputTrace(:,1) InputTrace(:,2)]
        % where InputTrace here includes only sections searched for events
        %Also mark the first interval 0s or 1s with -2 or -3 respectively,
        %and the ending interval 0s or 1s with +2 or +3 respectivley
ATCA{TraceNum,13}=dat.BinaryInputTrace;
     
   
  
            % add the deltaTime value to the 5th column to the IntervalData
            % array, and subtract mean from event height
%IntervalArrayDescription=['(low or high =0 or 1) (frame start) (frame end) (delta frames) (delta time (sec)) (interval ave intensity) AOI#'];
  
                        
                        % Next get the average intensity of the detrended
                        % trace for each event (for column 6 of IntervalData)
                        % And AOI number (for column 7)
        
        [IDrose IDcol]=size(dat.IntervalData);      % ID == IntervalData
        %InputTrace=PTCA{1,12};          % Detrended trace used here (same definition from above)
RawInputTrace=ATCA{TraceNum,11};          % Uncorrected input trace used here 
aveint=[];       
for IDindx=1:IDrose                 % Cycly through all the intervals
    startframe=dat.IntervalData(IDindx,2);
    rawstartframe=find(RawInputTrace(:,1)==startframe);
    endframe=dat.IntervalData(IDindx,3);
    rawendframe=find(RawInputTrace(:,1)==endframe);
                                % Use ave of raw input trace w/ mean
                                % subtracted off
    aveint=[aveint;sum(RawInputTrace(rawstartframe:rawendframe,2))/(rawendframe-rawstartframe+1)-ATCA{TraceNum,16}];   % Subtract mean off the uncorrected trace to get pulse height
end
                                    % Replace interval array (corrected) with proper
                                    % average intensity
ATCA{TraceNum,10}=[dat.IntervalData(:,1:4) tb(dat.IntervalData(:,3)+1)-tb(dat.IntervalData(:,2)) aveint  ATCA{TraceNum,2}*ones(IDrose,1)];   
                    % Output the updated AllTracesCellArray
pc=ATCA;