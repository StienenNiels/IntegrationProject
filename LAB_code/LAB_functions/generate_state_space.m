% Linearizes the model with a few assumptions and generates continuous and
% discrete state space A,B matrices

% Changes compared to nonlinear equations:
% sign(x) -> x

syms theta omega theta_dot u

% Define constants (find with nlgrey estimation)
K1 = 10.6608;
K2 = 0.0487;
K3 = 0.1031;
K4 = 404.3827;
K5 = 0.9442;
K6 = 1.7125;
K_tau = 0.0107;

% System equations
theta_ddot = -K1*sin(theta)-K2*theta_dot-K3*(theta_dot)-K_tau*(K4*u-K5*omega-K6*(omega));
omega_dot = K4*u-K5*omega-K6*(omega);
dx = [theta_dot; theta_ddot; omega_dot];

% Derive A and B matrices
A = jacobian(dx,[theta,theta_dot,omega]);
B = jacobian(dx,u);

A = double(subs(A,[theta,theta_dot,omega],linearization_point'));
B = double(B);

% Generate state spaces
sysc = ss(A,B,[],[]);
sysd = c2d(sysc,h);
if model_continuous
    sys = sysc;
else
    sys = sysd;
end


