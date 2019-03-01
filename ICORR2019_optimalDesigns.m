function [optimalDesignTable] = ICORR2019_optimalDesigns(motorData,...
                                                         optimResults)
%ICORR2019_optimalDesigns Sort the optimization results into an ordered
%table

%% Unpack Optimization Results

optimVars = optimResults.optimalDesignVariables;
reflectedInertia = optimResults.reflectedInertia;
exitFlag = optimResults.exitFlag;

%% Make a List of Indices that Correspond to Feasible Systems

% A feasible system is a system where the constraints were met and the
% optimization terminated successfully.

motorNum = length(optimVars);

feasibleList = []; % declare an empty vector
for i = 1:motorNum
    if exitFlag(i) ~= -2 % add motors that didn't fail the optimization
        feasibleList = [feasibleList; i];
    end
end

%% Get the Parameters for the Optimized Designs that Meet the Constraints

% Declare empty data structures for 
feasMotorNames = {};
feas_r_Exo = [];
feas_r_Sheave = [];
feasReflectedInertia = [];
feasMotorInertia = [];

% Grab the parameters for each motor that didn't fail the optimization.
for i = feasibleList
    % motor names
    feasMotorNames = {feasMotorNames, motorData(i).name};
    feas_r_Exo = [feas_r_Exo; optimVars(1,i)];
    feas_r_Sheave = [feas_r_Sheave; optimVars(2,i)];
    feasReflectedInertia = [feasReflectedInertia; reflectedInertia(i)];
    feasMotorInertia = [feasMotorInertia; motorData(i).inertia];
end
feasMotorNames(1) = []; % drop empty header in cell

%% Sort the Feasible Designs by Reflected Inertia

% Sort. I gives back the sorted index ordering that we'll use to organize
% the rest of the lists.
[sorted_reflectedInertia, I] = sort(feasReflectedInertia);

% Sort everything with I.
sorted_motorNames = {};
for j = I
    sorted_motorNames = [sorted_motorNames, (feasMotorNames{j})];
end
sorted_motorNames = transpose(sorted_motorNames);
sorted_r_Exo = (feas_r_Exo(I))';
sorted_r_Sheave = (feas_r_Sheave(I))';
sorted_inertia = feasMotorInertia(I)';
rank = (1:length(sorted_motorNames))';

%% Build a Table

% Create a table with sorted values
optimalDesignTable = table(rank,...
                           sorted_motorNames,...
                           sorted_r_Exo,...
                           sorted_r_Sheave,...
                           sorted_inertia,...
                           sorted_reflectedInertia');
                       
% Name the table columns                       
optimalDesignTable.Properties.VariableNames = {'Rank',...
                                               'Motor_Name',...
                                               'Exo_Radius',...
                                               'Sheave_Radius',...
                                               'Motor_Inertia',...
                                               'Reflected_Inertia'};

end

