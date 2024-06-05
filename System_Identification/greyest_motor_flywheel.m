clear
clf; clc;
loadSim
u_mean = mean(DC_bias.data(:,4));
y = D05_08_h05_Ed_Asbc_R01.data(:,3);
u = D05_08_h05_Ed_Asbc_R01.data(:,5);%-u_mean;
z = iddata(y, u, 0.05, 'Name', 'Motor');
z.OutputName = {'Flywheel angular velocity'};
z.OutputUnit = {'rad/s'};
z.InputName = {'Control Signal'};
z.Tstart = 0;
z.TimeUnit = 's';

FileName      = 'motor';        % File describing the model structure.
Order         = [1 1 1];             % Model orders [ny nu nx].

Jf = 2.3e-4;
k_t = 0.027;
k_e = 0.025;
R = 2.3;
tau_fd = 1.32e-6;

K1 = 80; %k_t;
K2 = k_t*k_e/R;
K3 = tau_fd/Jf;

Parameters    = [K1, K2, K3];   % Initial parameters. %Jf,c_u,c_v
InitialStates = 0;             % Initial initial states.
Ts            = 0;                   % Time-continuous system.
nlgr = idnlgrey(FileName, Order, Parameters, InitialStates, Ts);
nlgr.OutputName = {'Flywheel angular velocity'};
nlgr.OutputUnit = {'rad/s'};
nlgr.TimeUnit = 's';
nlgr = setinit(nlgr, 'Name', {'Flywheel velocity'});
nlgr = setinit(nlgr, 'Unit', {'rad/s'});
nlgr = setpar(nlgr, 'Name', {'K1' 'K2' 'K3'});
nlgr = setpar(nlgr, 'Unit', {'-' '-' '-'});
nlgr = setpar(nlgr, 'Minimum', {eps(0) eps(0) eps(0)});   % All parameters > 0.
nlgr = setpar(nlgr, 'Maximum', {inf inf inf});   % All parameters > 0.



% C. Model computed with adaptive Runge-Kutta 45 ODE solver.
nlgrrk45 = nlgr;
nlgrrk45.SimulationOptions.Solver = 'ode45';     % Runge-Kutta 45.

figure(999);
compare(z, nlgrrk45, 1, ...
   compareOptions('InitialCondition', 'model'));

nlgrrk45 = setpar(nlgrrk45, 'Fixed', {false false false});

opt = nlgreyestOptions('Display', 'on');
opt.SearchOptions.StepTolerance = 1e-3;
trk45 = clock;
nlgrrk45 = nlgreyest(z, nlgrrk45, opt);   % Perform parameter estimation.
trk45 = etime(clock, trk45);
grid on

figure(9999);

compare(z, nlgrrk45, 1, ...
   compareOptions('InitialCondition', 'model'));
nlgrrk45.Parameters

fpe(nlgrrk45);

for i = 1:1
    nlgrrk45 = nlgreyest(z,nlgrrk45, opt)

    nlgrrk45.Parameters
    figure(i),clf;
        compare(z, nlgrrk45, 1, ...
        compareOptions('InitialCondition', 'model'));
    grid on
end

