% Sitan Wen
% ssysw21@nottingham.edu.cn


%% PRELIMINARY TASK - ARDUINO AND GIT INSTALLATION [5 MARKS]

    % writeDigitalPin(a,'D3',0)

    % for t=0:100 
    %     writeDigitalPin(a,'D4',1)
    %     pause(0.5)
    %     writeDigitalPin(a,'D4',0)
    %     pause(0.5)
    % end



%% TASK 1 - READ TEMPERATURE DATA, PLOT, AND WRITE TO A LOG FILE [20 MARKS]
disp('Task 1')
disp('(b)')
duration = 600;                                                             %记得改成600s!!!!!!!!

all_temper = [];
record = zeros(2, 0);                                                       %这里是记录的集合变量
for n = 1:duration
    voltage = readVoltage(a, 'A0');
    temperature = (voltage-0.5)/0.01;
    all_temper = [all_temper, temperature];
    disp(temperature)
    judgement = floor(n/60);
    if (n/60)-judgement ==0                                                 %写到这里了 继续改记得


    end
    pause(1);
end
            
max_temp = max(all_temper); 
min_temp = min(all_temper);
aver_temp = mean(all_temper);
fprintf('The maximum temperature: %.4f.\n', max_temp);
fprintf('The minimum temperature: %.4f.\n', min_temp);
fprintf('The average temperature: %.4f.\n', aver_temp);


disp('c')
x= linspace(0,599,600);
plot(x, all_temper)
xlabel('Time/s')
ylabel('Temperature ^\circ C');






%% TASK 2 - LED TEMPERATURE MONITORING DEVICE IMPLEMENTATION [25 MARKS] 

% Insert answers here


%% TASK 3 - ALGORITHMS – TEMPERATURE PREDICTION [30 MARKS]

% Insert answers here


%% TASK 4 - REFLECTIVE STATEMENT [5 MARKS]

% Insert answers here