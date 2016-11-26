function calcDataCTW(filename) 
%% Givens
Re = 3.0/8.0;
thickness = 1.0/16.0;
L = 1.0;
G = 3.75*10^6;

%% Read in the Data File
[~,two] = xlsread(filename);
check = size(two); % Find the number of data points in the file
a = check(1); % Take the number of data points

%% Analyze and Store the Data
for ii=4:a
   b(ii-3) = two(ii); % read in the line of data
   c = strsplit(b{ii-3},','); % split the data by the comma delimiter
                              % only keep data 1,2,4 from each line
   
   % Store the experimental data
   time(ii-3) = str2double(c{1}); % Store time
   gamma(ii-3) = str2double(c{2}); % Store 
   T(ii-3) = str2double(c{4}); % Store Torque
end


%% Experimental Data: Calculate Phi, Phirat, GJ
phi = (gamma*L)/(Re); % Calculate twist angle (deg)
phirat = phi/gamma; % Calculate phirat (dimensionless)
GJ = (T.*L)./(phi*(pi/180)); % Calculate the torque rigidtity (lb-in^2)
for ii=1:length(phi)
    phiratio(ii) = phirat; % Apply this constant over a vector
end


%% Analytical Solution: Exact Theory
% Calculate the Shear Strain
Ri = Re-thickness; % inner radius Ri (in)
Jexact = 0.5*pi*((Re^4)-(Ri^4)); % Polar moment of inertia (in^4)
shear_exact = (180/pi)*(T*Re)/(G*Jexact); % Shear strain (deg)

% Calculate the Torsional Rigidity
GJ_exact = G*Jexact % GJ exact

% Calculate the Twist Angle
phi_exact = (shear_exact*L)/Re; % phi exact

% Calculate the Twist Angle Ratio, Phi'Rat
phirat_exact = phi_exact/shear_exact; % phirat exact
for ii=1:length(phi_exact)
    phiratio_exact(ii) = phirat_exact; % Apply this constant over a vector
end

% Calculate the Twist Rate
%phiprime_exact = shear_exact/Re; % phi' exact


%% Analytical Solution: Approx. CTW Theory
% Calculate the Shear Strain
R = (Ri+Re)/2; % Avg radius (in)
Ae_approx = pi*(R)^2; % Enclosed area for approx case (in^2)
p = 2*pi*R; % Perimeter for approx case (in)
Japprox = (4*(Ae_approx)^2*thickness)/(p); % Polar moment of inertia (in^4)
shearapprox = (180/pi)*(2*T)/(G*thickness*pi*(Re+Ri)^2); % Shear strain approx

% Calculate the Twist Angle
phi_approx = (180/pi)*(T*L)/(G*Japprox); % Twist angle (deg)

% Calculate the Twist Angle Ratio, Phi'Rat
phirat_approx = (phi_approx)/(shearapprox); % Phirat approx (dimensionless)
for ii=1:length(phi_approx)
    phiratio_approx(ii) = phirat_approx; % Apply this constant over a vector
end

% Calculate the Twist Rate
phiprime_approx = (180*pi)*(T/(G*Japprox)); % Twist rate (deg)


%% Error Calculations - CTW Speciment
% Call calcErrorCTW function to retrieve the error associated with each
% method (compared against the experimental data)
[error1,error2] = calcErrorCTW(gamma, shear_exact, shearapprox);
fprintf('Error for the CTW specimen:\n')
fprintf('1.) Exact Error: %0.4f\n',error1)
fprintf('2.) CTW Error: %0.4f\n',error2)


%% Plot Torque vs Shear Strain
% Plot Experimental Data
figure;
plot(gamma,T,'LineWidth',2)
hold on;
%Plot Theoretical-Exact Solution
plot(shear_exact,T,'--','LineWidth',2)

%Plot Theoretical-Approx CTW Solution
plot(shearapprox,T,'-.','LineWidth',2)

% Include all Labels
xlabel('Shear strain, \gamma','FontSize',16)
ylabel('Torque, T (lb-in)','FontSize',16)
legend('Experimental Data','Exact Solution','CTW Solution','FontSize',12)
xlim([0 0.16])
hold off; 


%% Plot Torque vs Phi
figure;
% Plot Experimental Data
plot(phi,T,'LineWidth',2)
hold on;

% Plot Theoretical-Exact Solution
plot(phi_exact,T,'--','LineWidth',2)

% Plot Theoretical-Approx CTW Solution
plot(phi_approx,T,'-.','LineWidth',2)

% Include all labels
xlabel('Twist Angle, \phi  (deg)','FontSize',16)
ylabel('Torque, T (lb-in)','FontSize',16)
legend('Experimental Data','Exact Solution','CTW Solution')
hold off; 


%% Plot Phirat vs Phi
figure;
% Plot Experimental Data
plot(phi,phiratio,'LineWidth',2)
hold on;

%Plot Theoretical-Exact Solution
plot(phi_exact,phiratio_exact,'--','LineWidth',2)

%Plot Theoretical-Approx CTW Solution
plot(phi_approx,phiratio_approx,'-.','LineWidth',2)

xlabel('Twist Angle, \phi  (deg)','FontSize',16)
ylabel('\phi_{rat}  (deg)','FontSize',16)
legend('Experimental Data','Exact Solution','CTW Solution')
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
hold off


end