w1 = 1;
w2 = 1;
w3 = 1/250;
n1 = 10;
n2 = 1;
n3 = 20;


Q = [w1*n1, 0, 0;
     0, w2*n2, 0;
     0, 0, w3*n3];
R = 5e0;

K_LQR = lqr(sysd.A,sysd.B,Q,R);
disp("Yes, I've calculated the LQR gain...")
disp(K_LQR)
% dlqr(sysd.A,sysd.B,Q,R)
