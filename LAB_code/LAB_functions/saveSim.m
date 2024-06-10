function [] = saveSim(simout,simout_DC,simout_nowrap, h)
    name = input('Enter the name for the data: ', 's');
    folder = 'H:\Desktop\IntegrationProject\CollectedSimData';
    filepath = fullfile(folder, [name '.mat']);
    data.time = simout.time;
    data.pendulum_angle = simout.signals.values(:,2);
    data.pendulum_angle_estimate = simout.signals.values(:,1);
    data.pendulum_velocity_estimate = simout.signals.values(:,3);
    data.flywheel_velocity = simout.signals.values(:,5);
    data.flywheel_estimate = simout.signals.values(:,4);
    data.control = simout.signals.values(:,6);
    data.control_unsaturated = simout.signals.values(:,7);
    data.hybrid_state = simout.signals.values(:,8);
    data.DC_current = simout_DC.signals.values;
    data.pendulum_angle_unwrapped = simout_nowrap.signals.values(:,1);
    data.sampling_time = h;
    save(filepath, 'data');
    disp('Data saved');
end