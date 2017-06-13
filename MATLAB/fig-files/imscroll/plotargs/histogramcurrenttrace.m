function pc=HistogramCurrentTrace(handles,haxes,highlow)
%
%     HistogramCurrentTrace(handles,handles.axes2)
%
%% Will use the IntervalData array calculated by detecting the high/low
% transitions in the InputTrace and plot a histogram of that data on
% the specified axes
%
% handles == handles from the plotargout gui
% haxes  == handle to the axes for the display, typically handles.axes3
% highlow == 1 or 0 to histogram the high or low intervals
IntervalData=handles.IntervalDataStructure.PresentTraceCellArray{1,10};
        % see top of plotarg.m for handles.IntervalDataStructure
        % IntervalData=['(low or high =0 or 1) (frame start) (frame end) (delta frames) (delta time)']
log=IntervalData(:,1)==highlow;               % logical array, locating high=1 or low=0 states
axes(haxes)
hold off
BinNumber=str2num(get(handles.BinNumber,'String'));
   % histogram only
hist(IntervalData(log,5),BinNumber)
end
