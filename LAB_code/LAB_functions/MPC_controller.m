p = 25;     % Prediction Horizon
m = 15;      % Control Horizon

sys_MPC = sysd;
sys_MPC.C = eye(3);

mpc_controller = mpc(sys_MPC, h, p, m); % MPC controller object

% Set weights
mpc_controller.Weights.ManipulatedVariables = 10; %Penalizes input
mpc_controller.Weights.ManipulatedVariablesRate = 0; %Rate of change
mpc_controller.Weights.OutputVariables = [100 1e0 (1e-1)]; %State penalty

% Set constraints
mpc_controller.MV.Min = -1; %Control constraints
mpc_controller.MV.Max = 1;

mpc_controller.OV(3).Min = -250; %State constraints
mpc_controller.OV(3).Max = 250;

% Set terminal constraints/weight
% P = idare(A,B,Q,R)
% mpc_controller.Weights.Terminal = P;
% Y = struct('Weight',[P(1,1),P(2,2),P(3,3)],'Min',[deg2rad(-5),-0.05,-5],'Max',[deg2rad(5),0.05,5]);
% U = struct([])
% setterminal(mpc_controller,Y,U);

% Save the MPC controller to the workspace
assignin('base', 'mpc_controller', mpc_controller);


