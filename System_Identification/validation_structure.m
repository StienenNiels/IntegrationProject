clear
clc

set(groot,'defaulttextinterpreter','latex');  
set(groot, 'defaultAxesTickLabelInterpreter','latex');  
set(groot, 'defaultLegendInterpreter','latex');

addpath("Equations_of_Motion\");
addpath("CollectedSimData\");
addpath("System_Identification\");

loadSim;

% Choose which recorded data set to simulate by uncommenting
% Note that experiments denoted with Ed have the angle locked
% data = D05_08_h05_Ed_Asbc_R01;
% data = D05_08_h05_Ef_Ab_03H01_R01;
% data = D05_08_h05_Ef_Asbc_R01; % Amplitude 0.5
% data = D05_13_h05_Ef_An_R01;
% data = D05_13_h05_Ef_An_R02;
% data = D05_13_h05_Ef_Asbc_R01; % Underdamped
% data = D06_05_h05_Ea_An00H00_R01;
% data = D06_05_h05_Eb_An00H00_R01;
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
% data = D06_10_swingup_MPC_cont;
data = D06_10_swingup_MPC_disc_stop_R02;
data = data.data;
clearvars -except data

t = data.time;
theta = data.pendulum_angle;
theta_obs = data.pendulum_angle_estimate;

omega = data.flywheel_velocity;
omega_obs = data.flywheel_estimate; 

figure(1), clf;

% Create a tiled layout with 2 rows and 1 column
tiledlayout(2, 1);

% Top plot: Measured and estimated pendulum angle (theta)
ax1 = nexttile;
hold on;
stairs(t, theta, 'LineWidth', 1.5);
stairs(t, theta_obs,'--', 'LineWidth', 1.8);
hold off;
legend("Measured", "Estimated", 'Location', 'Best');
title('Pendulum Angle Comparison');
xlabel('Time (s)');
ylabel('Pendulum Angle (rad)');
grid on;
% Custom y-axis labels in LaTeX format
yticks(ax1, -pi:pi/2:pi);
yticklabels(ax1, {'$-\pi$', '$-\pi/2$', '$0$', '$\pi/2$', '$\pi$'});

% Bottom plot: Measured and estimated flywheel velocity (omega)
ax2 = nexttile;
hold on;
stairs(t, omega, 'LineWidth', 1.5);
stairs(t, omega_obs,'--', 'LineWidth', 1.8);
hold off;
legend("Measured", "Estimated", 'Location', 'Best');
title('Flywheel Velocity Comparison');
xlabel('Time (s)');
ylabel('Flywheel Velocity (rad/s)');
grid on;

% Link the x-axes of both subplots
linkaxes([ax1, ax2], 'x');

% Overall title for the figure
% sgtitle('Comparison of Measured and Estimated Pendulum Angle and Flywheel Velocity Using a Nonlinear Local Observer', 'FontSize', 9);

% Adjust layout for better appearance
tiledlayout.TileSpacing = 'compact';
tiledlayout.Padding = 'compact';


% Calculate the derivative of theta
theta_d_div = diff(data.pendulum_angle_unwrapped) ./ diff(t);
t_diff = t(1:end-1); % Adjust time vector to match the length of the derivative
theta_d_obs = data.pendulum_velocity_estimate

figure(2), clf;

% Top plot: Derivative of theta and theta_d_obs
hold on;
stairs(t_diff, theta_d_div, 'LineWidth', 1.5);
stairs(t, theta_d_obs, 'LineWidth', 1.5);
hold off;
legend("Calculated Velocity", "Observer Velocity", 'Location', 'Best');
title('Comparison of Calculated and Observer based Pendulum Velocity');
xlabel('Time (s)');
ylabel('Pendulum Angle Derivative (rad/s)');
grid on;


% %%
% sampling_time = 0.05;
% n1 = 1;
% time_vec  = data.data(n1:end,1);
% val_angle = data.data(n1:end,2);
% val_vel   = data.data(n1:end,3);
% val_vel(1) = 0; % The first value is usually 300~500 while it should be 0.
% current   = data.data(n1:end,4);
% control   = data.data(n1:end,5);
% initial_state = [val_angle(1);(val_angle(2)-val_angle(1))/sampling_time;0];
% 
% theta = zeros(size(control));
% omega = zeros(size(control));
% 
% xk = initial_state;
% theta(1) = xk(1);
% omega(1) = xk(3);
% for i = 2:size(control,1)
%     [theta(i), omega(i), xk] = nlrk4(@system_equations, control(i), sampling_time, xk);
% end
% 
% figure(1), clf;
% tiledlayout(3,1);
% nexttile
% hold on;
% plot(time_vec, theta);
% plot(time_vec, val_angle);
% legend("simulation", "validation data")
% 
% nexttile
% hold on;
% plot(time_vec, omega);
% plot(time_vec, val_vel);
% legend("simulation", "validation data")
% 
% nexttile
% hold on
% plot(time_vec, current)
% plot(time_vec, control);
% legend("DC current","Control input")