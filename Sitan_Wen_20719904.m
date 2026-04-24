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


% a= arduino;
%% TASK 1 - READ TEMPERATURE DATA, PLOT, AND WRITE TO A LOG FILE [20 MARKS]
disp('Task 1')
disp('(b)')
duration = 60;                                                             %记得改成600s!!!!!!!!

all_temper = [];
record = zeros(2, 0);                                                       
for n = 1:duration                                                          %read the voltage and transmit it into temperature
    voltage = readVoltage(a, 'A0');
    temperature = (voltage-0.5)/0.01;
    all_temper = [all_temper, temperature];
    disp(temperature)
    judgement = floor(n/60);
    if (n/60)-judgement ==0                                                 %写到这里了 继续改记得
        temp= [judgement, temperature];
        record= [record; temp];

    end
    pause(1);
end

max_temp = max(all_temper); 
min_temp = min(all_temper);
aver_temp = mean(all_temper);
fprintf('The maximum temperature: %.2f.\n', max_temp);
fprintf('The minimum temperature: %.2f.\n', min_temp);
fprintf('The average temperature: %.2f.\n', aver_temp);


disp('c')
disp('The graph has been plotted.')
x= linspace(0,duration-1,duration);                                                       %注意这里随着时间改变也要改!lo
plot(x, all_temper)
xlabel('Time/s')
ylabel('Temperature ^\circ C');

disp('(d)')
t=datetime('now','Format','MM/dd/uuuu');
location= input('Please input the location Name: ','s');
fprintf('\n');

text = fopen('capsule_temperature.txt', 'w');                               %open the txt file

fprintf2(text,'Data logging initiated - %s \n',t);                          %Print the instant result at the specific minute
fprintf2(text,'Location- %s\n',location);
fprintf2(text,'\n');

width = 15;
for dat = 1:size(record,1)
    time = record(dat, 1);
    spe_temper = record(dat, 2);

    fprintf2(text,'%-*s %.2f\n', width, 'Minute:', time);
    fprintf2(text,'%-*s %.2f C\n', width, 'Temperature:', spe_temper);
    fprintf2(text,'\n')
end

fprintf2(text,'%-*s %.2f C\n', width, 'Max temp ', max_temp);
fprintf2(text,'%-*s %.2f C\n', width, 'Min temp ', min_temp);
fprintf2(text,'%-*s %.2f C\n', width, 'Average temp ', aver_temp);
fprintf2(text,'\n')

fprintf2(text,'Data logging terminated.\n')

fclose(text);                                                               %close the txt file


function fprintf2(text, varargin)
     fprintf(varargin{:});
     fprintf(text, varargin{:});
end




%% TASK 2 - LED TEMPERATURE MONITORING DEVICE IMPLEMENTATION [25 MARKS] 

% Insert answers here

temp_monitor(a);



%% TASK 3 - ALGORITHMS – TEMPERATURE PREDICTION [30 MARKS]

% Insert answers here


%% TASK 4 - REFLECTIVE STATEMENT [5 MARKS]

% Insert answers here