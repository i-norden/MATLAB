function pc=rise_fall(arg,data)
%
% function rise_fall(arg,data)
%
% To be used in conjuction with the Matlab function 'fminsearch' in
% order to fit a falling exponential function of the from:
%
%   amp*exp(-t/tau2).*( 1 - exp(-t/tau1) )
%
% where 'rawdata' is a global variable containing the data to
% be fit 
% User must supply the input arguement as a starting parameter in
% 'fmins' as follows:
%   argout = fminsearch('rise_fall',arg,[],data);
%
% data == [time amplitude]
%
% arg == [arg(1) arg(2) arg(3) arg(4)]
% arg(1) == amplitude of the variable exponential
% arg(2) == 'time' offset
% arg(3) == time constant of the exponential
% arg(4) == amplitude offset for the exponential%

%global rawdata


%pc= sum((rawdata(:,2)-(arg(1)*exp(-(rawdata(:,1)-arg(2) )/arg(3) )   +arg(4)) ).^2);

                    % simpler form:
amp=arg(1);
tau1=arg(2);
tau2=arg(3);
t=data(:,1);
pc= sum((data(:,2)-amp*exp(-t/tau2).*( 1-exp(-t/tau1) ) ).^2);
%pc= sum((data(:,2)-(arg(1)*exp(-(data(:,1) )/arg(2) ) +arg(3) ) ).^2);

%pc= sum((rawdata(:,2)-(arg(1)*exp(-(rawdata(:,1) )/arg(2) )   +arg(3)) ).^2);
                    % one parameter
%pc= sum((rawdata(:,2)-( exp(-(rawdata(:,1) )/arg(1) ) ) ).^2);