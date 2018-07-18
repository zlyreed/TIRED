function [EMGRMS_filt,MedianFreq_11]=EMG_medFrq(EMGdata,Fs_EMG,T_average,fftlength)

% EMGtotal=EMG_data;
% time_emg=EMGtotal(:,1); % time in EMG data
% EMGdata=EMGtotal(:,2:end);  % 7 EMG data
% Fs_EMG = 1500; %sampling frequency
% T_average=1; %averaging time 1 seconds
% fftlength=1; %1 seconds of data to perform FFT

tt=(0:length(EMGdata)-1)/Fs_EMG; %time to plot raw data

% filter EMG
HPFc=20;
fNorm = HPFc / (Fs_EMG/2);                   %HPFc cutoff frequency, FsHz sample rate
[b,a] = butter(5, fNorm, 'high'); 
data_filt_EMG = filtfilt(b, a, EMGdata); 

[b,a] = butter(2, [59/(Fs_EMG/2) 61/(Fs_EMG/2)], 'stop'); %60Hz notch filter
data_filt_EMG = filtfilt(b, a, data_filt_EMG); 

[b,a] = butter(2, [119.5/(Fs_EMG/2) 120.5/(Fs_EMG/2)], 'stop'); %120Hz notch filter
data_filt_EMG = filtfilt(b, a, data_filt_EMG); 

[b,a] = butter(2, [179.5/500 180.5/500], 'stop'); %180Hz notch filter
data_filt_EMG = filtfilt(b, a, data_filt_EMG); 

LPFc=450;
fNorm = LPFc / (Fs_EMG/2);                   %HPFc cutoff frequency, FsHz sample rate
[b,a] = butter(5, fNorm, 'low'); 
data_filt_EMG = filtfilt(b, a, data_filt_EMG); 

%spectra analysis
% DataforFFT=EMGdata;
DataforFFT=data_filt_EMG;
%DataforFFT=data_filt_VMG;


window_length=fftlength*Fs_EMG;

for k=1:floor(tt(length(tt))/T_average)-fftlength 
    % for Ax Ay Az of AD_A, AD_B, AD_C, and EMG
    % raw data
    Aseg_raw=EMGdata((k-1)*T_average*Fs_EMG+1:(k-1)*T_average*Fs_EMG+window_length,:);
    %Aseg_raw=VMGdata((k-1)*window_length+1:k*window_length,:);
    
    %Asegtotals=Atotals((k-1)*window_length+1:k*window_length,:);
    %Asegyz=Ayz((k-1)*window_length+1:k*window_length,:);

    %filtered data
    Aseg=DataforFFT((k-1)*T_average*Fs_EMG+1:(k-1)*T_average*Fs_EMG+window_length,:);% 1 second data fft non-overlap
    %Asegtotals_filt=Atotals_filt((k-1)*window_length+1:k*window_length,:);
    %Asegyz_filt=Ayz_filt((k-1)*window_length+1:k*window_length,:);
    %Aseg=data_filt((k-1)*Fs+1:(k-1)*Fs+Fs*2,:);% 2 second data fft, 50% overlap
    %Aseg=data_filt((k-1)*Fs*T_average+1:(k-1)*Fs*T_average+Fs*fftlength,:);% 3 second data fft, 67% overlap
        
    [dataPSD, dataFreq] = pwelch(Aseg,rectwin(window_length),window_length/2,window_length,Fs_EMG,'psd'); % no window, 50% overlapping, window_length=nfft

 
    %RMS of raw EMG & VMG for every second
    EMGRMS(k,:)=rms(Aseg_raw);
    %VMGRMS_totals(k,:)=rms(Asegtotals);
    %VMGRMS_yz(k,:)=rms(Asegyz);
    
    EMGRMS_filt(k,:)=rms(Aseg);
    %VMGRMS_totals_filt(k,:)=rms(Asegtotals_filt);
    %VMGRMS_yz_filt(k,:)=rms(Asegyz_filt);
 

    %median frequency        
    MedianFreq_11(k,:)=medfreq(Aseg, Fs_EMG);
    %MedianFreq_22=medfreq(dataPSD, dataFreq);
    %Result_All_3(k,kk)=MedianFreq;
    
    
%     % peak frequency 
%     [Value_peak,Ind_peak]=max(dataPSD,[],1);
%     PeakFreq(k,:)=dataFreq(Ind_peak);
end
    
