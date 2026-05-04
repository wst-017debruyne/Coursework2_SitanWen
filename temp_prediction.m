%Task 3
function temp_prediction(a)
% TEMP_PREDICTION Predictive temperature monitoring and LED control for Arduino
% This function continuously reads an analog temperature sensor on pin A0,
% computes the rate of temperature change, and predicts the temperature
% 300 seconds ahead. Two averaged temperature readings (5 samples each, 
% 0.2 s apart) are taken 1.2 s apart to calculate the rate. Based on the
% rate, the system classifies the trend: cooling (rate < -0.0667 °C/s), 
% stable (-0.0667 ≤ rate ≤ 0.0667), or heating (rate > 0.0667). Three LEDs
% (A4=cooling, A3=stable, A5=heating) are updated only when the state 
% changes, with all LEDs reset before switching. The loop runs forever.
% Input 'a' is the Arduino connection object.


temp_box = [];                                                              %This is to save the temperature
temp_rate = [];                                                             %This is to save the temperature changing rate
% repeat = 0;
status_box =[];
circ =0;
total_temp=[];                                                              %check the fluctuation

while circ == 0
    repeat = 0;
    while repeat<1
        while size(temp_box,1) <2                                           %use size of the matrix to judge whether enough temperature was obtained to calculate the changing rate. 
            temp_t=[];
            for i =1:5
                vol = readVoltage(a, "A0");
                t = (vol-0.5)/0.01;
                
                total_temp = [total_temp,t];                                %check the fluctuation
                x=1:length(total_temp);
                plot(x,total_temp);
                disp(t);

                temp_t = [temp_t,t];
                pause(0.2)
            end
            temp = median(temp_t);                                          %use the mean value of temperature in one second to minimize the influence of temperature fluctuation.
            % vol = readVoltage(a, "A0");
            % temp = (vol-0.5)/0.01;
            temp_box = [temp_box;temp];
            % disp(temp)
            % pause(1)                                                        %set an time distance 2s
        end
    
        T1 = temp_box(1,1);
        T2 = temp_box(2,1);
        delta_temp = (T2-T1)/1;                                             %use the temperature changing in 2s to calculate the rate.
        temp_rate = [temp_rate;delta_temp];
        
        if size(temp_rate,1)<2                                              %use size of the matrix to judge whether enough changing rate was obtained to compare the status. 
            temp_box = T2;                                                  %clear the temperature matrix to do a new temperature collection.
            repeat = 0;
        else 
            temp_box = T2;
            repeat = 1;  
        end
        
    end

    % delta_t1 = temp_rate(1,1);
    delta_t2 = temp_rate(2,1);
    temp_pred = T2+delta_t2*300;
    fprintf(['Real time temperature is: %.2f. Temperature expected ' ...
        'in 5 mintues: %.2f.\n'],T2, temp_pred)                             %print the real time temperature and predicted temperature in 5 minutes.

    % disp(temp_rate)
    
    for n = 1: size(temp_rate,1)
        i = temp_rate(n,1);
        if i < -4/60                                                        %the unit of changing rate is C/s, so the boundary value 4 C/min should be substituded by 4/60 C/s.
            status = 0;                                                     %use status to judge and control the light
            status_box = [status_box;status];
        elseif i <= 4/60
            status = 1;
            status_box = [status_box;status];
        else
            status = 2;
            status_box = [status_box;status];
        end
    end

    % disp(status_box)

    delta_status1 = status_box(1,1);
    delta_status2 = status_box(2,1);

    if delta_status2 ~= delta_status1                                       %compare the status of the temperature in two different time to judge whether the light should be switched off first. 
        writeDigitalPin(a,'A2',0)
        writeDigitalPin(a,'A4',0)
        writeDigitalPin(a,'A5',0)
    end

    if delta_status2 ==0                                                    %use the status to switch on different lights
        writeDigitalPin(a,'A4',1)
    elseif delta_status2 ==1
        writeDigitalPin(a,'A2',1)
    else
        writeDigitalPin(a,'A5',1)
    end


    temp_rate = temp_rate(2, 1); 
    % disp(temp_rate)
    circ = 0;
    status_box =[];
    pause(2)                                                              %this pause is cirtical for stablizing the voltage reading
end










