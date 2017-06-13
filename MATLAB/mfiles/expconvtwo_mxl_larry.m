function pc=expconvtwo_mxl_larry(inarg,intervals,tm,tx)
%
% function expfalltwo_mxl(inarg,intervals,tm,tx)
%
% Will use a MAXIMUM LIKELIHOOD algorithm for fitting a distribution
% function.  In this instance we will fit a biexponential with 
% three parameters a, tau1 and tau2  We must also input the minimum
% resolution time for the distribution, tm
%  (see B18p36)
%(  1/ ( a*(exp(-tm/tau1)-exp(-tx/tau2)) + (1-a)*(exp(-tm/tau2)-exp(-tx/tau2)) )  )*...
%          ( a/tau1 *exp(-intervals/tau1)+(1-a)/tau2 *exp(-intervals/tau2) );
%        
% inarg = [ ap tau1 tau2],  fit parameters in the distribution, defined in
%                the above equation for the distribution
%               note that a = 1/(1+ap^2)
% intervals == vector list of intervals measured (e.g. residence times) that
%            should be part of the distribution 
% tm == minimum interval length that can be resolved in the experiment
% tx == maximum interval length that can be resolved in the experiment
%
% call via fminsearch('expfalltwo_mxl',inargzero,[],intervals,tm,tx)
%N=length(intervals);                    % Number of events measured in the experiment
                                % Calculate the probability of each
                                % measured interval being part of the
                                % hypothesized distribution
k1=abs(inarg(1));
k2=abs(inarg(2));
a=exp(-intervals*k1);
b=exp(-intervals*k2);
c=exp(-tm*k1);
d=exp(-tx*k1);
e=exp(-tm*k2);
f=exp(-tx*k2);
probability_vector=((k1*k2)*(a-b))/((k2*(c-d))-(k1*(e-f)));
                     
                  %               86.4617*exp(-intervals/1.3642) + 14.1050*exp(-intervals/5.9616);
               % Corrects for (reanalysis) nonspecific binding b18p54 top of page
              % 82.94*exp(-intervals/1.45) + 12.22*exp(-intervals/6.13);  
              % Corrects for nonspecific binding b18p42 top of page
           

prodprob=sum(log(probability_vector));           % Take product of all probabilities;
pc=-prodprob;                         % The fminsearch will then minimize the
                                      % -prodprob (i.e. maximize prodprob)
                                      % so we will maximize the likelihood
                                      % that the intervals vector
                                      % represents the said distribution
                                      % (The sum of the log of the vector entries
                                      % is the same as the log of the
                                      % product of the vector entries.  We
                                      % use the sum( log() ) because taking
                                      % the product of the entries yields a
                                      % number too small for the computer
                                      % to handle.