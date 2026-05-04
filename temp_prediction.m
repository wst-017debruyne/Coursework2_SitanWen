% TEMP_PREDICTION performs continuous temperature monitoring using an 
% analog sensor on pin A0. The rate of temperature change is estimated 
% from two successive averaged readings, each comprising five samples taken
% at 0.1 s intervals and separated by 0.5 s. The trend is classified as 
% cooling (< -0.0667 °C/s), stable (±0.0667 °C/s), or heating 
% (> 0.0667 °C/s), and a 300-second-ahead prediction is obtained by linear 
% extrapolation. LEDs connected to A4 (cooling), A3 (stable), and A5 
% (heating) are updated only when the classified state changes, with all 
% outputs reset beforehand. State evaluation is decoupled from sensing 
% and performed at 2-second intervals to minimise interference.
% Two hardware-related issues were observed during testing. First,
% LED state transitions induce voltage fluctuations that periodically
% distort the temperature readings; even under stable thermal conditions,
% the measured value oscillates beyond the classification threshold,
% causing spurious state toggling. Second, the steady illumination of an
% LED introduces a systematic offset in the measured temperature compared
% to the LED-off condition. Both effects are attributed to power-supply
% coupling inherent in the experimental hardware and are not indicative
% of algorithmic deficiencies.
function temp_prediction(a)

temp_box = [];                                                              %This is to save the temperature
temp_rate = [];                                                             %This is to save the temperature changing rate
% repeat = 0;
status_box =[1;1];
circ =0;
total_temp=[];                                                              %check the fluctuation
time = 0;

writeDigitalPin(a,'A3',0)
writeDigitalPin(a,'A4',0)
writeDigitalPin(a,'A5',0)

while circ == 0
    repeat = 0;
    while repeat<1
        while size(temp_box,1) <2                                           %use size of the matrix to judge whether enough temperature was obtained to calculate the changing rate. 
            temp_t=[];
            for i =1:5
                vol = readVoltage(a, "A0");
                t = (vol-0.5)/0.01;
                temp_t = [temp_t,t];
                pause(0.2)
            end
            time=time+1;
            temp = median(temp_t);                                          %use the mean value of temperature in one second to minimize the influence of temperature fluctuation.
            temp_box = [temp_box;temp];
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
    
    if time/2-floor(time/2)==0                                                  %use two seconds as light judgement interval. This is t avoid the condition of temperature fluctuation caused by light status change.
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
    
        delta_status1 = status_box(end-2,1);
        delta_status2 = status_box(end,1);

        delta_t2 = temp_rate(2,1);
        temp_pred = T2+delta_t2*300;
        disp(delta_temp);
        fprintf(['Real time temperature is: %.2f. Temperature expected ' ...
            'in 5 mintues: %.2f.\n'],T2, temp_pred)                             %print the real time temperature and predicted temperature in 5 minutes.

        if delta_status2 ~= delta_status1                                       %compare the status of the temperature in two different time to judge whether the light should be switched off first. 
            writeDigitalPin(a,'A3',0)
            writeDigitalPin(a,'A4',0)
            writeDigitalPin(a,'A5',0)
        end

        if delta_status2 ==0                                                    %use the status to switch on different lights
            writeDigitalPin(a,'A4',1)
        elseif delta_status2 ==1
            writeDigitalPin(a,'A3',1)
        else
            writeDigitalPin(a,'A5',1)
        end
    end   

    temp_rate = temp_rate(2, 1);    
    circ = 0;
    % pause(2)                                                                %this pause is for stablizing the voltage reading
end










