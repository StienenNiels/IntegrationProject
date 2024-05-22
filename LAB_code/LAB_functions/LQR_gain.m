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
qx1 = 100;
qx2 = 1e0;
qx3 = 1e-2;
qu1 = 1e2;
ql1 = 10;

% Q,R,L matrices
Q = [wx1*qx1, 0, 0;
     0, wx2*qx2, 0;
     0, 0, wx3*qx3];
R = wu1*qu1;
L_roc = ql1;

% Calculate LQR gain
if roc && model_continuous
    [A,B,C,Q,R,M] = rate_change_pen(A,B,Q,R,L_roc,model_continuous);
    K_LQR = lqr(A,B,Q,R,M);
elseif roc && ~model_continuous
    [A,B,C,Q,R,M] = rate_change_pen(A,B,Q,R,L_roc,model_continuous);
    K_LQR = dlqr(A,B,Q,R,M);
elseif ~roc && model_continuous
    % A = sysd.A;
    % B = sysd.B;
    % K_LQR = [dlqr(A,B,Q,R),0]
    K_LQR = [lqr(A,B,Q,R),0]
else
    K_LQR = [dlqr(A,B,Q,R),0]
end

% Function taken from our MPC project
function [A,B,C,Q,R,M] = rate_change_pen(A,B,Q,R,L,model_continuous)  
    % Augment the state with the previous control action
    % This allows us to formulate it as a standard LQR problem with cross
    % terms.
    % For reference look at exercise set 2, problem 5
    n_x = size(A,1);
    n_u = size(B,2);
    
    % Calculate terminal cost using the algebraic Ricatti equation
    if model_continuous
        P = icare(A,B,Q,R);
    else
        P = idare(A,B,Q,R);
    end
    
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
