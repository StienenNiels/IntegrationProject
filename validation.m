clear
clc

loadSim;

% Choose which recorded data set to simulate
% Note that only experiments denoted by Ef should be used here
data = D06_05_h05_Ef_Ac08H0108_R01;
sampling_time = 0.05;
initial_state = [0;0;0];

time_vec  = data.data(:,1);
val_angle = data.data(:,2);
val_vel   = data.data(:,3);
control   = data.data(:,5);

theta = zeros(size(control));
omega = zeros(size(control));

xk = initial_state;
for i = 1:size(control,1)
    [theta(i), omega(i), xk] = nlrk4(@system_equations, control(i), sampling_time, xk);
end

figure(1), clf;
tiledlayout(2,1);
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