% Sitan Wen
% ssysw21@nottingham.edu.cn

if ~exist('a', 'var') || ~isa(a, 'arduino')                                 %check whether a=arduino exists.
    clear a;                   
    a = arduino();               
    disp('Arduino connection established.');
end

ques = input(['Please input the question you wanna check: \n 0--preliminary' ...
    ' task \n 1--Task 1\n 2--Task 2\n 3-- Task 3\n']);
switch ques
    case 0
%% PRELIMINARY TASK - ARDUINO AND GIT INSTALLATION [5 MARKS]

    writeDigitalPin(a,'D3',0)

    for t=0:100 
        writeDigitalPin(a,'D4',1)
        pause(0.5)
        writeDigitalPin(a,'D4',0)
        pause(0.5)
    end
    case 1 
%% TASK 1 - READ TEMPERATURE DATA, PLOT, AND WRITE TO A LOG FILE [20 MARKS]
        disp('Task 1')
        disp('(b)')
        duration = 600;                                                     %set the duration time as 600s, 10 minutes.                                             

        all_temper = [];
        record = zeros(2, 0);                                                       
        for n = 0:duration                                                    %read the voltage and transmit it into temperature
            voltage = readVoltage(a, 'A0');
            temperature = (voltage-0.5)/0.01;
            all_temper = [all_temper, temperature];
            % disp(temperature)
            judgement = floor(n/60);
            if (n/60)-judgement ==0                                         %judge whether the data need to be recorded                                  
                temp= [judgement, temperature];
                output = sprintf(['The recorded temperature at %ds ' ...
                    'is %.2f.'],n,temperature);
                disp(output);
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
        x= linspace(0,duration,duration+1);                                  
        plot(x, all_temper)
        xlabel('Time/s')
        ylabel('Temperature ^\circ C');

        disp('(d)')
        t=datetime('now','Format','MM/dd/uuuu');
        location= input('Please input the location Name: ','s');
        fprintf('\n');

        text = fopen('capsule_temperature.txt', 'w');                       %open the txt file

        fprintf2(text,'Data logging initiated - %s \n',t);                  %Print the instant result at the specific minute
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

        fclose(text);                                                       %close the txt file

    case 2
%% TASK 2 - LED TEMPERATURE MONITORING DEVICE IMPLEMENTATION [25 MARKS] 
        temp_monitor(a);
    case 3
%% TASK 3 - ALGORITHMS – TEMPERATURE PREDICTION [30 MARKS]
        temp_prediction(a);

    otherwise
        disp('please input number from 0 to 3')
end

function fprintf2(text, varargin)                                           %This is the function for Task 1. Listing here is to avoid conflicts with the switch function
     fprintf(varargin{:});
     fprintf(text, varargin{:});
end

%% TASK 4 - REFLECTIVE STATEMENT [5 MARKS]
% In Coursework 2, the theoretical knowledge acquired in lectures was 
% applied to a practical scenario for the first time. All assigned tasks 
% were completed successfully. However, several challenges emerged during 
% the coding process. One notable issue was the fluctuation in temperature 
% readings observed while the program was running. Additionally, organising
%  the wiring harnesses posed an initial difficulty, particularly in 
% making the physical connections clearer and more systematic.
% 
% Understanding the underlying logic of the required code also presented 
% a significant challenge before writing could commence. It was necessary 
% to identify the most efficient, concise, and comprehensible approach and 
% translate it into functional code. Fortunately, logical structuring 
% proved to be a personal strength; the use of flowcharts enabled rapid 
% development of the algorithmic framework. Nevertheless, translating these
% flowcharts into executable code introduced further difficulties. Certain
% logical sequences had to be modified during implementation, resulting in
% a final program that diverged from the original flowchart in 
% several aspects.
% 
% After completing the program, some hardware-related issues became 
% apparent. Specifically, in Task 3, it was observed that LED state 
% transitions induced voltage fluctuations, which periodically distorted 
% the temperature readings. Even under thermally stable conditions, the 
% measured values oscillated beyond the classification threshold, causing 
% spurious state toggling. Moreover, the steady illumination of an LED 
% introduced a systematic offset in the measured temperature relative to 
% the LED-off condition. Both effects are attributed to power-supply 
% coupling inherent in the experimental hardware and are not indicative 
% of algorithmic deficiencies.
% 
% For future improvements, it is recommended that more precise 
% instrumentation be employed, or that appropriate capacitance be added 
% to the circuit to stabilise the supply voltage and mitigate these 
% coupling effects.





