function motorData = ICORR2019_importMotorData()
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here

% Load a struct of motor data that I downloaded from Kollmorgen's website
% in spreadsheet form. This document can be found at:
% https://www.kollmorgen.com/en-us/developer-network/motor-curves-tool-v161

% Load a structure that has AKM and CDD motors from Kollmorgen. Each motor
% within the struct has corresponding electrical and mechanical properties.
% The following information is included in the struct for each motor:
% 1. Name
% 2. Peak Motor Torque (Nm)
% 3. Peak Motor Current (Amps)
% 4. Operating Motor Torque (Nm)
% 5. Operating Motor Current (Amps)
% 6. Motor Inertia (kg-m^2)
% 7. Motor Terminal Resistance (Ohms)
% 8. Motor Torque Constant (Nm/Amp)
% 9. Peak Motor Speed (rad/s)
load motorData.mat

end


