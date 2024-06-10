function dx = system_equations(t,x,u,gains)

% Define constants
K1 = gains.K1;
K2 = gains.K2;
K3 = gains.K3;
K4 = gains.K4;
K5 = gains.K5;
K6 = gains.K6;
K_tau = gains.K_tau;

% System equations
theta = x(1);
theta_dot = x(2);
omega = x(3);
theta_ddot = -K1*sin(theta)-K2*theta_dot-K3*sign(theta_dot)-K_tau*(K4*u-K5*omega-K6*sign(omega));
omega_dot = K4*u-K5*omega-K6*sign(omega);
dx = [theta_dot; theta_ddot; omega_dot];
end