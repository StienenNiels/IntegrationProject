function [dx,y] = motor(t,x,u,Jf,cu,cv,varargin)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
y = x;
dx = (cu*u-cv*x)/Jf;
end