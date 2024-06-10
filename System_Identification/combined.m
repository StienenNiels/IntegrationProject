function [dx, y] = combined(t,x,u,K_tau,K1,K2,K3,K4,K5,K6,varargin)
% K1 = 10.8975;
% K2 = 0.0393;
% K3 = 0.1051;
% K4 = 402;
% K5 = 0.9403;
% K6 = 1.7382;
theta = x(1);
theta_dot = x(2);
omega = x(3);
theta_ddot = -K1*sin(theta)-K2*theta_dot-K3*sign(theta_dot)-K_tau*(K4*u-K5*omega-K6*sign(omega));
omega_dot = K4*u-K5*omega-K6*sign(omega);
dx = [theta_dot; theta_ddot; omega_dot];
y = [theta;omega];
end