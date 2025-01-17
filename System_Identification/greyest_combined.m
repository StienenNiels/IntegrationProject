clear
clf; clc;
loadSim
y_init = D05_08_h05_Ef_Asbc_R01.data(1,2);
y = D05_08_h05_Ef_Asbc_R01.data(2:end,2:3);
u = D05_08_h05_Ef_Asbc_R01.data(2:end,5);

% data = D06_10_training_data;
% data = data.data;
% z = iddata([data.pendulum_angle_unwrapped, data.flywheel_velocity], data.control, data.sampling_time, 'Name', 'Motor');

z = iddata(y, u, 0.05, 'Name', 'Motor');
z.OutputName = {'Pendulum angle' 'Flywheel angular velocity'};
z.OutputUnit = {'rad' 'rad/s'};
z.InputName = {'Control Signal'};
z.Tstart = 0;
z.TimeUnit = 's';

% val = iddata([data.pendulum_angle, data.flywheel_velocity], data.control, 0.01, 'Name', 'Motor');
% val.OutputName = {'Pendulum angle' 'Flywheel angular velocity'};
% val.OutputUnit = {'rad' 'rad/s'};
% val.InputName = {'Control Signal'};
% val.Tstart = 0;
% val.TimeUnit = 's';

FileName      = 'combined';        % File describing the model structure.
Order         = [2 1 3];             % Model orders [ny nu nx].

K1 = 10.8975;
K2 = 0.0393;
K3 = 0.1051;
K4 = 402;
K5 = 0.9403;
K6 = 1.7382;

K_tau = 0.01;
h = 0.05;

Parameters    = [K_tau, K1, K2, K3, K4, K5, K6];   % Initial parameters. %Jf,c_u,c_v
InitialStates = [y(1,1);(y(1,1)-y_init)/h;0]             % Initial initial states.
Ts            = 0;                   % Time-continuous system.
nlgr = idnlgrey(FileName, Order, Parameters, InitialStates, Ts);
nlgr.OutputName = {'Pendulum angle' 'Flywheel angular velocity'};
nlgr.OutputUnit = {'rad' 'rad/s'};
nlgr.TimeUnit = 's';
nlgr = setinit(nlgr, 'Name', {'Pendulum angle' 'Pendulum velocity' 'Flywheel velocity'});
nlgr = setinit(nlgr, 'Unit', {'rad' 'rad/s' 'rad/s'});
nlgr = setpar(nlgr, 'Name', {'K_tau' 'K1' 'K2' 'K3' 'K4' 'K5' 'K6'});
nlgr = setpar(nlgr, 'Unit', {'-' '-' '-' '-' '-' '-' '-'});
nlgr = setpar(nlgr, 'Minimum', {eps(0) eps(0) eps(0) eps(0) eps(0) eps(0) eps(0)});   % All parameters > 0.
nlgr = setpar(nlgr, 'Maximum', {inf inf inf inf inf inf inf});   % All parameters > 0.



% C. Model computed with adaptive Runge-Kutta 45 ODE solver.
nlgrrk45 = nlgr;
nlgrrk45.SimulationOptions.Solver = 'ode45';     % Runge-Kutta 45.

figure(999);
compare(z, nlgrrk45, 1, ...
   compareOptions('InitialCondition', 'model'));
grid on

nlgrrk45 = setpar(nlgrrk45, 'Fixed', {false false false false false false false});

opt = nlgreyestOptions('Display', 'on');
opt.SearchOptions.StepTolerance = 1e-3;
trk45 = clock;
nlgrrk45 = nlgreyest(z, nlgrrk45, opt);   % Perform parameter estimation.
trk45 = etime(clock, trk45);
figure(9999);

compare(z, nlgrrk45, 1, ...
   compareOptions('InitialCondition', 'model'));
nlgrrk45.Parameters
grid on

fpe(nlgrrk45);

for i = 1:1
    nlgrrk45 = nlgreyest(z,nlgrrk45, opt)

    nlgrrk45.Parameters
    figure(i),clf;
        compare(z, nlgrrk45, 1, ...
        compareOptions('InitialCondition', 'model'));
    grid on
end

%% Validation 
% loadSim;
data = D06_10_chirp_07_h05;
data = data.data;

val = iddata([data.pendulum_angle_unwrapped, data.flywheel_velocity], data.control, data.sampling_time, 'Name', 'Motor');
val.OutputName = {'Pendulum angle' 'Flywheel angular velocity'};
val.OutputUnit = {'rad' 'rad/s'};
val.InputName = {'Control Signal'};
val.Tstart = 0;
val.TimeUnit = 's';

figure();
compare(val, nlgrrk45, 1, ...
   compareOptions('InitialCondition', 'model'));
grid on

