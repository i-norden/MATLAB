function pc=expfallone_all_events_mxl(tau,intervals,mxintervals,tm)
%
% function expfallone_all_events_mxl(tau,intervals,mxintervals,tm)
%
% Will test out a maximum likelihood algorithm for fitting a distribution
% function.  in this instance we will try just a simple exponential with a
% single fit parameter tau.  We also list the events 'mxintervals' that lasted out to the 
% maximum observation time (nondissociating, nonbleaching etc).User must 
% also input the minimum resolution
% time for the distribution, tm.
% probability for events that are seen to dissociate:
%       ( 1/( exp(-tm/tau)) )* (1/tau)*exp(-intervals/tau)
% probability for events that do not dissociate:
%       ( 1/( exp(-tm/tau)) )* exp(-mxintervals/tau)
% tau == exponential time constant   e.g.exp(-intervals/tau)
% intervals = vector list of intervals measured (e.g. observed residence 
%             times, or spots that we do observe to vanish) that
%            should be part of the distribution 
%            (1/tau)*exp(-intervals/tau)
% mxintervals = vector list of intervals for spots that do NOT vanish.  These
%             last throughout our measured observation time and we never see
%             them depart or bleach or whatever
%
% N == length(intervals),  number of binding events in our list
% tm== minimum interval length that can be resolved in the experiment
%
% call via fminsearch('expfallone_all_events_mxl',tauzero,[],intervals,mxintervals,tm)
%N=length(intervals);
                                  % Form the vector indicating the probabilities that
                                  % the intervals are part of the
                                   % trial distribution.
%probvector=( 1/( exp(-tm/tau) - exp(-tx/tau)) )*(1/tau)*exp(-intervals/tau); 
tau=abs(tau);
probvector1=( 1/( exp(-tm/tau)) )*(1/tau)*exp(-intervals/tau);
probvector2=( 1/( exp(-tm/tau)) )*exp(-mxintervals/tau);

%probvector=( N/exp(-tm/tau) )*(1/(1-exp(-28/tau) ))*(1/tau)*exp(-intervals/tau);     

prodprob=sum(log(probvector1))+sum(log(probvector2));           % Take product of all probabilities;
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

