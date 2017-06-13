function subfunc_progress_bar(handles,frames_done,tracks_done,frames_total,tracks_total)
figure(handles.progress_bar_handle);
set(handles.progress_bar_handle,'Position',[700 400 560 100]);
cla;
percent=100/(frames_total*tracks_total);
completed_percent=(frames_done*tracks_done)*percent;
rectangle('Position',[0,0,completed_percent,1],'EdgeColor','r','FaceColor','r');
axis([0 100 0 1]);
title('Percent Complete');