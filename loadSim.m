function loadSim()
    tic
    addpath("CollectedSimData\");
    folder = 'CollectedSimData';
    % Get a list of all files in the folder
    files = dir(fullfile(folder, '*.mat'));
    % Iterate over each file
    for i = 1:numel(files)
        % Extract file name without extension
        [~, fileName, ~] = fileparts(files(i).name);
        % Print file name for debugging
        disp(['Loading file: ', fileName]);
        % Load data from workspace
        % loadedData = evalin('base', fileName);
        loadedData = load(files(i).name);
        % Assign the loaded data the name of the file
        assignin('base', fileName, loadedData);
    end
    toc
    disp('Data loaded');
end