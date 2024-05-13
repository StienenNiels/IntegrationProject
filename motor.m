function [dx,y] = motor(t,x,u_in,K1,K2,K3,varargin)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
y = x;
dx = K1*u_in-K2*x-K3*sign(x);
end