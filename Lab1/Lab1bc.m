%Stiction CCW: -0.480 V
%Stiction CW: 0.480 V
% -45 degrees: 3.764 V
% 0 degrees: 4.325
% 45 degrees: 4.901
rads = [-0.785398163397448;0;0.785398163397448];
%volts = [3.764000000000000; 4.325000000000000; 4.901000000000000];%Edward
volts = [4.8; 4.25; 3.7];%Lucille
%linreg stuff
voltsAug = [ones(3,1) volts];
linreg = voltsAug\rads;
gain = linreg(2);
offset = linreg(1) / gain;

rads = [-pi/4, 0, pi/4];
volts = [3.7; 4.25; 4.8];%Lucille
%solve gain*(rads+offset)=volts get:
%gain = -0.7003
%offset = -6.0688
%solve with linreg:
%gain =1.428;
%offset = -4.25;

%Closed loop with unity feedback
%Gain = 1, Issues with the stiction block, gearAng doesn't reach desired value,
%steady state error. Motor voltage fluctuates between 
%Steady state error reduced by using a higher gain (5), still present
%

