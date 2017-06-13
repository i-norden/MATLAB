function pc=Remove_Event(IntervalArray,BinaryInputTrace,Frame)
%
%   function Remove_Event(IntervalArray,BinaryInputTrace,Frame)
%
% Will remove one high event from the BinaryInputTrace and IntervalArray 
% as specified by the 'Frame' input.  Will be called from the plotargouts.m
% routine.
%
% IntervalArray == ['(low or high =0 or 1) (frame start) (frame end) (delta frames) (delta time (sec))']
%             Used in the plotargouts routine to record high and low events
%             in a record of integrated intensity.  This is contained in
%             handles.IntervalDataStructure.PresentTraceCellArray{1,10}
%
% BinaryInputTrace ===['(low or high =0 or 1) InputTrace(:,1) InputTrace(:,2)'];
%             Used in the plotargouts routine to mark high and low events
%             in a record of integrated intensity.  This is contained in
%             handles.IntervalDataStructure.PresentTraceCellArray{1,13}
%
% Frame == the frame number mouse clicked by the user as being nearest to the 
%             high event the user wants removed from the lists.  Will be
%             used to search through (frame start) and (frame end) in the
%             IntervalArray to identify the undesired interval

[IArose IAcol]=size(IntervalArray);
                % Initialize our search variables
MinDiff=abs(Frame-IntervalArray(1,2));          % IntervalArray(1,2)=start frame for event
IAindex=1;
for indx=1:IArose
                % Check each high interval frame boundary in the list for 
                % proximity to the Frame (the > 2 in next statement allows
                % us to eliminate a high event on the beginning/end of
                % a trace)
    if (IntervalArray(indx,1)==1) | (abs(IntervalArray(indx,1)) > 2)
                % Here if the row lists a high event
        CurrentDiff=abs(Frame-IntervalArray(indx,2));   % lower boundary of high event
        if CurrentDiff<MinDiff
                                % Here if new closest frame is found
            IAindex=indx;       % Replace the running row index
            MinDiff=CurrentDiff; % Replace the running minimum frame difference
        end
        CurrentDiff=abs(Frame-IntervalArray(indx,3));   % upper boundary of high event
        if CurrentDiff<MinDiff
                                % Here if new closest frame is found
            IAindex=indx;       % Replace the running row index
            MinDiff=CurrentDiff; % Replace the running minimum frame difference
        end
    end
end
        % Now, the IAindex indicates the row of IntervalArray that contains
        % the high event we wish to eliminate
highframe=IntervalArray(IAindex,3);
lowframe=IntervalArray(IAindex,2);
        % Cycle through the BinaryInputTrace and zero the rows (1 -> 0 in the 
        % first column) that specify the high event we eliminate
[BITrose BITcol]=size(BinaryInputTrace);
for BITindx=1:BITrose
    if (BinaryInputTrace(BITindx,2)<=highframe) & (BinaryInputTrace(BITindx,2)>=lowframe)
                % Zero the high/low column when the frame is between our
                % limits
        BinaryInputTrace(BITindx,1)=0;
    end
end
    % Finally, remove the high event from our list in IntervalArray
IntervalArray(IAindex,:)=[];
    % And output the altered variables
pc.IntervalArray=IntervalArray;
pc.BinaryInputTrace=BinaryInputTrace;