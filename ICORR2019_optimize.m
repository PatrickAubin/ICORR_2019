function optimizationResults = ICORR2019_optimize(motorData, optimSetup)
%ICORR2019_optimize Optimize over every motor
%   This function carries out the optimization shown in Figure 1, over
%   every motor in the catalog. 

%% Unpackage Options

% Options that get passed to fmincon()
options = optimSetup.options;

% Bounds on design variables
lb = optimSetup.lb;
ub = optimSetup.ub;

% Seed for optimizer
r0 = optimSetup.r0;

% Get the number of motors
motorNum = length(motorData);

%% Perform Optimizations

% Within this for-loop, we'll run an optimization over every unique motor.
for i = 1:motorNum
    
    % Define an anonymous function so that we can pass the cost function to
    % the optimization algorithm. This function is redefined for each
    % motor.
    costFunc = @(r) ICORR2019_costFunction(r, motorData(i));
    
    % Set up an anonymous function so that we can pass the constraints to
    % the optimzation algorithm. The constraints are also updated to be
    % specific for each motor.
    constrFunc = @(r) ICORR2019_constraints(r,...
                                            motorData(i));
    
    % Pass the cost function, constraints, and options to the optimization
    % algorithm. Algorithm will return a vector of design variables (in
    % optimVars), the reflected inertia of the system with the optimal
    % variables (reflIm), and an exit flag (exitFlag). If exitFlag is -2,
    % the motor could not meet the constraints. 
   
    [optimalDesignVariables(:,i),...
     reflectedInertia(i),...
     exitFlag(i)] = fmincon(costFunc,...        % Cost function
                            r0,...              % Seed for optimization
                            [],[],[],[],...     % Unused inputs
                            lb,ub,...           % Bounds on variables
                            constrFunc,...      % Constraints
                            options);           % Options
end

%% Package Everything Up In a Struct

optimizationResults.optimalDesignVariables = optimalDesignVariables;
optimizationResults.reflectedInertia = reflectedInertia;
optimizationResults.exitFlag = exitFlag;

end

