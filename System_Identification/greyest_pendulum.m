clear
clc
loadSim
h = 0.05;
y_init = D05_13_h05_Ef_An_R02.data(1,2);
y = D05_13_h05_Ef_An_R02.data(2:end,2);
z = iddata(y, [], h, 'Name', 'Pendulum');
z.OutputName = {'Pendulum angle'};
z.OutputUnit = {'rad'};
z.Tstart = 0;
z.TimeUnit = 's';



% Initial estimates
g = 9.81;
L = 0.2;
mu = 8.82e-5;
m = 1;

FileName      = 'pendulum';        % File describing the model structure.
Order         = [1 0 2];             % Model orders [ny nu nx].
Parameters    = [g/L; mu/m; 0.01];   % Initial parameters. %Jf,c_u,c_v
InitialStates = [y(1);(y(1)-y_init)/h];              % Initial initial states.
Ts            = 0;                   % Time-continuous system.
nlgr = idnlgrey(FileName, Order, Parameters, InitialStates, Ts);
nlgr.OutputName = {'Pendulum angle'};
nlgr.OutputUnit = {'rad'};
nlgr.TimeUnit = 's';
nlgr = setinit(nlgr, 'Name', {'Pendulum angle' 'Pendulum velocity'});
nlgr = setinit(nlgr, 'Unit', {'rad' 'rad/s'});
nlgr = setpar(nlgr, 'Name', {'K1' 'K2' 'K3'});
nlgr = setpar(nlgr, 'Unit', {'kg' 'idk' 'idk'});
nlgr = setpar(nlgr, 'Minimum', {eps(0) eps(0) -inf});   % All parameters > 0.
nlgr = setpar(nlgr, 'Maximum', {inf inf inf});   % All parameters > 0.



% C. Model computed with adaptive Runge-Kutta 45 ODE solver.
nlgrrk45 = nlgr;
nlgrrk45.SimulationOptions.Solver = 'ode45';     % Runge-Kutta 45.

figure(999);
compare(z, nlgrrk45, 1, ...
   compareOptions('InitialCondition', 'model'));

nlgrrk45 = setpar(nlgrrk45, 'Fixed', {false false false});

% We finally use the Runge-Kutta 45 solver (ode45).
opt = nlgreyestOptions('Display', 'on');
trk45 = clock;
nlgrrk45 = nlgreyest(z, nlgrrk45, opt);   % Perform parameter estimation.
trk45 = etime(clock, trk45);
figure(9999);

compare(z, nlgrrk45, 1, ...
   compareOptions('InitialCondition', 'model'));
nlgrrk45.Parameters

fpe(nlgrrk45);

for i = 1:2
    nlgrrk45 = nlgreyest(z,nlgrrk45, opt)
    nlgrrk45 = pem(z,nlgrrk45, opt)

    nlgrrk45.Parameters
    figure(i),clf;
        compare(z, nlgrrk45, 1, ...
        compareOptions('InitialCondition', 'model'));
        grid on
end



y_init = D05_13_h05_Ef_An_R01.data(1,2);
y = D05_13_h05_Ef_An_R01.data(2:end,2);
z = iddata(y, [], h, 'Name', 'Pendulum');
z.OutputName = {'Pendulum angle'};
z.OutputUnit = {'rad'};
z.Tstart = 0;
z.TimeUnit = 's';

[a,b,c]=nlgrrk45.Parameters.Value

FileName      = 'pendulum';        % File describing the model structure.
Order         = [1 0 2];             % Model orders [ny nu nx].
Parameters    = [a; b; c];   % Initial parameters. %Jf,c_u,c_v
InitialStates = [y(1);(y(1)-y_init)/h]              % Initial initial states.
Ts            = 0;                   % Time-continuous system.
nlgr = idnlgrey(FileName, Order, Parameters, InitialStates, Ts);
nlgr.OutputName = {'Pendulum angle'};
nlgr.OutputUnit = {'rad'};
nlgr.TimeUnit = 's';
nlgr = setinit(nlgr, 'Name', {'Pendulum angle' 'Pendulum velocity'});
nlgr = setinit(nlgr, 'Unit', {'rad' 'rad/s'});
nlgr = setpar(nlgr, 'Name', {'K1' 'K2' 'K3'});
nlgr = setpar(nlgr, 'Unit', {'kg' 'idk' 'idk'});
nlgr = setpar(nlgr, 'Minimum', {eps(0) eps(0) -inf});   % All parameters > 0.
nlgr = setpar(nlgr, 'Maximum', {inf inf inf});   % All parameters > 0.

nlgr.SimulationOptions.Solver = 'ode45';     % Runge-Kutta 45.

figure(3), clf;
compare(z, nlgr, 1, ...
   compareOptions('InitialCondition', 'model'));
grid on

