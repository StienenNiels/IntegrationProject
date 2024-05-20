function [dx,y] = flywheel_extended(t,x,u,K1,K2,K3,K4,K5,varargin)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
y = [x(1);x(3)];
% y = x(1);

Theta = x(1);
Theta_dot = x(2);
Omega_R = x(3);

f1 = -1; % Defined as fix 1 to indicate where in code they are placed
f2 = pi;

Theta_ddot = -K1*sin(Theta) -K2*Omega_R -K3*sign(Omega_R);
Omega_dot_R = K4*sin(Theta) +K2*Omega_R +K3*sign(Omega_R) -K5*u;


dx = [Theta_dot;
      Theta_ddot;
      Omega_dot_R];

end