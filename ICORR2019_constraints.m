function [c, ceq] = ICORR2019_constraints(r,motor)
%ICORR2019_constraints Evaluate whether or not a given motor and design
%configuration can carry out the biomechanical trajectories.
%   This function will use the biomechanical input trajectories (globally
%   defined) and motor parameters to simulate the system. It will then see
%   if the resulting motor trajectories meet the constraints for the unique
%   motor.  

%% Load Data and Unpack Variables from Struct

% Load global variables
global time jointTorque jointAngle

% Pull out design variables from parameter vector
r_exo = r(1); 
r_sheave = r(2);

% Unpack Motor Parameters
Imotor = motor.inertia;                     % Motor Inertia
Kt = motor.torqueConstant;                  % Motor Torque Constant
R = motor.resistance;                       % Terminal Resistance
maxCurrent = motor.peakCurrent;             % Peak Motor Current
operatingCurrent = motor.operatingCurrent;  % Operating Motor Current
peakSpeed = motor.peakSpeed;                % Peak Motor Speed

%% Run Simulation

% To evaluate the constraints, we need to simulate the motor with the given
% design variables.
[motorVelocity, motorTorque] = ICORR2019_model(time, jointTorque,...
                                               jointAngle, Imotor,...
                                               r_exo, r_sheave);
                                 
%% Set Electrical Limits

% Voltage
V = 264.7;

% If max current for the motor is higher than the current available in the 
% laboratory, set it equal to the current available in the laboratory. 
maxCurrent(maxCurrent>30) = 30;

% If continuous operating current for the motor is higher than the
% continuous operating current for the servo drive, set it to the
% continuous operating currrent for the drive. 
operatingCurrent(operatingCurrent>24) = 24;

%% Constraints

% Here we write all of our inequality constraints 'a < b' as 'c = a - b'.
% See matlab help for fmincon for additional documentation on constraints.

% Constraint 1: Motor current required to carry out the trajectory is less
% than the motor current available at a given velocity. This will be a
% vector that is as long as the motor torque trajectory, so the constraint
% is enforced at all time points.
currentRequired = abs(motorTorque/Kt);
c1 = currentRequired - V/R + (Kt*abs(motorVelocity))/R;

% Constraint 2: Motor current required to carry out the trajectory is lower
% than the maximum allowable motor current due to limits in the motor or
% limits in the wall power.
c2 = currentRequired - maxCurrent;

% Constraint 3: Motor velocity is always lower than maximum allowable motor
% velocity.
c3 = abs(motorVelocity) - peakSpeed;

% Constraint 4: RMS of the motor current trajectory is lower than the
% continuous operating current for the motor and/or drive. This is the
% analytical expression for computing RMS.
T = time(end);
c4 = sqrt( (1/T) * trapz(time, (motorTorque./Kt).^2) ) - operatingCurrent;

%% Package Up Variables

% This is the constraint vector. It will be 3x the length of the motor
% trajectory plus one for constraint 4. For the constraints to be met,
% every number in this vector must be below zero.
c = [c1', c2', c3', c4];

% Matlab also requires an equality constraints vector to be returned, so we
% return an empty vector.
ceq = [];

end

