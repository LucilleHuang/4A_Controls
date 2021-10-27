
clf reset;
%% Loads in Data from file
Lab1DataNewS4 = readtable('Lab1DataNew.xlsx','Range','A5:E10006', 'ReadRowNames', true, 'Sheet', 'Gain20Sq0.1');

time = table2array(Lab1DataNewS4(:,1));
input = table2array(Lab1DataNewS4(:,2));
angle = table2array(Lab1DataNewS4(:,3));

%% Plots input and response
figure(1);
hold on;
yyaxis left;
plot(time,angle);
ylabel("Velocity [mm/s]");
yyaxis right;
plot(time,input);
ylim([-2 2]);
ylabel("Input [V]");
xlabel("Time [s]");
title("Measured data")
hold off;
%% Finds half-period indices
inputBool = input > 0;
prior = 0;
crossIndices = [];
for x = 1:length(inputBool)
    if prior ~= inputBool(x)
        crossIndices = [crossIndices x];
    end
    prior = inputBool(x);
end
K_v_arr = [];
T_v_arr = [];
for k = 1:length(crossIndices)-1
    %% Selects samples for a single half-period
    startIndex = crossIndices(k);
    stopIndex = crossIndices(k+1)-2;
    size = (stopIndex - startIndex + 1);
    timeSample = time(startIndex:stopIndex);
    %Shifts time to start at 0
    timeSample = timeSample - timeSample(1);
    inputSample = input(startIndex:stopIndex);
    velocitySample = angle(startIndex:stopIndex);
    %Shifts response to start at 0, and makes positive
    velocitySample = abs(velocitySample - velocitySample(1));
    
    %% Calculates steady state value
    % 1% criterion
    tol = 0.01;
    settle = velocitySample(1);
    i = size;
    while abs(velocitySample(i)-velocitySample(i-1))/velocitySample(i) < tol
        i = i-1;
    end
    settleIndex = i;
    %disp(timeSample(settleIndex))
    %Steady value within 1%
    settleValue = mean(velocitySample(settleIndex:size));
    %Gain calcuation
    K_v = settleValue / (abs(inputSample(size)) * 2);
    K_v_arr = [K_v_arr K_v];
    
    %% Plots out the response for a single half-period
    figure(2);
    hold on;
    plot(timeSample,velocitySample);
    yline(settleValue, '--r');
    ylabel("Normalized Velocity [mm/s]");
    xlabel("Normalized Time [s]");
    title("Comparison of all half-period responses");
    hold off;
    
    %% Calculates T_v using percent response
    T_v_n_arr = [];
    %Given from course notes for % response for periods of T_v
    p = [1 2 3 4; 0.63 0.86 0.95 0.98];
    for con = p
        crossIndex = find(velocitySample>con(2)*settleValue,1);
        T_v_n = (timeSample(crossIndex)-timeSample(1))/con(1);
        T_v_n_arr = [T_v_n_arr T_v_n];
    end
    %Averages out 4 T_v values for each percentage
    T_v = mean(T_v_n_arr);
    T_v_arr = [T_v_arr T_v];
    %pause
end

disp(K_v_arr)
disp(T_v_arr)

disp(mean(K_v_arr))
disp(mean(T_v_arr))

%% Calculating Kv and Tv from overshoot
overshoot = (max(velocitySample) - settleValue)/settleValue;
zeta = -log(overshoot)/sqrt(pi^2+(overshoot)^2);
Tp = timeSample(find(velocitySample==max(velocitySample)))
