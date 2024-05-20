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
L_roc = 10;

roc = 0;

if roc
    [A,B,C,Q,R,M] = rate_change_pen(A,B,Q,R,L_roc);
    
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
