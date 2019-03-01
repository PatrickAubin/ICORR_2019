function optimSetup = ICORR2019_optimizationSetup()
%ICORR2019_optimizationSetup Prepare a struct of optimization setup info
%   Configure a struct that contains optimization options, bounds on design
%   variables, and an initial seed point.

%% Set General Optimization Options

% Setup the general options to be used by the optimizer.
options = optimoptions('fmincon',...                         
                       'FiniteDifferenceStepSize',1e-10,...
                       'MaxFunctionEvaluations',10000,...
                       'MaxIterations',10000,...
                       'SpecifyObjectiveGradient',true);
                   
%% Set Bounds on Design Variables

% Now we'll set up bounds on the optimization variables. First determine
% the minimum knee moment arm to prevent high cable forces.
peakKneeMoment = 49.57;     % Nm, maximum value of knee moment trajectory
maxCableForce = 2200;       % N, maximum cable force allowable

% Define the lower bound for the knee radius to prevent excessively high
% cable forces. 
minKneeMomArm = peakKneeMoment/maxCableForce;

% Set the lower and upper bounds on the design variables. 
lb = [minKneeMomArm;    % lower bound on exoskeleton joint radius 
      0.013];           % lower bound on motor sheave
  
ub = [0.08;             % upper bound on exoskeleton joint radius 
      1];               % upper bound on motor sheave
  
% Note, the upper bound on the motor sheave isn't necessarily 1 meter. It
% can be set to any high value, but the algorithm will select smaller
% values. We set it to 1 above to speed up the algorithm. 

%% Seed Point

% Set up a seed point for the optimization. Choose the center point of the
% bounds on the design variables. 
r0 = 0.5*(lb+ub);

%% Package Everything in a Struct
optimSetup.options = options;
optimSetup.lb = lb;
optimSetup.ub = ub;
optimSetup.r0 = r0;

end

