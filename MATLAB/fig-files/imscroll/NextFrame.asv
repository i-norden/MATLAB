function pc=NextFrame(increment,handles)
%
% This function will be used to increment the frame number that is being
% displayed in imscroll.  In a typical run we jump between fields, and the
% frames pertinent for a particular field may be irregularly spaced.  To 
% increment the frame number we will note which field we wish to view, and
% then use the handles.fieldfrms cell array to specify the pertinent
% frames for each field.
%
% increment == +-number of frames to nominally increment the current frame
%         number (sign sensitive i.e positive or negative).  It is a
%         'nominal' increment because we still need to use a frame number
%         pertinent to the field we are viewing.  The actual frame we jump
%         to will therefore be closest to CurrentFrame+increment that is 
%         still a view of the particular field we are viewing
% handles== handles structure of the gui

[Y I]=min(abs(CurrentFrameset-CurrentFrame-increment));  % Find the frame number
                                        % in the current frame set that is
                                        % closest to CurrentFrame+increment
                                        % Note that increment may by + or -
pc=CurrentFrameset(I);                  % Output the new frame to display
