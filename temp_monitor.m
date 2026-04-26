function temp_monitor(a)
% TEMP_MONITOR Real-time temperature monitoring and LED control for Arduino
% This function realizes continuous temperature monitoring via an LM35 
% sensor,with corresponding LED actuation based on temperature ranges and 
% live plot updates. A while loop ensures persistent operation. Tic/toc
% timers coordinate precise timing:yellow LED blinks at 0.5s intervals 
% (<=18°C), green stays steady (18-24°C), red blinksat 0.25s intervals 
% (>24°C), while the temperature graph refreshes every 1 second without
% blocking LED responses. Input 'a' is the Arduino connection object.
    
    insta_time=[];                                                          %不能用实时的 需要滤波处理
    insta_temp=[];
    last_plot_t = tic;                                                      %this is to use a timer to measure time from last plotted time.
    start_t = tic;                                                          %this is to use a timer to measure time from the beginning.

    while true
        vol=readVoltage(a, "A0");
        temp=(vol-0.5)/0.01;
    
        if temp <=20                                                        %change the temperature range here
            writeDigitalPin(a,"A3",0)
            writeDigitalPin(a,"A5",0)

            writeDigitalPin(a,"A4",1)
            pause(0.5)
            writeDigitalPin(a,"A4",0)
            pause(0.5)
        elseif temp<=35
            writeDigitalPin(a,"A4",0)
            writeDigitalPin(a,"A5",0)

            writeDigitalPin(a,"A3",1)
        else
            writeDigitalPin(a,"A3",0)
            writeDigitalPin(a,"A4",0)
            writeDigitalPin(a,"A5",0)

            writeDigitalPin(a,"A5",1)
            pause(0.25)
            writeDigitalPin(a,"A5",0)
            pause(0.25)
        end
    
    
        if toc(last_plot_t)>=1                                              %plot the graph. when the time detected is larger than the last plotted time, it began to plot again
            current_t = toc(start_t);
            insta_time = [insta_time,current_t];                            %list the x range
            insta_temp = [insta_temp,temp];                                 %list the y range
            xlabel('Time/s')
            ylabel('Temperature/C')
            plot(insta_time,insta_temp);
            xlim([0, max(insta_time)+1]);                                   %set the showing x range
            drawnow;

            last_plot_t = tic;                                              %reset the timer.
        end

        pause(0.02);
    end
end
        

