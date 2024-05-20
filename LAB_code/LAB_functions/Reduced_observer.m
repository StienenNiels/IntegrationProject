% Create reduced order observer gains

% true for continuous, false for discrete
OBS_cont = true;

% Desired observer pole in continuous time
pole_ct = -20;


% Change state ordering
P = [1,3,2];
if OBS_cont
    sys_order = xperm(sys,P);
else
    sys_order = xperm(sysd,P);
end

% Extract submatrices
A11 = sys_order.A(1:2,1:2);
A12 = sys_order.A(1:2,3);
A21 = sys_order.A(3,1:2);
A22 = sys_order.A(3,3);

B1 = sys_order.B(1:2);
B2 = sys_order.B(3);

% Find observer gain through pole placement
if OBS_cont
    L = place(A22',A12',pole_ct)';
else
    pole_d = exp(pole_ct*h);
    L = place(A22',A12',pole_d)';
end

% Observer matrices
F = A22-L*A12;
H = B2-L*B1;
G = A21-L*A11+F*L;

