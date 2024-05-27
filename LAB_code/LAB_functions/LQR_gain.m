% Calculates the LQR gain for the system

% Normalization factors
wx1 = 1;
wx2 = 1;
wx3 = 1/250;
wu1 = 1;

% Penalization factors
qx1 = 20;
qx2 = 1e0;
qx3 = 1e-2;
qu1 = 5e3;

% Q,R,L matrices
Q = [wx1*qx1, 0, 0;
     0, wx2*qx2, 0;
     0, 0, wx3*qx3];
R = wu1*qu1;

% Calculate LQR gain
if model_continuous
    K_LQR = lqr(A,B,Q,R);
else
    K_LQR = dlqr(A,B,Q,R);
end
