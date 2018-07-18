function [AccelerationRMS_filt,MedianFreq_11]=Acceleration_medFrq(Accelerationdata,Fs_Acceleration,T_average,fftlength)

% Accelerationtotal=Acceleration_data;
% time_Acceleration=Accelerationtotal(:,1); % time in Acceleration data
% Accelerationdata=Accelerationtotal(:,2:end);  % 7 Acceleration data
% Fs_Acceleration = 1500; %sampling frequency
% T_average=1; %averaging time 1 seconds
% fftlength=1; %1 seconds of data to perform FFT

tt=(0:length(Accelerationdata)-1)/Fs_Acceleration; %time to plot raw data

% filter Acceleration
HPFc=2;
fNorm = HPFc / (Fs_Acceleration/2);                   %HPFc cutoff frequency, FsHz sample rate
[b,a] = butter(5, fNorm, 'high'); 
data_filt = filtfilt(b, a, Accelerationdata); 

LPFc=100;
fNorm = LPFc / (Fs_Acceleration/2);                   %HPFc cutoff frequency, FsHz sample rate
[b,a] = butter(5, fNorm, 'low'); 
data_filt = filtfilt(b, a, data_filt); 

[b,a] = butter(2, [59/(Fs_Acceleration/2) 61/(Fs_Acceleration/2)], 'stop'); %60Hz notch filter
data_filt_Acceleration= filtfilt(b, a, data_filt); 

%spectra analysis
% DataforFFT=Accelerationdata;
DataforFFT=data_filt_Acceleration;
%DataforFFT=data_filt_VMG;


window_length=fftlength*Fs_Acceleration;

for k=1:floor(tt(length(tt))/T_average)-fftlength 
    % for Ax Ay Az of AD_A, AD_B, AD_C, and Acceleration
    % raw data
    Aseg_raw=Accelerationdata((k-1)*T_average*Fs_Acceleration+1:(k-1)*T_average*Fs_Acceleration+window_length,:);
    %Aseg_raw=VMGdata((k-1)*window_length+1:k*window_length,:);
    
    %Asegtotals=Atotals((k-1)*window_length+1:k*window_length,:);
    %Asegyz=Ayz((k-1)*window_length+1:k*window_length,:);

    %filtered data
    Aseg=DataforFFT((k-1)*T_average*Fs_Acceleration+1:(k-1)*T_average*Fs_Acceleration+window_length,:);% 1 second data fft non-overlap
    %Asegtotals_filt=Atotals_filt((k-1)*window_length+1:k*window_length,:);
    %Asegyz_filt=Ayz_filt((k-1)*window_length+1:k*window_length,:);
    %Aseg=data_filt((k-1)*Fs+1:(k-1)*Fs+Fs*2,:);% 2 second data fft, 50% overlap
    %Aseg=data_filt((k-1)*Fs*T_average+1:(k-1)*Fs*T_average+Fs*fftlength,:);% 3 second data fft, 67% overlap
        
    [dataPSD, dataFreq] = pwelch(Aseg,rectwin(window_length),window_length/2,window_length,Fs_Acceleration,'psd'); % no window, 50% overlapping, window_length=nfft

 
    %RMS of raw Acceleration & VMG for every second
    AccelerationRMS(k,:)=rms(Aseg_raw);
    %VMGRMS_totals(k,:)=rms(Asegtotals);
    %VMGRMS_yz(k,:)=rms(Asegyz);
    
    AccelerationRMS_filt(k,:)=rms(Aseg);
    %VMGRMS_totals_filt(k,:)=rms(Asegtotals_filt);
    %VMGRMS_yz_filt(k,:)=rms(Asegyz_filt);
 

    %median frequency        
    MedianFreq_11(k,:)=medfreq(Aseg, Fs_Acceleration);
    %MedianFreq_22=medfreq(dataPSD, dataFreq);
    %Result_All_3(k,kk)=MedianFreq;
    
%     
%     % peak frequency 
%     [Value_peak,Ind_peak]=max(dataPSD,[],1);
%     PeakFreq(k,:)=dataFreq(Ind_peak);
end
    
