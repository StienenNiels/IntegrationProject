% Calculates the LQR gain for the system

wx1 = 1;
wx2 = 1;
wx3 = 1/250;
wu1 = 1;

% Penalization factors
qx1 = 100;
qx2 = 1e0;
qx3 = 1e0;
qu1 = 5e-4;
L_LQR = 40;

% Q,R,L matrices
Q = [wx1*qx1, 0, 0;
     0, wx2*qx2, 0;
     0, 0, wx3*qx3];
R = wu1*qu1;

% Calculate LQR gain
if model_continuous
    x0 = [0;0;0];
    [A_LQR,B_LQR,C_LQR,Q_LQR,R_LQR,M_LQR,P_LQR,x0] = rate_change_pen(sys.A,sys.B,Q,R,L_LQR,x0);
    K_LQR = lqr(A_LQR,B_LQR,Q_LQR,R_LQR,M_LQR);
else
    x0 = [0;0;0];
    [A_LQR,B_LQR,C_LQR,Q_LQR,R_LQR,M_LQR,P_LQR,x0] = rate_change_pen(sys.A,sys.B,Q,R,L_LQR,x0);
    % K_LQR = dlqr(sys.A,sys.B,Q,R);
    K_LQR = dlqr(A_LQR,B_LQR,Q_LQR,R_LQR,M_LQR);
end

