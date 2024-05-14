function [theta, omega, xk1] = nlrk4(nlf, control, h, xk)

    % Executes one timestep of the RK4 algorithm
    k1 = nlf(0, xk, control);
    k2 = nlf(0 + h/2, xk + h/2*k1, control);
    k3 = nlf(0 + h/2, xk + h/2*k2, control);
    k4 = nlf(0 + h, xk + h*k3, control);
    xk1 = xk + h/6*(k1 + 2*k2 + 2*k3 + k4);
    
    % Take out states of interest
    theta = xk1(1);
    omega = xk1(3);
end