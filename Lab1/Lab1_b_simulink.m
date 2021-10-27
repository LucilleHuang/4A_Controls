clear all;
clc;
close all;

clf reset;
%% Loads in Data from file
Lab1DataNewS4 = readtable('Lab1DataNew.xlsx','Range','A5:E10006', 'ReadRowNames', false, 'Sheet', 'Gain20Sq0.1-2');

time = table2array(Lab1DataNewS4(:,1));
input = table2array(Lab1DataNewS4(:,2));
angle = table2array(Lab1DataNewS4(:,3));

%% Simulink
% C(s)
Kp = -20;

% Moter system model
K1 =  -2.2559;
tau_s = 0.0231;

% gear_gain = -0.739752175491130;
% gear_offset = -5.9790;
gear_gain = 1;
gear_offset = 0;

% run simulink and plot
use_signal_generator = 0;
open('System7b.slx');
simulation = sim('System7b.slx');

theta_ref = simulation.get('theta_ref');
assignin('base','theta_ref',theta_ref);

theta_ref_sat = simulation.get('theta_ref_sat');
assignin('base','theta_ref_sat',theta_ref_sat);

theta_t = simulation.get('theta_t');
assignin('base','theta_t',theta_t);

plot(time, input, ...
    theta_t.time, theta_t.data, ...
    time, angle)
legend("input", "sim\_out", "exp\_out", 'lineWidth', 1);
ylim([-0.15,0.15]);
title('Simulated and Experimental Output');
xlabel('time(s)'); 
ylabel('angles(rad)');

use_signal_generator = 1;
open('System7b.slx');
simulation = sim('System7b.slx');

theta_ref = simulation.get('theta_ref');
assignin('base','theta_ref',theta_ref);

theta_ref_sat = simulation.get('theta_ref_sat');
assignin('base','theta_ref_sat',theta_ref_sat);

theta_t = simulation.get('theta_t');
assignin('base','theta_t',theta_t);

figure
plot(theta_ref.time, theta_ref.data, ...
     theta_ref_sat.time, theta_ref_sat.data, ... 
     theta_t.time, theta_t.data, ...
     'lineWidth', 1); % plot angle versus time
ylim([-1.1,1.1]);
xlim([0,10]);
title('Effect of Saturator');
xlabel('time(s)'); 
ylabel('angles(rad)');
legend("theta\_ref", "theta\_ref\_sat", "theta\_t");
legend('Location','northwest')
