function rad = ICORR2019_stiffnessModel(torque)
%ICORR2019_stiffnessModel determine exoskeleton rotation due to soft tissue
% compression
%   This function uses our experimentally determined relationship between
%   applied torque and exoskeleton rotation to soft tissue compression.
%   Input a torque vector where positive is knee flexion, and get out a
%   rotation in radians that also has positive flexion. 

% Preallocate
rad = zeros(length(torque),1);

% Apply separate polynomials to flexion (positive) and extension (negative)
rad(torque>=0) = -2.97e-05*(torque(torque>=0).^2)...
                       + 0.0064*torque(torque>=0);
                   
rad(torque<0) = 5.25e-05*(torque(torque<0).^2) + 0.0083*torque(torque<0);
end

