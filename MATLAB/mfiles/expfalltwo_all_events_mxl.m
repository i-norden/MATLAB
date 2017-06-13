function pc=expfalltwo_all_events_mxl(inarg,intervals,mxintervals,tm)
%
% function expfalltwo_all_events_mxl(inarg,intervals,mxintervals,tm)
%
% Will test out a maximum likelihood algorithm for fitting a distribution
% function.  in this instance we will try just a biexponential with a
% We also list the events 'mxintervals' that lasted out to the 
% maximum observation time (nondissociating, nonbleaching etc).User must 
% also input the minimum resolution
% time for the distribution, tm.
% probability for events that are seen to dissociate:
%(  1/( a*A + (1-a)*B )*...
%          ( a/tau1 *exp(-intervals/tau1)+(1-a)/tau2 *exp(-intervals/tau2) );
%
%  where A = exp(-tm/tau1) 
%    and B = exp(-tm/tau2)
%  (see B18p36)
% probability for events that do not dissociate:
%(  1/( a*A + (1-a)*B )*...
%          ( a *exp(-mxintervals/tau1)+(1-a) *exp(-mxintervals/tau2) );
% inarg = [ ap tau1 tau2],  starting fit parameters in the distribution, 
%                defined in the above equation for the distribution
%               note that a = 1/(1+ap^2)
% intervals = vector list of intervals measured (e.g. observed residence 
%             times, or spots that we do observe to vanish) that
%            should be part of the distribution 
%            (1/tau)*exp(-intervals/tau)
% mxintervals = vector list of intervals for spots that do NOT vanish.  These
%             last throughout our measured observation time and we never see
%             them depart or bleach or whatever
% tm== minimum interval length that can be resolved in the experiment
%
% call via fminsearch('expfalltwo_all_events_mxl',inarg,[],intervals,mxintervals,tm)

                                  % Form the vector indicating the probabilities that
                                  % the intervals are part of the
                                   % trial distribution.
%probvector=( 1/( exp(-tm/tau) - exp(-tx/tau)) )*(1/tau)*exp(-intervals/tau); 
a=1/(1+inarg(1)^2);
tau1=abs(inarg(2));
tau2=abs(inarg(3));
A=exp(-tm*tau1);
B =exp(-tm*tau2);
probability_vector1=(  1/( a*A + (1-a)*B  ) )*...
                                 ( a*tau1*exp(-intervals*tau1)+(1-a)*tau2*exp(-intervals*tau2) );
probability_vector2=(  1/( a*A + (1-a)*B  ) )*...
                                 ( a*exp(-mxintervals*tau1)+(1-a)*exp(-mxintervals*tau2) );


%probvector=( N/exp(-tm/tau) )*(1/(1-exp(-28/tau) ))*(1/tau)*exp(-intervals/tau);     

prodprob=sum(log(probability_vector1))+sum(log(probability_vector2));           % Take product of all probabilities;

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

