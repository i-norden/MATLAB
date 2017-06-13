function bts=btstrp_exp1(nboot,inarg,intervals,tm,tx)

%This is a bootstrap routine that calculates a distribution (of size nboot) 
%of fit parameters from fitting a data set of binding intervals, greater 
%than a minimum observation time, tm, and less than a maximum observation 
%time, tx.
%The likelihood function is calculated in the called function:
%'expfallone_mxl_2', which takes an input argument for the initial
%guess of the fit parameter: inarg=tau. tau is the dissociation time constant.

%The data will be resampled with equal probability, including repeats, to
%generate a new data set of equal size to the original.  The new data set
%is then re-fit with the max-likelihood function.  This is repeated a total
%of 'nboot' times to generate a distribution of fit parameters.


sz=size(intervals);
N=sz(1);
prob_tbl=[intervals ones(N,1)/N];
for k=1:nboot
    bt_smpl=probability_steps(prob_tbl,N);
    btparms(k,:)=fminsearch('expfallone_mxl',inarg,[],bt_smpl,tm,tx);
end
bts=btparms;
end