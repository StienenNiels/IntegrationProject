% Calculates the LQR gain for the system

% true for rate of change penalty, false for no roc. pen.
% Note that simulink file also needs changes for roc=false
roc = false;

% Normalization factors
wx1 = 1;
wx2 = 1;
wx3 = 1/250;
wu1 = 1;

% Penalization factors
qx1 = 10;
qx2 = 1;
qx3 = 1e-2;
qu1 = 1e1;
ql1 = 10;

% Q,R,L matrices
Q = [wx1*qx1, 0, 0;
     0, wx2*qx2, 0;
     0, 0, wx3*qx3];
R = wu1*qu1;
L_roc = ql1;

% Calculate LQR gain
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


% Function taken from our MPC project
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
