clear
clc
% Add folder with startup functions
addpath("LAB_functions\")

% Linearization point (unstable equilibrium, top position)
linearization_point = [pi;0;0];
% initial_state = [0;0;0];
% Deviation for in model simulation
lp_deviation = [deg2rad(5);0;0]; % 20 degrees from equilibrium
% Continuous or discrete observer and LQR gains
model_continuous = true; % unstable for discrete in model


% Initialize the sampling time
hwinit

% Custom signal generation
% control_signal = generate_custom_signal(h, false);

% Define linearized state space used for observer and LQR gains
generate_state_space
LQR_gain
reduced_observer
MPC_controller

% Just to be sure
disp("Yes, I've calculated whatever you wanted...")

% Initialize the sampling time
% (again) in case it's accidentally overwritten
hwinit