function AccelerationFeatureTable=extractAccelerationFeatures(acceData,RPETable,Fs_Acceleration,T_average,fftlength)

% acceData=Acceleration_data;
% RPETable=RPE_ClassTable;
% Fs_Acceleration=1000;  % acceleration frequency = 1500
% T_average=1; %averaging time 1 seconds
% fftlength=1; %1 seconds of data to perform FFT

Time_acce=acceData(:,1);  % time in Acceleration data
Accedata=acceData(:,2:end);  % 9 Acceleration data


Accedata_muscle=sqrt(Accedata(:,1).^2+Accedata(:,2).^2+Accedata(:,3).^2);
Accedata_bone=sqrt(Accedata(:,4).^2+Accedata(:,5).^2+Accedata(:,6).^2);
Accedata_fattyarea=sqrt(Accedata(:,7).^2+Accedata(:,8).^2+Accedata(:,9).^2);

Accedata_combined=[Accedata_muscle,Accedata_bone,Accedata_fattyarea];
acceNames_combined={'Muscle','Bone','FattyArea'};


nWindows=size(RPETable,1); % the number of widowns selected in RPE data
for kw=1:nWindows
    startingTime=RPETable{kw,1};
    endingTime=RPETable{kw,2};
    
    kt=find(Time_acce>=startingTime &Time_acce<=endingTime);
    if isempty(kt)==0  % find matched time range
        time_selected=Time_acce(kt,1);
        timeOffset=max(time_selected)-min(time_selected)-(endingTime-startingTime);
        
        Acceleration_selected=Accedata_combined(kt,:);
        
        Accelerationraw_mean=mean(Acceleration_selected);
        Accelerationraw_median=median(Acceleration_selected);
        Accelerationraw_std=std(Acceleration_selected);
        Accelerationraw_meanAbs=mad(Acceleration_selected);        
        
        % FFT 
       [AccelerationRMS_filt,MedianFreq_11]=Acceleration_medFrq(Acceleration_selected,Fs_Acceleration,T_average,fftlength);
        
        for eN=1:size(Acceleration_selected,2) 
            AcceName_selected=acceNames_combined{1,eN};
            eval(['Acceleration.Acceleration' AcceName_selected '_rawMean(kw,1)=Accelerationraw_mean(1,eN);']); % 7 Acceleration
            eval(['Acceleration.Acceleration' AcceName_selected '_rawMedian(kw,1)=Accelerationraw_median(1,eN);']); % 7 Acceleration
            eval(['Acceleration.Acceleration' AcceName_selected '_rawSTD(kw,1)=Accelerationraw_std(1,eN);']); % 7 Acceleration
            eval(['Acceleration.Acceleration' AcceName_selected '_rawmeanAbs(kw,1)=Accelerationraw_meanAbs(1,eN);']); % 7 Acceleration
            
            eval(['Acceleration.Acceleration' AcceName_selected '_rms(kw,1)=mean(AccelerationRMS_filt(:,eN));']); % 7 Acceleration
            eval(['Acceleration.Acceleration' AcceName_selected '_medianFrq(kw,1)=mean(MedianFreq_11(:,eN));']);  % 7 Acceleration
%             eval(['Acceleration.Acceleration' AcceName_selected '_peakFrq(kw,1)=mean(PeakFreq(:,eN));']);  % 7 Acceleration            
        end
              
        Acceleration.timeOffset(kw,1)=timeOffset;              
        
    else
        Acceleration.timeOffset(kw,1)=endingTime-startingTime;
        
    end
end


AccelerationFeatureTable=struct2table(Acceleration);