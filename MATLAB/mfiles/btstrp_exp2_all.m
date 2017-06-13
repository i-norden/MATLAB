function bts=btstrp_exp2_all(nboot,inarg,intervals,mxintervals,tm)

%This is a bootstrap routine that calculates a distribution (of size nboot) 
%of fit parameters from fitting a data set of binding intervals, greater 
%than a minimum observation time, tm
%The likelihood function is calculated in the called function:
%'expfallthree_mxl', which takes input arguments for the initial
%guess of the fit parameters: inarg=[ap1 ap2 tau1 tau2 tau3].

%The data will be resampled with equal probability, including repeats, to
%generate a new data set of equal size to the original.  The new data set
%is then re-fit with the max-likelihood function.  This is repeated a total
%of 'nboot' times to generate a distribution of fit parameters.

N=length(intervals);
prob_tbl=[intervals ones(N,1)/N];
Nx=length(mxintervals);
prob_tblx=[mxintervals ones(Nx,1)/Nx];
for k=1:nboot
    bt_smpl=probability_steps(prob_tbl,N);
    bt_smplx=probability_steps(prob_tblx,Nx);
    btparms(k,:)=fminsearch('expfalltwo_all_events_mxl',inarg,[],bt_smpl,bt_smplx,tm);
end
bts=btparms;
end