function pc=probability_steps(probability_table,step_number)
%
% function probability_steps(probability_table,step_number)
%
% Each time this function is called it will  return a vector of length 'step_number' 
% listing step lengths that occur with a probability based on the 'probability_table'.
% The step numbers may be viewed as a result of a random walk with the listed step lengths
% or simply the result of trials for picking numbers with a probability given by the 
% 'probabilty_table'.  This table will list the numbers (step length) and corresponding
% probability of each step length occurring in a trial.  The entries in the output vector will
% be from the first column of the 'probability_table', and will be returned with a frequency
% (probability) matching that listed in the table.  That is, if the 'probability_table'
% contains the entries [number(:) probability(:)], then number(m) will appear with a probability
% of probability(m) in the output vector 'step_number'.
%
% probability_table ==[ number   probability], an Nx2 table (distribution) of possible step sizes
%                   [number(:)] and the probability that each such number(m) will occur in the
%                   output vector list.
% step_number == the number of values that will be returned in the output vector array 
pc=[];
[M N]=size(probability_table);
count=0;
while (count<step_number)
flag = 0;
   while (flag == 0)
                                             % randomly pick a row index of the
                                             % probability_table
   trial=round((M)*rand(1)-.5)+1;            % pick a number from 1 to M
	                                         % We're choosing one of M numbers
                                            % so we generate numbers btwn
                                            % 0.5 to M+0.5 and round to nearest 
                                            % integer	
                            % With a probability of the 'probability_table' distrib
							% you retain the number you pick.  The output
                            % list will then be a random sequence of numbers
                            % picked from probability_table(:,1)  where each number appears with
                            % the same probability as the corresponding probability_table(:,2)
                            % distribution

    prob=probability_table(trial,2);      % We use the 'trial' index from above (1 to M) as the
                                          % index into the probability_table distribution.  Here
                                          % we fetch the corresponding probabilty entry from the table.

    cf=rand(1);                           % Get a random number (0-1), uniformly distributed
    if prob>cf                            %Compare the random number with the probability
                                          % from the distribution table.  The probability from
                                          % the table will be greater than 'cf' only sometimes.
                                          % In fact, prob>cf will occur
                                          %with a probability of 'prob'.  When
                                          % this occurs you add the first column entry from the
                                          % distribution table to the output list.
     flag = 1;
     pc=[pc; probability_table(trial,1)];
     end
   end                      % END while (flag == 0)

count=count+1;
%   if ( round(count/200) == count/200)      % print the count after (integer)*200 values are accumulated
%    count
%   end
end