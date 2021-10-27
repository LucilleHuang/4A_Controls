%Stiction CCW: -0.480 V
%Stiction CW: 0.480 V
% -45 degrees: 3.764 V
% 0 degrees: 4.325
% 45 degrees: 4.901
rads = [-0.785398163397448;0;0.785398163397448];
volts = [3.764000000000000; 4.325000000000000; 4.901000000000000];
%linreg stuff
voltsAug = [ones(3,1) volts];
linreg = voltsAug\rads;
gain = linreg(2);
offset = linreg(1) / gain;

%Closed loop with unity feedback
%Gain = 1, Issues with the stiction block, gearAng doesn't reach desired value,
%steady state error. Motor voltage fluctuates between 
%Steady state error reduced by using a higher gain (5), still present
%
