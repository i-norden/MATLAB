function bts=btstrp_exp2(nboot,inarg,intervals,tm,tx)

%This is a bootstrap routine that calculates a distribution (of size nboot) 
%of fit parameters from fitting a data set of binding intervals, greater 
%than a minimum observation time, tm.
%The likelihood function is calculated in the called function:
%'expfalltwo_mxl', which takes input arguments for the initial
%guess of the fit parameters: inarg=[ap tau1 tau2].

%The data will be resampled with equal probability, including repeats, to
%generate a new data set of equal size to the original.  The new data set
%is then re-fit with the max-likelihood function.  This is repeated a total
%of 'nboot' times to generate a distribution of fit parameters.

N=length(intervals);
prob_tbl=[intervals ones(N,1)/N];
options=optimset('fminsearch');
options.MaxFunEvals=2000;
options.MaxIter=2000;
btparms=zeros(nboot,3);
for k=1:nboot
    bt_smpl=probability_steps(prob_tbl,N);
    btparms(k,:)=fminsearch('expfalltwo_mxl',inarg,options,bt_smpl,tm,tx);
    if k/100==round(k/100),k,end
end
bts=btparms;
end