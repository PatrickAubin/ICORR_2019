function [J,gradJ] = ICORR2019_costFunction(r,motorData)
%ICORR2019_costFunction Defines a cost function for a given motor.
%   This function defines the reflected inertia of a system given the motor
%   inertia and design variables.

%% Unpack

% A single motor is passed into this function, so we'll unpackage its
% inertia here.
Im = motorData.inertia;

%% Cost Function

% r(1) = r_exo
% r(2) = r_sheave

% Define cost function
J = ( (r(1) / r(2))^2 )*Im;

%% Gradient

% The gradient-based optimizer can use the analytical gradient to improve
% the speed of the primary script. This will not increase the speed much
% unless the gradients of the constraints are also provided, which will
% occur in a future release. 

% Define cost function gradient
if nargout > 1
    gradJ = [ ( 2*r(1) / (r(2)^2) )*Im;         % dJ/d(r_exo)
            ( -2*(r(1)^2) / (r(2)^3) )*Im];     % dJ/d(r_sheave)
end
end


