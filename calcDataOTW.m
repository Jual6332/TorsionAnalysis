function calcDataOTW(filename) 
%% Givens
Re = 3.0/8.0;
thickness = 1.0/16.0;
L = 1.0;
G = 3.75*10^6;
beta = 1/3; % Assumption is valid, ad b/t > 10

%% Read in the Data File
[~,two] = xlsread(filename);
check = size(two); % Find the number of data points in the file
a = check(1); % Take the number of data points

%% Analyze and Store the Data
for ii=4:a
   b(ii-3) = two(ii); % read in the line of data
   c = strsplit(b{ii-3},','); % split the data by the comma delimiter
                              % only keep data 1,2,4 from each line
   
   % Store the experimental 
   time(ii-3) = str2double(c{1}); % Store time
   gamma(ii-3) = str2double(c{2}); % Store 
   T(ii-3) = str2double(c{4}); % Store Torque
end


%% Experimental Data: Calculate Phi, Phi'Rat, and GJ
phi = (gamma*L)/(thickness); % Calculate twist angle (deg)

% Calculate the Twist Angle Ratio, Phi'Rat
phirat = phi/gamma; % Calculate phirat (dimensionless)
for ii=1:length(phi)
    phiratio(ii) = phirat; % Apply this constant over a vector
end

% Calculate Torisonal Rigidity, GJ
GJ = (T.*L)./(phi*(pi/180)); % Calculate the torque rigidtity (lb-in^2)


%% Analytical Solution: Approx. OTW Theory
% Calculate the Shear Strain
p = 2*pi*Re; % Perimeter for approx case (in)
shear_approx = (180/pi)*(3*T)/(G*p*thickness^2); % Calculate OTW shear strain
Jexact = 1/3*p*thickness^3;

% Calculate the Torsional Rigidity
GJ_exact = G*Jexact; % GJ exact

% Calculate the Twist Angle
phi_approx = (180/pi)*(T*L)/(G*beta*p*thickness^3); % Calculate OTW twist angle 

% Calculate the Twist Angle Ratio, Phi'Rat
phirat_approx = phi_approx/shear_approx;
for ii=1:length(phi_approx)
    phiratio_approx(ii) = phirat_approx; % Apply this constant over a vector
end


%% Error Calculations - OTW Specimen
% Call calcErrorOTW function to retrieve the error associated with each
% method (compared against the experimental data)
error = calcErrorOTW(gamma, shear_approx);
fprintf('Error for the OTW specimen:\n')
fprintf('1.) OTW Error: %0.4f\n',error)


%% Plot Torque vs Shear Strain
% Plot Experimental Data
figure;
plot(gamma,T,'LineWidth',2)
hold on;

%Plot Theoretical-Approx CTW Solution
plot(shear_approx,T,'--','LineWidth',2)

% Include all Labels
xlabel('Shear strain, \gamma')
ylabel('Torque, T  (lb-in)')
legend('Experimental Data','OTW Solution')
xlim([0 0.12])
hold off; 

%% Plot Torque vs Phi
figure;
% Plot Experimental Data
plot(phi,T,'LineWidth',2)
hold on;

% Plot Theoretical-Approx OTW Solution
plot(phi_approx,T,'--','LineWidth',2)

% Include all labels
xlabel('Twist Angle, \phi  (deg)')
ylabel('Torque, T  (lb-in)')
legend('Experimental Data','OTW Solution')
xlim([0 1.8])
hold off; 


%% Plot Phirat vs Phi
figure;
% Plot Experimental Data
plot(phi,phiratio,'LineWidth',1.5)
hold on;

%Plot Theoretical-Approx OTW Solution
plot(phi_approx,phiratio_approx,'--','LineWidth',3)

xlabel('Twist Angle, \phi  (deg)')
ylabel('\phi_{rat}  (deg)')
legend('Experimental Data','OTW Solution')
xlim([0 1.5])
ylim([15.9 16.1])
hold off;

%% Plot Torisonal Rigidity vs Torque
figure;
% Plot Experimental Data
plot(T,GJ,'LineWidth',1.2)
hold on

% Plot Theoretical-Exact Solution
for ii=1:length(T)
    GJplot(ii) = GJ_exact;
end
plot(T,GJplot,'--','LineWidth',2.5)

% Include all labels
xlabel('Torque, T  (lbs-in)')
ylabel('Torsional Rigidity, GJ  (lbs-in^2)')
legend('Experimental Data','Exact Solution','CTW Solution')
xlim([-1 20])
ylim([-100 1000])
hold off

end