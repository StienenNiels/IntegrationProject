function dx = system_equations(t,x,u)

% Define constants
K1 = 10.6608;
K2 = 0.0487;
K3 = 0.1031;
K4 = 404.3827;
K5 = 0.9442;
K6 = 1.7125;
K_tau = 0.0107;

% System equations
theta = x(1);
theta_dot = x(2);
omega = x(3);
theta_ddot = -K1*sin(theta)-K2*theta_dot-K3*sign(theta_dot)-K_tau*(K4*u-K5*omega-K6*sign(omega));
omega_dot = K4*u-K5*omega-K6*sign(omega);
dx = [theta_dot; theta_ddot; omega_dot];
end