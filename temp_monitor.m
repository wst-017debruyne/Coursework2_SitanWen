% TEMP_MONITOR Real-time temperature monitoring and LED control for Arduino
% This function realizes continuous temperature monitoring via an LM35 
% sensor,with corresponding LED actuation based on temperature ranges and 
% live plot updates. A while loop ensures persistent operation. Tic/toc
% timers coordinate precise timing:yellow LED blinks at 0.5s intervals 
% (<=18°C), green stays steady (18-24°C), red blinksat 0.25s intervals 
% (>24°C), while the temperature graph refreshes every 1 second without
% blocking LED responses. Input 'a' is the Arduino connection object.
function temp_monitor(a)
    insta_time=[];                                                         
    insta_temp=[];
    last_plot_t = tic;                                                      %this is to use a timer to measure time from last plotted time.
    start_t = tic;                                                          %this is to use a timer to measure time from the beginning.

    temp = 0;

    circ = 0;

    while circ<=1
        % pause(0.02);  
        vol = readVoltage(a,"A0");
        temp=(vol-0.5)/0.01;
        disp(temp)

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


    
        if temp <=30                                                        %change the temperature range here
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
            pause(1)
        else
            writeDigitalPin(a,"A3",0)
            writeDigitalPin(a,"A4",0)
            writeDigitalPin(a,"A5",0)

            writeDigitalPin(a,"A5",1)
            pause(0.25)
            writeDigitalPin(a,"A5",0)
            pause(0.25)
            writeDigitalPin(a,"A5",1)
            pause(0.25)
            writeDigitalPin(a,"A5",0)
            pause(0.25)
        end
    
        % pause(0.98);
        circ = 0;
    end
end
        

