P = [1,3,2];
sysd_order = xperm(sysd,P);

A11 = sysd_order.A(1:2,1:2);
A12 = sysd_order.A(1:2,3);
A21 = sysd_order.A(3,1:2);
A22 = sysd_order.A(3,3);

B1 = sysd_order.B(1:2);
B2 = sysd_order.B(3);

pole_ct = -20;
pole_d = exp(pole_ct*h);
L = place(A22',A12',pole_d)';

F = A22-L*A12;
H = B2-L*B1;
G = A21-L*A11+F*L;

