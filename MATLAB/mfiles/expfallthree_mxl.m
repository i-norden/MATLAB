function pc=expfallthree_mxl(inarg,intervals,tm,tx)
%
% function expfallthree_mxl(inarg,intervals,tm,tx)
%
% Will use a MAXIMUM LIKELIHOOD algorithm for fitting a distribution
% function.  In this instance we will fit a biexponential with 
% five parameters a1, a2, tau1, tau2 and tau3.  We must also input the minimum
% resolution time for the distribution, tm, and the maximum, tx.
%  (see B18p36)
%(  1/ ( a1*(exp(-tm/tau1)-exp(-tx/tau2))+a2*(exp(-tm/tau2)-exp(-tx/tau2))+(1-a1-a2)*(exp(-tm/tau3)-exp(-tx/tau3)) )  )*...
%      ( a1/tau1*exp(-intervals/tau1)+a2/tau2*exp(-intervals/tau2)+(1-a1-a2)/tau3*exp(-intervals/tau3) );
%        
% inarg = [ ap1 ap2 tau1 tau2 tau3 ],  fit parameters in the distribution, defined in
%                the above equation for the distribution
%               note that a1 = 1/(1+ap1^2) ; a2 = (1-a1)/(1+ap2^2)
% intervals == vector list of intervals measured (e.g. residence times) that
%            should be part of the distribution 
% tm == minimum interval length that can be resolved in the experiment
% tx == maximum interval length that can be resolved in the experiment
%
% call via fminsearch('expfallthree_mxl',inargzero,[],intervals,tm,tx)
%N=length(intervals);                    % Number of events measured in the experiment
                                % Calculate the probability of each
                                % measured interval being part of the
                                % hypothesized distribution
a1=1/(1+inarg(1)^2);
a2=(1-a1)/(1+inarg(2)^2);
tau1=abs(inarg(3));
tau2=abs(inarg(4));
tau3=abs(inarg(5));
probability_vector=(  1/( a1*(exp(-tm/tau1)-exp(-tx/tau1))+a2*(exp(-tm/tau2)-exp(-tx/tau2))+(1-a1-a2)*(exp(-tm/tau3)-exp(-tx/tau3)) )  )*...
                        ( a1/tau1*exp(-intervals/tau1)+a2/tau2*exp(-intervals/tau2)+(1-a1-a2)/tau3*exp(-intervals/tau3) )+...
                        0;

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
