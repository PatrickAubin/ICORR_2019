function derivative = ICORR2019_derivative(time, func)
% ICORR2019_derivative: Compute a derivative
%   Pass in a time vector and signal to compute the derivative of. Uses a 
%   fourth order central difference scheme. 

%% Setup
n = length(time);
derivative = zeros(size(time));

%% Calculate Derivative
% Use a forward difference scheme for the first two data points.
derivative(1) = (-func(3) + 4*func(2) - 3*func(1))/(time(3)-time(1));
derivative(2) = (-func(4) + 4*func(3) - 3*func(2))/(time(4)-time(2));

% Use a central difference scheme for the middle data points.
for i = 3:n-2
    dt = time(i+1)-time(i);
    derivative(i) = (-func(i+2) + 8*func(i+1) - 8*func(i-1) + func(i-2))/(12*dt);
end

%Use a backward difference scheme for the last two data point.
derivative(n-1) = (3*func(n-1) - 4*func(n-2) + func(n-3))/(2*dt);
derivative(n) = (3*func(n) - 4*func(n-1) + func(n-2))/(2*dt);

end


