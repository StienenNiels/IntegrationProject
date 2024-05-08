function [dx,y] = flywheel_extended(t,x,u,g,M_f,l_f,M_b,l_b,J_R,J_bo,k_t,k_e,R,tau_fd,varargin)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
y = [x(1);x(3)];
% y = x(1);

Theta = x(1);
Theta_dot = x(2);
Omega_R = x(3);

Theta_ddot = -(k_t*u - Omega_R*k_e*k_t - R*tau_fd*sign(Omega_R) + M_b*R*g*l_b*sin(Theta) + M_f*R*g*l_f*sin(Theta))/(R*(J_bo + M_f*l_f^2));
Omega_dot_R = -(J_R*R*tau_fd*sign(Omega_R) - J_bo*k_t*u - J_R*k_t*u + J_bo*R*tau_fd*sign(Omega_R) - M_f*k_t*l_f^2*u + J_R*Omega_R*k_e*k_t + J_bo*Omega_R*k_e*k_t + M_f*R*l_f^2*tau_fd*sign(Omega_R) + M_f*Omega_R*k_e*k_t*l_f^2 - J_R*M_b*R*g*l_b*sin(Theta) - J_R*M_f*R*g*l_f*sin(Theta))/(J_R*R*(J_bo + M_f*l_f^2));



dx = [Theta_dot;
      Theta_ddot;
      Omega_dot_R];

end