clear
clc

set(groot,'defaulttextinterpreter','latex');  
set(groot, 'defaultAxesTickLabelInterpreter','latex');  
set(groot, 'defaultLegendInterpreter','latex');
set(groot, 'defaultAxesFontSize', 11); % Set default font size for axes
set(groot, 'defaultTextFontSize', 11); % Set default font size for text
set(groot, 'defaultLegendFontSize', 11); % Set default font size for legends

addpath("..\Equations_of_Motion\");
addpath("..\CollectedSimData\");
% addpath("System_Identification\");
loadSim

% Choose which recorded data set to simulate by uncommenting
% data = D06_10_swingup_LQR_stop_R02;
data = D06_10_swingup_MPC_disc_stop_R02;
data = data.data;
clearvars -except data

n = 21; % Number of wraps
% n=1 for LQR
% n=21 for MPC
t = data.time;

figure(1), clf;
% Create a tiled layout with 2 rows and 1 column
tiledlayout(3, 1);

% Top plot: Measured pendulum angle (theta)
ax_angle = nexttile;
ax_angle.Layout.TileSpan=[1,1];
hold on;
stairs(t, data.pendulum_angle_unwrapped-n*pi, 'LineWidth', 1.5);
% legend("Pendulum angle", 'Location', 'southeast');
title('Pendulum Angle');
ylabel('Pendulum Angle (rad)');
grid on;
yticks(ax_angle, 0:pi/2:2*pi);
yticklabels(ax_angle, {'$0$', '$\pi/2$', '$\pi$', '$3\pi/2$', '$2\pi$'});
ylim([-pi/4,2*pi+pi/4])

ax_input = nexttile;
ax_input.Layout.TileSpan=[1,1];
hold on;
stairs(t, data.control_unsaturated, 'LineWidth', 1.5);
stairs(t, data.control, 'LineWidth', 1.5);
legend("unsaturated", "saturated", 'Location', 'northeast');
title('Control input');
ylabel('Control input');
ylim([-2,2])
grid on;

% Bottom plot: Hybrid state
ax_state = nexttile;
ax_state.Layout.TileSpan=[1,1];
hold on
grid on
colors = [
    0 0 0 1;
    0.4940 0.1840 0.5560 1;   % A color
    0.8500 0.3250 0.0980 1;   % Another color
    0.4660 0.6740 0.1880 1;   % Yet another
    0 0.4470 0.7410 1;   % Last color (or first)
];
custom_colormap = [0 0 0 0; colors];
hauto = data.hybrid_state;
colored_matrix = zeros(4,length(hauto));
for i = 1:length(hauto)
    if hauto(i) == -0.1
        colored_matrix(1,i) = 1;
    elseif hauto(i) == 0.0
        colored_matrix(2,i) = 2;
    elseif hauto(i) == 0.4
        colored_matrix(3,i) = 3;
    elseif hauto(i) == 0.1
        colored_matrix(4,i) = 4;
    end
end

h = image(t, 1:4, colored_matrix, 'CDataMapping', 'scaled');
colormap(colors(:, 1:3)); % Only RGB for colormap
alpha_data = ones(size(colored_matrix));
alpha_data(colored_matrix == 0) = 0; % Make black (0) transparent
set(h, 'AlphaData', alpha_data);
set(ax_state, 'YTick', 1:4, 'YTickLabel', {'swing up', 'nothing', 'stabilizing', 'slow down'});
title('Hybrid mode');

% Link the x-axes of both subplots
linkaxes([ax_angle, ax_input, ax_state], 'x');
xlim([0,30])
xlabel('Time (s)');

% Adjust layout for better appearance
tiledlayout.TileSpacing = 'compact';
tiledlayout.Padding = 'compact';

set(gcf, "Visible", "on")
set(gcf, "Theme", "light");