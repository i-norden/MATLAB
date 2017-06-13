function pc=gaussian_spot(amplitude,sigma,xyspot,adu_per_photon,maxxy)
%
% functin gaussian_spot(amplitude, sigma, xyspot, adu_per_photon, maxxy)
%
% This function will output a matrix containing the gaussian function across the specified
% grid of xy pixels.  The grid will run from e.g. x=-maxxy:maxxy, y=-maxxy:maxxy
% Ths gaussian function computed is (same as 'gaussian_sum()' function).
%
%      (1/adu_per_photon)*(amplitude)*exp( -[x.^2 + y.^2]/(sigma^2) )
%
% amplitude == amplitude of gaussian in Analog to Digital units of (e.g.) a CCD output
% sigma     == standard deviation of the gaussian (in units of pixels)
% xyspot == [x y] x and y offset coordinates of the gaussian (units of pixels)
% adu_per_photon  == the number of Analog to Digital units per photon.  For example,
%            there may be around 120 or so A-to-D units per photon for the ICCD lab camera
% maxxy  == (integer pixel number) the maximum x or y pixel over which to generate the gaussian
%
% (Integrated result (continumous variable) is:  (amplitude/adu_per_photon)*2*pi*sigma^2)
% Output will be a matrix with the above gaussian function evaluated across the xy grid.
% Notice that the units output in the matrix are photons.
maxxy=round(maxxy);                             % force maxxy to integer pixel number
x=ones(2*maxxy+1,2*maxxy+1)*diag(-maxxy:maxxy); % set up x matrix
y=x';                                           % y matrix
                                                % Next, define the function over the x-y grid
xzero=xyspot(1);
yzero=xyspot(2);
pc = (1/adu_per_photon)*(amplitude)*exp( -[(x-xzero).^2 + (y-yzero).^2]/(sigma^2) );