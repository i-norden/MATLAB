function pc=HistogramIntervalData(IntervalData,haxes,highlow,BinNumber)
%
%     HistogramIntervalData(IntervalData,haxes,highlow,BinNumber)
%
%% Will use the IntervalData array calculated by detecting the high/low
% transitions in the InputTrace and plot a histogram of that data on
% the specified axes
%
% handles == handles from the plotargout gui
% haxes  == handle to the axes for the display, typically handles.axes3
% highlow == 1x N vector  values =1,0,-2,-3 2,3 to indicate values in 
%             IntervalData(:,1) to match rows whose intervals will be
%             included in the ploted histogram 
%             The -+2,-+3 indicate 0, 1 on the beginning(-) and end(+) of
%             the trace
% BinNumber == number of bins to use in histograming data
log=[];
            % Look for a match to any value in highlow(:)
for indx=1:length(highlow)
    log=[log IntervalData(:,1)==highlow(indx)];
end
            % log is now rows(IntervalData) x length(highlow)
            % The 'any' function works down columns, so we transpose the log
            % matrix before using 'any' (and transpose it back to a column
            % after we're done
[rose col]=size(log);

if col==1
    log1=logical(log);
else
    log1=any(logical(log'))';
end

           
%log=IntervalData(:,1)==highlow;  
        % see top of plotarg.m for handles.IntervalDataStructure
        % IntervalData=['(low or high =0 or 1) (frame start) (frame end) (delta frames) (delta time)']
             % logical array, locating high=1 or low=0 states
axes(haxes)
hold off

   % histogram only those states specified by highlow parameter
hist(IntervalData(log1,5),BinNumber)
pc=1;
