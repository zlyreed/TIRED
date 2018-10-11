%% test mhrv steps using different window size
clear all;
clc;
close all;

%%Initializing mhrv toolbox
mhrv_init [-f/--force];

%% Obtain RRI from Biomonitor output
path=pwd;
load([pwd '\db\mitdb\S22_MVC30_Fatigue1.mat']);
time0=Data{1,1};
RRi=Data{1,14}; %Noraxon Desk Receiver.BIO 1 R-R Interval, ms


%% process the testing data into .dat and .hea file (under db/mitdb)
[ t, sig, Fs ] = rdsamp( 'db/mitdb/S22_MVC30Fatigue1' );

% input
window_minutes=0.2;  % window in minutes
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
figure('NumberTitle','off','Name','ECG')
plot(t, sig(:,ecg_channel))
xlabel('time (s)')
ylabel('ECG (uV)')
xlim([0,round(max(t))+50])

%% ***** Obtain RRi/NNi based on ECG (as a whole signal)****
[ rri, trr, plot_data ] = ecgrr( rec_name); % obtain RR interval

% ##### Approach 1: resampled rri first, and then filtered it to get nni
Freq_resample=50;
T_resample=min(trr):1/Freq_resample:max(trr);
RR_resample=interparc(length(T_resample),trr,rri,'linear');
RRi_resample=RR_resample(:,2);
TRR_resample=RR_resample(:,1);

% Filter RR intervals to produce NN intervals
[nni_ECG, tnn_ECG, pd_filtrr] = filtrr(RRi_resample,TRR_resample);


% % % #### Approach 2: filtered rri, and then resampled it
% %Filter RR intervals to produce NN intervals
% [nni0, tnn0, pd_filtrr] = filtrr(rri, trr);
% 
% Freq_resample=50;
% T_resample=min(tnn0):1/Freq_resample:max(tnn0);
% NN_resample=interparc(length(T_resample),tnn0,nni0,'linear');
% nni=NN_resample(:,2);
% tnn=NN_resample(:,1);

% ### Approach 3: remove "step" in the Biomonitor-output RRi, filtered, and resampled 
[time_sel,RRi_sel]=rmvStep(time0, RRi/1000);
[nni2, tnn2, pd_filtrr2] = filtrr(RRi_sel, time_sel);

Freq_resample=50;
T_resample=min(tnn2):1/Freq_resample:max(tnn2);
NN_resample=interparc(length(T_resample),tnn2,nni2,'linear');
tnn=NN_resample(:,1);
nni=NN_resample(:,2);


% figure(11)
% hold on
% plot(time0, RRi/1000,'c')
% plot(time_sel,RRi_sel,'rx')

% figure (1)
figure('NumberTitle','off','Name','RRi and NNi')
p(1,1)=plot(trr, rri,'b');
hold on
% plot(tnn0, nni0,'k')
p(1,2)=plot(tnn_ECG,nni_ECG, 'k');

p(1,3)=plot(time0,RRi/1000,'c');
p(1,4)=plot(tnn2,nni2,'m');
plot(tnn2,nni2,'mo');
p(1,5)=plot(tnn, nni,'rx');

xlabel('time (s)')
ylabel('RRi (s)')
xlim([0,round(max(t))+50])
legend(p,{'RRi-from ECG','NNi-from ECG(filtered and resampled)','RRi-Biomonitor','NNi-Biomonitor (filtered)','NNi-Biomonitor (filtered and resampled)'})

%% ************* Calculate HRV time and frequency using moving windows ********
% what to use for the HRV analysis
NNI=nni2; % use the RRi from Biomonitor ouput, which was filtered (not resampled yet)
TIME=tnn2;

% NNI=nni; % use the RRi from Biomonitor ouput, which was filtered and resampled
% TIME=tnn;

% NNI=nni_ECG; % use the NNI from ECG (filtered and resampled)
% TIME=tnn_ECG;

%setup windows
totalN=length(NNI);

% windowN=window_minutes*60*Freq_resample; % number of elements in the window
windowN=60;
sizeT=length(1:windowN:totalN-windowN);

% prealloacte tables
hrv_metrics_tables = table;
hrv_Time=table;
hrv_Freq=table;
hrv_NonLinear=table;
hrv_Fragmentation=table;

time_wn=zeros(sizeT,1);

