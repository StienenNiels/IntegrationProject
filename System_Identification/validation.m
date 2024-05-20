clear
clc

loadSim;

% Choose which recorded data set to simulate by uncommenting
% Note that experiments denoted with Ed have the angle locked
% data = D05_08_h05_Ed_Asbc_R01;
% data = D05_08_h05_Ef_Ab_03H01_R01;
% data = D05_08_h05_Ef_Asbc_R01;
% data = D05_13_h05_Ef_An_R01;
% data = D05_13_h05_Ef_An_R02;
data = D05_13_h05_Ef_Asbc_R01; % Underdamped
% data = D06_05_h05_Ea_An00H00_R01; % Out of phase
% data = D06_05_h05_Eb_An00H00_R01; % Out of phase
% data = D06_05_h05_Ed_As10H05_R01;
% data = D06_05_h05_Ef_Ab05H02_R01;
% data = D06_05_h05_Ef_Ab05H05_R01;
% data = D06_05_h05_Ef_Ac05H0108_R01;
% data = D06_05_h05_Ef_Ac08H0108_R01;
% data = D06_05_h05_Ef_As03H02_R01; % Slightly underdamped
% data = D06_05_h05_Ef_As03H05_R01;
% data = D06_05_h05_Ef_As03H10_R01; % Small offset
% data = D06_05_h05_Ef_As05H05_R01;
% data = D06_05_h05_Ef_As07H02_R01;
% data = D06_05_h05_Ef_As10H05_R01; % Not even close (but to be expected)
sampling_time = 0.05;

time_vec  = data.data(:,1);
val_angle = data.data(:,2);
val_vel   = data.data(:,3);
val_vel(1) = 0; % The first value is usually 300~500 while it should be 0.
control   = data.data(:,5);
initial_state = [val_angle(1);(val_angle(2)-val_angle(1))/sampling_time;0];

theta = zeros(size(control));
omega = zeros(size(control));

xk = initial_state;
theta(1) = xk(1);
omega(1) = xk(3);
for i = 2:size(control,1)
    [theta(i), omega(i), xk] = nlrk4(@system_equations, control(i), sampling_time, xk);
end

figure(1), clf;
tiledlayout(3,1);
nexttile
hold on;
plot(time_vec, theta);
plot(time_vec, val_angle);
legend("simulation", "validation data")

nexttile
hold on;
plot(time_vec, omega);
plot(time_vec, val_vel);
legend("simulation", "validation data")

nexttile
hold on
plot(time_vec, control);
legend("Control input")