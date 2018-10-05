%% test mhrv steps using different window size
clear all;
clc;
close all;

%%Initializing mhrv toolbox
mhrv_init [-f/--force];

%% compare RRI from Biomonitor output
path=pwd;
load([pwd '\db\mitdb\S22_MVC30_Fatigue1.mat']);
time0=Data{1,1};
RRi=Data{1,14}; %Noraxon Desk Receiver.BIO 1 R-R Interval, ms


%% process the testing data into .dat and .hea file (under db/mitdb)
[ t, sig, Fs ] = rdsamp( 'db/mitdb/S22_MVC30Fatigue1' );

% input
window_minutes=0.5;  % window in minutes
rec_name='db/mitdb/S22_MVC30Fatigue1';

% Save processing start time
t0 = cputime;

% Get data about the signal from the header
header_info = wfdb_header(rec_name);
ecg_Fs = header_info.Fs;
ecg_N = header_info.N_samples;

% Set length of record based on it
header_info.total_seconds = ecg_N / ecg_Fs;
header_info.duration = seconds_to_hmsms(header_info.total_seconds);

% Get ECG channel number
ecg_channel = get_signal_channel(rec_name, 'header_info', header_info);

% plot ECG data
figure (1)
subplot(2,1,1)
plot(t, sig(:,ecg_channel))
xlabel('time (s)')
ylabel('ECG (uV)')
xlim([0,round(max(t))+50])

%% obtain RRi/NNi based on ECG (as a whole signal)
[ rri, trr, plot_data ] = ecgrr( rec_name); % obtain RR interval

% Filter RR intervals to produce NN intervals
[nni0, tnn0, pd_filtrr] = filtrr(rri, trr);

Freq_resample=50;
T_resample=min(tnn0):1/Freq_resample:max(tnn0);
NN_resample=interparc(length(T_resample),tnn0,nni0,'linear');
nni=NN_resample(:,2);
tnn=NN_resample(:,1);

figure (1)
subplot(2,1,2)
plot(trr, rri,'b')
hold on
plot(tnn0, nni0,'k')
plot(tnn, nni,'rx')
xlabel('time (s)')
ylabel('RRi (s)')
xlim([0,round(max(t))+50])

% %% setup windows
widowN=window_minutes*60*Freq_resample;
totalN=length(nni);
sizeT=length(1:widowN:totalN-widowN);

hrv_metrics_tables = table;
hrv_Time=table;
hrv_Freq=table;
time_wn=zeros(sizeT,1);

i=0;
for wn=1:widowN:totalN-widowN
    i=i+1;
    
    nni_window=nni(wn:wn+widowN,1);
    time_wn(i,1)=tnn(wn,1);
    % Time Domain metrics
    [hrv_td, pd_time ]= hrv_time(nni_window);
    hrv_Time(i,:)=hrv_td;
    
    % Freq domain metrics
    [hrv_fd, ~, ~,  pd_freq ] = hrv_freq(nni_window);
    hrv_Freq(i,:)=hrv_fd;
    
    
    %put into table
    hrv_metrics_tables(i,:)=[hrv_td,hrv_fd];
    
end


code_color0=[1 0 1;0 0 1;1 0 0];
code_color=[code_color0;code_color0;code_color0;code_color0;code_color0];
% plot HRV time
hrv_TimeName=hrv_Time.Properties.VariableNames;
plot_tn=zeros(1,length(hrv_TimeName));

figure(2)
hold on
for np=1:length(hrv_TimeName)
    subplot(length(hrv_TimeName),1,np)
    para=eval(['hrv_Time.' hrv_TimeName{1,np}]);
%     plot_tn(1,np)=plot(time_wn,para,'color',code_color(np,:));
    plot(time_wn,para,'color',code_color(np,:));
    legend(hrv_TimeName{1,np},'interpreter','none');
    clear para
end
% legend(plot_tn,hrv_TimeName);