i=0;
for wn=1:windowN:totalN-windowN
    i=i+1;
    
    % nni and corresponding time in the seleceted windows
    nni_window=NNI(wn:wn+windowN,1);
    time_wn(i,1)=TIME(wn,1);
    
    
    % Time Domain metrics
    [hrv_td, pd_time ]= hrv_time(nni_window);
    hrv_Time(i,:)=hrv_td;
    
    % Freq domain metrics
    [hrv_fd, ~, ~,  pd_freq ] = hrv_freq(nni_window);
    hrv_Freq(i,:)=hrv_fd;
    
    %Calcualtes non-linear HRV metrics based on PoincarÃ© plots, detrended fluctuation analysis (DFA) [2]_  and Multiscale Entropy (MSE) [3]_.
    [ hrv_nl, plot_data ] = hrv_nonlinear( nni_window);
    hrv_NonLinear(i,:)=hrv_nl;
    
    
    %Computes HRV fragmentation indices [1]_ of a NN interval time series.
    [ hrv_frag ] = hrv_fragmentation( nni_window );
    hrv_Fragmentation(i,:)=hrv_frag;
    
    %put into table
    hrv_metrics_tables(i,:)=[hrv_td,hrv_fd,hrv_nl,hrv_frag];
    
end


%% ### Plot HRV parameters
code_color0=[1 0 1;0 0 1;1 0 0];
code_color=[code_color0;code_color0;code_color0;code_color0;code_color0];

% ************* plot HRV time **********
hrv_TimeName=hrv_Time.Properties.VariableNames;  % parameter names

fig_name_time='HRV_TimeDomain';
figure('NumberTitle','off','Name',fig_name_time)
hold on
for np=1:length(hrv_TimeName)
    subplot(length(hrv_TimeName),1,np)
    para=eval(['hrv_Time.' hrv_TimeName{1,np}]);
    plot(time_wn,para,'color',code_color(np,:));
    
    lg=legend(hrv_TimeName{1,np});
    set(lg, 'Interpreter', 'none')
    xlim([0,round(max(t))+50])
    clear para
end



% ************ plot HRV frequency **************
hrv_FreqName=hrv_Freq.Properties.VariableNames;

fig_name_frq1='HRV_FrequencyDomain1';
figure('NumberTitle','off','Name',fig_name_frq1)
hold on
size1=length(1:length(hrv_FreqName)-4);
for np=1:length(hrv_FreqName)-4
    subplot(size1,1,np)
    para=eval(['hrv_Freq.' hrv_FreqName{1,np}]);
    plot(time_wn,para,'color',code_color(np,:));
    eg=legend(hrv_FreqName{1,np});
    set(eg, 'Interpreter', 'none')
    xlim([0,round(max(t))+50])
    clear para
end



fig_name_frq2='HRV_FrequencyDomain2';
figure('NumberTitle','off','Name',fig_name_frq2)
hold on
size2=length(length(hrv_FreqName)-3:length(hrv_FreqName));
n2=0;
for np=length(hrv_FreqName)-3:length(hrv_FreqName)
    n2=n2+1;
    subplot(size2,1,n2)
    para=eval(['hrv_Freq.' hrv_FreqName{1,np}]);
    plot(time_wn,para,'color',code_color(np,:));
    eg=legend(hrv_FreqName{1,np});
    set(eg, 'Interpreter', 'none')
    xlim([0,round(max(t))+50])
    clear para
end

% ************ plot HRV nonlinear (Poincaré plot and ellipse fitting) **************
hrv_NonLinearName=hrv_NonLinear.Properties.VariableNames;

fig_name_nl='HRV_NonLinear';
figure('NumberTitle','off','Name',fig_name_nl)
hold on
for np=1:length(hrv_NonLinearName)
    subplot(length(hrv_NonLinearName),1,np)
    para=eval(['hrv_NonLinear.' hrv_NonLinearName{1,np}]);
    plot(time_wn,para,'color',code_color(np,:));
    lg=legend(hrv_NonLinearName{1,np});
    set(lg, 'Interpreter', 'none')
    xlim([0,round(max(t))+50])
    clear para
end

 



% ************ plot HRV fragmentation indices **************
hrv_FragmentationName=hrv_Fragmentation.Properties.VariableNames;

fig_name_nl='HRV_Fragmentation';
figure('NumberTitle','off','Name',fig_name_nl)
hold on
for np=1:length(hrv_FragmentationName)
    subplot(length(hrv_FragmentationName),1,np)
    para=eval(['hrv_Fragmentation.' hrv_FragmentationName{1,np}]);
    plot(time_wn,para,'color',code_color(np,:));
    lg=legend(hrv_FragmentationName{1,np});
    set(lg, 'Interpreter', 'none')
    xlim([0,round(max(t))+50])
    clear para
end


