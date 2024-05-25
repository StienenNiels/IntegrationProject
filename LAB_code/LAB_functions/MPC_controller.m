p = 20;     % Prediction Horizon
m = 10;      % Control Horizon

sys_MPC = sysd;
sys_MPC.C = eye(3);

mpc_controller = mpc(sys_MPC, h, p, m); % MPC controller object

% Set weights
mpc_controller.Weights.ManipulatedVariables = 5e1; %Penalizes input
mpc_controller.Weights.ManipulatedVariablesRate = 10; %Rate of change
mpc_controller.Weights.OutputVariables = [1e3 1e0 (1e-2)/250]; %State penalty

% Set constraints
mpc_controller.MV.Min = -1; %Control constraints
mpc_controller.MV.Max = 1;

% mpc_controller.OV.Min %State constraints
% mpc_controller.OV.Max

% setEstimator(mpc_controller, 'custom');

% Save the MPC controller to the workspace
assignin('base', 'mpc_controller', mpc_controller);