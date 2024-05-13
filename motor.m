function [dx,y] = motor(t,x,u_in,Jf,k_t,k_e,R,tau_fd,varargin)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
y = x;
dx = (k_t*(u_in-0*k_e*x/R) - tau_fd*sign(x))/Jf;
end