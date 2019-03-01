function [motorVelocity, motorTorque] = ICORR2019_model(time,...
                                                        jointTorque,...
                                                        jointAngle,...
                                                        Imotor,...
                                                        r_exo,...
                                                        r_sheave)
%ICORR2019_model Simulates the human-robot system.
%    Given mechanical design parameters, a motor inertia, and
%    biomechanical input trajectories, this function computes the required
%    motor torque and velocity trajectories

%% Setup

% Set the Bowden cable stiffness. 
k_cable = 822000;

%% Simulate

% Paper Equation (8)
exoAngle = jointAngle + ICORR2019_stiffnessModel(jointTorque);

% Paper Equation (10)
F_cable = (jointTorque/r_exo)*(exp(0.055*(pi/2)));

% Paper Equation (11)
x_cable = exoAngle*r_exo + F_cable/k_cable;

% Paper Equation (12)
motorAngle = x_cable/r_sheave;
                             
% Compute motor velocity and acceleration with finite difference
% derivatives. 
motorVelocity = ICORR2019_derivative(time, motorAngle);
motorAcceleration = ICORR2019_derivative(time, motorVelocity);

%% Filtering
% Noise is introduced to the motor velocity and acceleration due to the
% finite difference derivatives. Filter the velocity and acceleration using
% an 8th order zero lag low pass butterworth filter at 20 Hz. This
% frequency was chosen manually, but plotting after filtering at several
% different frequencies.

% Determine sampling frequency in Hz
sf = 1/mean(diff(time));

% Set normalized cutoff frequency to cutoff frequency
Wn = 10/(sf/2);

% User butter function to determine filter coefficients
[B,A] = butter(4,Wn);

% Filter both velocity and accleration.
motorVelocity = filtfilt(B,A,motorVelocity);
motorAcceleration = filtfilt(B,A,motorAcceleration);

%% Simulate

% Paper Equation (13)
motorTorque = motorAcceleration*Imotor + F_cable*r_sheave;

end

