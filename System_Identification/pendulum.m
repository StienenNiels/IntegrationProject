function [dx, y] = pendulum(t,x,u,K1,K2,K3,varargin)
theta = x(1);
theta_dot = x(2);
theta_ddot = -K1*sin(theta)-K2*theta_dot -K3*sign(theta_dot);
dx = [theta_dot; theta_ddot];
y = theta;
end
