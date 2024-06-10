function control_signal = generate_custom_signal(h, plot_bool)
    % Generates a custom control input signal
    % The entire signal is hardcoded and was used for data collection
    % during the system identification process.

    T_f = 60;
    T = 0:h:T_f;
    u = zeros(size(T));
    
    % Sine signal
    A = 0.5;
    freq = 0.5*2*pi;
    T1 = 0:h:10;
    u_sin = A*sin(freq*T1);
    
    % Square signal
    A = 0.25;
    freq = 0.1*2*pi;
    T2 = 0:h:20;
    u_sq = A*square(freq*T2)+A;
    
    % chirp
    A = 0.5;
    T3 = 0:h:10;
    u_chirp = A*chirp(T3, 0.1, T3(end), 0.8, 'linear');
    
    % Combine signals
    u(1:10/h+1) = u_sin;
    u(20/h+1:30/h+1) = u_chirp;
    u(40/h+1:60/h+1) = u_sq;
    
    % Final signal
    control_signal = [T',u'];
    
    % Plot signal in case of tweaking
    if plot_bool
        figure(1),clf;
        plot(T,u)
    end
end