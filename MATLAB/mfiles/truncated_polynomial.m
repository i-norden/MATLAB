function pc=truncated_polynomial(arg,data)
%
% function truncated_polynomial(arg,data)
%
% To be used in conjuction with the Matlab function 'fminsearch' in
% order to fit a falling exponential function of the from:
%
%   arg(1)*x + arg(2)*x.^2 + arg(3)* x.^3 + arg(4)*x.^4
%
% where 'rawdata' is a global variable containing the data to
% be fit 
% User must supply the input arguement as a starting parameter in
% 'fmins' as follows:
%   argout = fminsearch('truncated_polynomial',arg,[],data);
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
x=data(:,1);
pc= sum((data(:,2)-arg(1)*x - arg(2)*x.^2 - arg(3)* x.^3 - arg(4)*x.^4 -arg(5)*x.^5 - arg(6)*x.^6 - arg(7)*x.^7 - arg(8)*x.^8).^2);
%pc= sum((data(:,2)-(arg(1)*exp(-(data(:,1) )/arg(2) ) +arg(3) ) ).^2);

%pc= sum((rawdata(:,2)-(arg(1)*exp(-(rawdata(:,1) )/arg(2) )   +arg(3)) ).^2);
                    % one parameter
%pc= sum((rawdata(:,2)-( exp(-(rawdata(:,1) )/arg(1) ) ) ).^2);