function [] = ICORR2019_printResults(optimalDesignTable)
%ICORR2019_printResults This function prints the optimization results

%% Setup

% Get the number of motors that passed the optimization
n = height(optimalDesignTable);

% Clear the command window, as it is full of optimization outputs.
clc

%% Print
fprintf('Optimization Results: \n\n')
fprintf(['%i', ' motors were able to complete the trajectories.\n\n'],n)

fprintf('Top Five Optimal Systems: \n')
top_Five = optimalDesignTable(1:5,:)

fprintf('\n')

end

