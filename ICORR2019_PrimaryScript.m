%%  ICORR 2019 Primary Script
%   All code was written by Anthony Anderson.
%   Winter 2019

% Clear all variables, close all figures, and clear the command window.
clear; close all; clc;

% Start a timer to evaluate code performance. 
tic

%% Description of Script

%{

    This script accompanies the ICORR 2019 submission titled, "A
    Model-Based Method for Minimizing Reflected Motor Inertia in Off-board
    Actuation Systems: Applications in Exoskeleton Design" by Anthony
    Anderson, Chris Richburg, and Patrick Aubin.

    Within the script, we implement an optimization algorithm to minimize
    the reflected inertia of a knee exoskeleton. 

    The steps are:

    1. Load catalog of motors and biomechanical input trajectories.

    2. Setup for the optimization.

    3. Run an independent optimization over each motor to select motor
    sheave radius and exoskeleton knee joint radius that minimize reflected
    inertia.

    4. Sort through the optimization results to determine the optimal
    configuration, and make a table that displays the results neatly. 

%}

%% Import Biomechanical Data

% This function will import a struct containing biomechanical trajectories
% for knee angle, moment, and a corresponding time vector for a single
% stride of gait. These trajectories are also loaded as global variables,
% so that they can be called by the model. The model function will be
% called thousands of times during the optimziation process, so making the
% trajectories global saves a substantial amount of time.
biomechanicsData = ICORR2019_importBiomechanicsData();

%% Import Motor Data

% Load a struct of motor data that I downloaded from Kollmorgen's website
% in spreadsheet form. More information about this struct can be found in
% the comments within the function.
motorData = ICORR2019_importMotorData();

%% Setup for Optimization

% This function returns a data struct containing options for the
% optimization aglorithm, lower and upper bounds on design/optimization
% variables and an initial seed point for the optimization algorithm.
optimizationSetup = ICORR2019_optimizationSetup();

%% Optimize Over Entire Motor Catalog

% This function performs an independent optimization over every motor in
% the loaded catalog. See Figure 1 from the publication accompanying this
% script. The function returns a data structure containing the optimized
% design variables for each motor, the reflected inertia of the system for
% each motor with the optimized design variables, and an exit flag that
% indicates whether the optimization was successful or not. An unsuccessful
% optimization indicates that the motor is unable to meet the constraints,
% and is denoted with an exit flag of -2.
optimizationResults = ICORR2019_optimize(motorData, optimizationSetup);

%% Create Table of Feasible Designs 

% This function takes the results of the independent motor optimizations
% and sorts them into a table of optimal designs, where the first entry in
% the table is the global optimal system.
optimalDesignTable = ICORR2019_optimalDesigns(motorData,...
                                              optimizationResults);

%% Print Results

% Print the results of the optimization, including the number of motors
% that were able to complete the input trajectories. 
ICORR2019_printResults(optimalDesignTable)
 
toc
