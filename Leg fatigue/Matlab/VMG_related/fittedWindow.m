function window_struc=fittedWindow(t,y,Window_Time,step,order)

% t: total time
% y: corresponding values
% window: selected time range [t1,t2]
% step: time interval within the selected window, e.g., step=0.1 second
% order: fitted polynomial function, e.g., order=1

% find the selected time range
ind=find(t>=Window_Time(1,1)&t<=Window_Time(1,2));
t_window=t(ind);
y_window=y(ind);
t_window_fitted=min(Window_Time):step:max(Window_Time);

p1 = polyfit(t_window,y_window,order);
y_window_fitted = polyval(p1,t_window_fitted);


window_coeff=p1;

window_Ave=mean(y_window);
window_SD=std(y_window);

window_struc=struct('time_fitted',t_window_fitted,'signal_fitted',y_window_fitted,'coefficients_function',window_coeff,'window_mean',window_Ave,'window_SD',window_SD);

