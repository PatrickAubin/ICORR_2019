# ICORR_2019
Open-source code and data associated with 2019 ICORR publication: "A Model-Based Method for Minimizing Reflected Motor Inertia in Off-board Actuation Systems: Applications in Exoskeleton Design".

All code was written in Matlab 2018a. Please email any bugs to Anthony Anderson at ajanders@uw.edu.

ICORR2019_PrimaryScript.m is the script the loads all biomechanical and motor data, performs the optimization algorithm described in the paper, and displays the results. This script currently takes several minutes to run, as it performs 157 independent optimizations using finite differences. The primary script calls all other .m and .mat files in the repository. 
