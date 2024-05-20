clear
clc

syms theta omega theta_dot u
h = 0.05;
% Changes compared to full equations:
% sign(x) -> x
% sin(theta) -> theta

% Define constants
K1 = 10.6608;
K2 = 0.0487;
K3 = 0.1031;
K4 = 404.3827;
K5 = 0.9442;
K6 = 1.7125;
K_tau = 0.0107;

% System equations
% theta = x(1);
% theta_dot = x(2);
% omega = x(3);
theta_ddot = -K1*sin(theta)-K2*theta_dot-K3*(theta_dot)-K_tau*(K4*u-K5*omega-K6*(omega));
omega_dot = K4*u-K5*omega-K6*(omega);
dx = [theta_dot; theta_ddot; omega_dot];

A = jacobian(dx,[theta,theta_dot,omega]);
B = jacobian(dx,u);

A = double(subs(A,theta,pi));
B = double(B);

sys = ss(A,B,[],[]);
sysd = c2d(sys,h);

rank(ctrb(A,B));

w1 = 1;
w2 = 1;
w3 = 1/250;
n1 = 10;
n2 = 1;
n3 = 1e-2;


Q = [w1*n1, 0, 0;
     0, w2*n2, 0;
     0, 0, w3*n3];
R = 1e1;
L = 10;

roc = 0;

if roc
    [A,B,C,Q,R,M] = rate_change_pen(A,B,Q,R,L);
    
    K_LQR = lqr(A,B,Q,R,M);
    disp("Yes, I've calculated the LQR gain...")
    disp(K_LQR)
else
    K_LQR = lqr(A,B,Q,R);
    disp("Yes, I've calculated the LQR gain...")
    disp(K_LQR)
end
% dlqr(sysd.A,sysd.B,Q,R)



function [A,B,C,Q,R,M] = rate_change_pen(A,B,Q,R,L)

% Augment the state with the previous control action
% This allows us to formulate it as a standard LQR problem with cross
% terms.
% For reference look at exercise set 2, problem 5
% x is now 16 states being: [u v w phi theta psi p q r X_b Y_b Z_b Omega1 Omega2 Omega3 mu]
n_x = size(A,1);
n_u = size(B,2);

% Calculate terminal cost using the discrete algebraic Ricatti equation
P = idare(A,B,Q,R);

% Extend the system matrices
A = [A, zeros(n_x,n_u);
     zeros(n_u,n_x), zeros(n_u,n_u)];
B = [B; eye(n_u)];
C = eye(n_x+n_u);

% Extend the weighing matrices
Q = [Q,zeros(n_x,n_u);
     zeros(n_u,n_x),L];
R = R+L;
M = -[zeros(n_x,n_u);L];


end