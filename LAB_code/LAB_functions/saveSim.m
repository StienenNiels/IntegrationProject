function [] = saveSim(simout)
    name = input('Enter the name for the data: ', 's');
    folder = 'H:\Desktop\IntegrationProject\CollectedSimData';
    filepath = fullfile(folder, [name '.mat']);
    data = [simout.time,simout.signals.values];
    save(filepath, 'data');
    disp('Data saved');
end