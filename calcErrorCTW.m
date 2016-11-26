function [errorExact,errorCTW] = calcErrorCTW(shear,shear_exact, shear_CTW)
% Calculate the max of each function for the highest error (error in this case, increases with T)
a = max(shear);
b = max(shear_exact);
c = max(shear_CTW);

% Calculate the error in the Exact case, compared against reality.
% Compared against experimental data
errorExact = abs(a-b)/a;

% Calculate the error in the CTW case, compared against reality.
% Compared against experimental data
errorCTW = abs(a-c)/a;

end