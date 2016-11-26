function [errorOTW] = calcErrorOTW(shear, shear_OTW)
% Calculate the max of each function for the highest error (error in this case, increases with T)
a = max(shear);
c = max(shear_OTW);

% Calculate the error in the CTW case, compared against reality.
% Compared against experimental data
errorOTW = abs(a-c)/a;

end