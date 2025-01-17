% Create reduced order observer gains

% Desired observer pole in continuous time
pole_ct = -20;

% Change state ordering
P = [1,3,2];
sys_order = xperm(sys,P);

% Extract submatrices
A11 = sys_order.A(1:2,1:2);
A12 = sys_order.A(1:2,3);
A21 = sys_order.A(3,1:2);
A22 = sys_order.A(3,3);

B1 = sys_order.B(1:2);
B2 = sys_order.B(3);

% Find observer gain through pole placement
if model_continuous
    L = place(A22',A12',pole_ct)';
else
    pole_d = exp(pole_ct*h);
    L = place(A22',A12',pole_d)';
end

% Observer matrices
F = A22-L*A12;
H = B2-L*B1;
G = A21-L*A11+F*L;

pole_ctH = [-20,-25,-60];

C = [1,0,0;0,0,1];

if observer_continuous
    H_nlobs = place(sysc.A',C',pole_ctH)';
else
    pole_d = exp(pole_ctH*h);
    H_nlobs = place(sysd.A',C',pole_d)';
end