% plot HRV frequency
hrv_FreqName=hrv_Freq.Properties.VariableNames;
plot_fn=zeros(1,length(hrv_FreqName));

figure(3)
hold on
for np=1:length(hrv_FreqName)
    subplot(length(hrv_FreqName),1,np)
    para=eval(['hrv_Freq.' hrv_FreqName{1,np}]);
   % plot_fn(1,np)=plot(time_wn,para,'color',code_color(np,:));
   plot(time_wn,para,'color',code_color(np,:));
    legend(hrv_FreqName{1,np},'interpreter','none');
    clear para
end
% legend(plot_fn,hrv_FreqName);



%
% % Length of signal in seconds
% t_max = floor(header_info.total_seconds);
%
% % Duration of signal
% duration = header_info.duration;
%
% % Length of each window in seconds and samples (make sure the window is not longer than the signal)
% t_win = min([window_minutes * 60, t_max]);
% window_samples = t_win * ecg_Fs;
%
%
% % Number of windows
% num_win = floor(ecg_N / window_samples);
% if (isnan(num_win))
%     % This can happen in some records where number of samples is not provided
%     num_win = 1;
% end
%
% % % Account for window index offset and limit
% % if (window_index_offset >= num_win)
% %     error('Invalid window index offset: was %d, but there are only %d %d-minute windows',...
% %            window_index_offset, num_win, window_minutes);
% % end
% % window_max_index = min(num_win, window_index_offset + window_index_limit) - 1;
%
% window_max_index=num_win;
%
% % Output initialization
% % hrv_metrics_tables = cell(num_win, 1);
% hrv_metrics_tables = table;
% plot_datas = cell(num_win, 1);
%
% %for curr_win_idx = 1 : window_max_index
% code_color0=[1 0 1;0 0 1;1 0 0];
% code_color=[code_color0;code_color0;code_color0];
%
% for curr_win_idx = 0: window_max_index-1
%
%     % Calculate sample indices of the current window
%     window_start_sample = curr_win_idx * window_samples + 1;
%     window_end_sample   = window_start_sample + window_samples - 1;
%     if (window_end_sample == 0); window_end_sample = []; end
%
%     nni_window=nni([window_start_sample,window_end_sample]);
%
%
%     % Time Domain metrics
%     [hrv_td, pd_time ]= hrv_time(nni_window);
%
%     % Freq domain metrics
%     [hrv_fd, ~, ~,  pd_freq ] = hrv_freq(nni_window);
% %      [hrv_fd2, ~, ~,  pd_freq2 ] = hrv_freq(RRi);
%
%     hrv_metrics_tables(curr_win_idx+1,:)=[hrv_td,hrv_fd];
%
%     figure (1)
%     subplot(2,1,2)
%     hold on
%     plot(trr_window,rri_window,'x','color',code_color(curr_win_idx+1,:))
%     plot(trr_window,rri_window,'color',code_color(curr_win_idx+1,:))
%     plot(tnn_window,nni_window,'x','color',code_color(curr_win_idx+2,:))
%     plot(tnn_window,nni_window,'color',code_color(curr_win_idx+2,:))
%
%
%     xlabel('time (s)')
%     ylabel(' RR interval (s)')
%     xlim([0,round(max(time0))+50])
%
% end
%
% %% compare with Biomonitor RR interval output
% figure(1)
% subplot(2,1,2)
% hold on
% plot(time0,RRi/1000,'c')
% xlim([0,round(max(time0))+50])
%
%
% % %% use RRi output as input to mhrv functions
% % for winI = 0: window_max_index-1
% %      % Calculate sample indices of the current window
% %     window_start_sample = winI * window_samples + 1;
% %     window_end_sample   = window_start_sample + window_samples - 1;
% %     if (window_end_sample == 0); window_end_sample = []; end
% %
% %
% %     [hrv_td, pd_time ]= hrv_time(rri_window);