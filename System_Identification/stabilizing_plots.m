clear
clc

set(groot,'defaulttextinterpreter','latex');  
set(groot, 'defaultAxesTickLabelInterpreter','latex');  
set(groot, 'defaultLegendInterpreter','latex');

addpath("..\Equations_of_Motion\");
addpath("..\CollectedSimData\");
% addpath("System_Identification\");
loadSim

% Choose which recorded data set to simulate by uncommenting
% data = D06_10_stabilizing_LQR_disc_R01;
data = D06_10_stabilizing_MPC_disc_R01;
data = data.data;
clearvars -except data

t = data.time;

figure(1), clf;
tiledlayout(4, 1);

% Top plot: Measured pendulum angle (theta)
ax_angle = nexttile;
ax_angle.Layout.TileSpan=[1,1];
hold on;
stairs(t, data.pendulum_angle, 'LineWidth', 1.5);
% legend("Pendulum angle", 'Location', 'northeast');
title('Pendulum Angle');
ylabel('(rad)');
grid on;
yticks(ax_angle, -pi/8:pi/16:pi/8);
ylim([-pi/8,pi/8])
yticklabels(ax_angle, {'$-\pi/8$', '$-\pi/16$', '$0$', '$\pi/16$', '$\pi/8$'});

ax_vel = nexttile;
ax_vel.Layout.TileSpan=[1,1];
hold on;
stairs(t, data.pendulum_velocity_estimate, 'LineWidth', 1.5);
% legend("Pendulum angle", 'Location', 'northeast');
title('Pendulum Velocity estimate');
ylabel('(rad/s)');
ylim([-1.5,1.5])
grid on;

ax_fvel = nexttile;
ax_fvel.Layout.TileSpan=[1,1];
hold on;
stairs(t, data.flywheel_velocity, 'LineWidth', 1.5);
% legend("Flywheel velocity", 'Location', 'northeast');
title('Flywheel velocity');
ylabel('(rad/s)');
ylim([-150,150])
grid on;

ax_input = nexttile;
ax_input.Layout.TileSpan=[1,1];
hold on;
stairs(t, data.control, 'LineWidth', 1.5);
% legend("Control input", 'Location', 'northeast');
title('Control input');
ylabel('Control input');
ylim([-1,1])
grid on;

% Link the x-axes of both subplots
linkaxes([ax_angle, ax_vel, ax_fvel, ax_input], 'x');
xlim([0,5])
xlabel('Time (s)');

% Adjust layout for better appearance
tiledlayout.TileSpacing = 'compact';
tiledlayout.Padding = 'compact';

set(gcf, "Visible", "on")
set(gcf, "Theme", "light");