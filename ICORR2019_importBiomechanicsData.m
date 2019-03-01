function biomechanics = ICORR2019_importBiomechanicsData()
%ICORR2019_importBiomechanicsData Import biomechanical data for
%optimization process
%   Imports a struct that contants knee moments, angles, and a time vector

% We will declare our biomechanical input trajectories as global 
% variables, as they are needed in the model script, which is called
% thousands of times. Rather than passing these variables around thousands
% of times during the optimization, we'll allow the model function to
% access them in the global namespace.
global time jointTorque jointAngle 

% Load a biomechanical input trajectories. Each of these are a 101
% dimensional array. Knee data was digitized from Farris, 2012.
load time.mat                   % time in seconds
load kneeTorquePerBm.mat        % knee moment, normalized to Nm/kg
load kneeAngle.mat              % knee angle in radians

% Multiply knee moment by a body mass of 115 kg.
jointTorque = kneeTorquePerBm*115;
jointAngle = kneeAngle;

% Pack up a struct to pass back to the primary workspace
biomechanics.time = time;
biomechanics.jointTorque = jointTorque;
biomechanics.jointAngle = jointAngle;

end

