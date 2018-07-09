function [time,event,timestamps,index_timestamps]=getTimeStampsofEvents(time0,event0)

% obtain the single-time stamps at the starting/triggering time points of the events(5-v signal)(not for a very short time period)

% input: time0 and event0 are the same-size single columns (nX1 data array)
% (event0:5-v signal for a short period of time)
% output: time and event are the same-size single columns (nX1 data array)

k=find(event0>4);  %event signal = 5v
% Time_event1=time0(k(1),1);

% find all other events' starting time
k_switch0=k(1:end-1,1)-k(2:end,1);
kswith=find(abs(k_switch0)>1);
i_kswith=k(kswith+1); % index where new event starts
i_eventS=[k(1);i_kswith];
timestamps=time0(i_eventS,1);  % the time stamps of events
index_timestamps=i_eventS;

time=time0;
event=zeros(size(event0));
event(i_eventS,1)=5;
end



