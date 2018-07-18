function EMGFeatureTable=extractEMGFeatures(EMGData,RPETable,Fs_EMG,T_average,fftlength)

% EMGData=EMG_data;
% RPETable=RPE_ClassTable;
% Fs_EMG=1500;  % EMG frequency = 1500
% T_average=1; %averaging time 1 seconds
% fftlength=1; %1 seconds of data to perform FFT

Time_emg=EMGData(:,1);  % time in EMG data
EMGdata=EMGData(:,2:end); %7 EMG data

% EMGdata( :, ~any(EMGdata,1) ) = [];   % remove the coloumn with zeros; e.g. down to 5 EMG channels


nWindows=size(RPETable,1); % the number of widowns selected in RPE data
for kw=1:nWindows
    startingTime=RPETable{kw,1};
    endingTime=RPETable{kw,2};
    
    kt=find(Time_emg>=startingTime &Time_emg<=endingTime);
    if isempty(kt)==0  % find matched time range
        time_selected=Time_emg(kt,1);
        timeOffset=max(time_selected)-min(time_selected)-(endingTime-startingTime);
        
        EMG_selected=EMGdata(kt,:);
        
        EMGraw_mean=mean(EMG_selected);
        EMGraw_median=median(EMG_selected);
        EMGraw_std=std(EMG_selected);
        EMGraw_meanAbs=mad(EMG_selected);        
        
        % FFT 
       [EMGRMS_filt,MedianFreq_11]=EMG_medFrq(EMG_selected,Fs_EMG,T_average,fftlength);
        
        for eN=1:size(EMG_selected,2) 
            eval(['EMG.EMG' num2str(eN) '_rawMean(kw,1)=EMGraw_mean(1,eN);']); % 7 EMG
            eval(['EMG.EMG' num2str(eN) '_rawMedian(kw,1)=EMGraw_median(1,eN);']); % 7 EMG
            eval(['EMG.EMG' num2str(eN) '_rawSTD(kw,1)=EMGraw_std(1,eN);']); % 7 EMG
            eval(['EMG.EMG' num2str(eN) '_rawmeanAbs(kw,1)=EMGraw_meanAbs(1,eN);']); % 7 EMG
            
            eval(['EMG.EMG' num2str(eN) '_rms(kw,1)=mean(EMGRMS_filt(:,eN));']); % 7 EMG
            eval(['EMG.EMG' num2str(eN) '_medianFrq(kw,1)=mean(MedianFreq_11(:,eN));']);  % 7 EMG
%             eval(['EMG.EMG' num2str(eN) '_peakFrq(kw,1)=mean(PeakFreq(:,eN));']);  % 7 EMG            
        end
              
        EMG.timeOffset(kw,1)=timeOffset;              
        
    else
        EMG.timeOffset(kw,1)=endingTime-startingTime;
        
    end
end


EMGFeatureTable=struct2table(EMG);

%
% EMG_length=length(EMG_DATA);
%
% T_average=1; %averaging time 1 seconds
% fftlength=1; %1 seconds of data to perform FFT
% window_length=fftlength*Fs_EMG;
%
% tt=(0:length(EMG_DATA)-1)/Fs_EMG;
%
% %% Pre-process the EMG data
% % 1. Remove any DC offset of the signal
% EMG_DATA=detrend(EMG_DATA); % remove DC offset of the signal
%
% % 2. Rectification of the EMG signal
% rec_EMG_DATA=abs(EMG_DATA);
%
% % 3. Linear Envelope of the EMG signal
% [B,A] = butter(5,10/Fs_EMG,'low');
% EMG_filt=filtfilt(B,A,rec_EMG_DATA);
%
% % maybe apply other filter??
%
% %% FFT
% DataforFFT=EMG_DATA; % EMG data without DC offset
%
% dataPSD_cell=cell(length(floor(tt(length(tt))/T_average)-fftlength),2);
% i=0;
% EMGRMS=zeros(floor(tt(length(tt))/T_average)-fftlength,size(EMG_filt,2));
% EMGRMS_filt=zeros(floor(tt(length(tt))/T_average)-fftlength,size(EMG_filt,2));
% MedianFreq_11=zeros(floor(tt(length(tt))/T_average)-fftlength,size(EMG_filt,2));
% PeakFreq=zeros(floor(tt(length(tt))/T_average)-fftlength,size(EMG_filt,2));
% for k=1:floor(tt(length(tt))/T_average)-fftlength
%     i=i+1;
%
%     Aseg_raw=EMG_DATA((k-1)*T_average*Fs_EMG+1:(k-1)*T_average*Fs_EMG+window_length,:);
%     Aseg=DataforFFT((k-1)*T_average*Fs_EMG+1:(k-1)*T_average*Fs_EMG+window_length,:);% 1 second data fft non-overlap
%     [dataPSD, dataFreq] = pwelch(Aseg,rectwin(window_length),window_length/2,window_length,Fs_EMG,'psd'); % no window, 50% overlapping, window_length=nfft
%
%     dataPSD_cell{i,1}=dataFreq;
%     dataPSD_cell{i,2}=dataPSD;
%
%     %RMS of raw EMG & VMG for every second
%     EMGRMS(i,:)=rms(Aseg_raw);
%     %VMGRMS_totals(k,:)=rms(Asegtotals);
%     %VMGRMS_yz(k,:)=rms(Asegyz);
%
%     EMGRMS_filt(i,:)=rms(Aseg);
%     %VMGRMS_totals_filt(k,:)=rms(Asegtotals_filt);
%     %VMGRMS_yz_filt(k,:)=rms(Asegyz_filt);
%
%
%     %median frequency
%     MedianFreq_11(i,:)=medfreq(Aseg, Fs_EMG);
%     %MedianFreq_22=medfreq(dataPSD, dataFreq);
%     %Result_All_3(k,kk)=MedianFreq;
%
%
%     % peak frequency
%     [Value_peak,Ind_peak]=max(dataPSD,[],1);
%     PeakFreq(i,:)=dataFreq(Ind_peak);
%
%
% end
%
