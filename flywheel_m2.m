function [dx,y] = flywheel_m2(t,x,u,g,Mf,lf,mp,lp,Jf,Jm,c_u,c_v,varargin)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
y = [x(1)];

dx = [x(2);
      (c_v*x(3)-c_u*u+ (Mf*g*lf + lp*g*mp)*sin(-x(1)))/(Mf*lf^2+Jm);
      (-(Jf*c_v+Jm*c_v+Mf*c_v*lf^2)*x(3) + (Jf*c_u+Jm*c_u+Mf*c_u*lf^2)*u - Jf*(Mf*g*lf + lp*g*mp)*sin(-x(1)) )/(Jf*(Jm+Mf*lf^2))];
end