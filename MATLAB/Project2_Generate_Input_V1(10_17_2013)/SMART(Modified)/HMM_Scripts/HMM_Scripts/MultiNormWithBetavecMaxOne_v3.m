function y = MultiNormWithBetavecMaxOne_v3(beta,x)
% d = round((-1+sqrt(1+8*length(beta)))/2);
% % r = n^2 - (n^2 - n) / 2 = (n^2 + n)/2
% 
% C = triu(ones(d,d));
% ixSet = find(C);
% for i = 1:length(ixSet),
%     C(ixSet(i)) = beta(i);
% end
% C = C + triu(C,1)';
% invC = inv(C);
L = BetaToL(beta);
C = L*L';
d = size(L,1);

% y = mvnpdf(x,zeros(1,d),L*L')./mvnpdf(zeros(1,d),zeros(1,d),L*L');
y = mvnpdf(x,zeros(1,d),C).*(((2*pi)^(d/2))*sqrt(det(C)));

% sqrtdetC = sqrt(det(C));

% y = zeros(size(x,1),1);
% for i = 1:size(x,1),
%     y(i) = exp(-0.5*(([x(i,1) x(i,2)]*invC*[x(i,1)' ; x(i,2)'])))./(((2*pi)^(d/2))*sqrtdetC);
% end
    
% y = exp(-0.5*(diag(x*invC*x')));