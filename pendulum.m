function [dx, y] = pendulum(t,x,m,lambda,L)
theta = x(1);
theta_dot = x(2);
theta_ddot = -g/L*theta-lambda/m*theta_dot;
dx = [theta_dot; theta_ddot];
y = theta;
end
