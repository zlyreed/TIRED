%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%This program calculates the median frequency and the average amplitude of an  %
%EMG signal over a specified window size and with a specified step size.       %
%Author: Paulien Roos (paulien.roos@cfdrc.com                                  %
%October 2015                                                                  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear
close all
pkg load io

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Set the window size and time step size                                       %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
window_size = [0.1; 0.25; 0.50; 1.0; 0.1; 0.25; 0.50; 1.0; 0.1; 0.25; 0.50; 1.0];
timestep_size = [0.1; 0.25;0.5; 1.0; 0.05; 0.125; 0.25; 0.5; 0.025; 0.063;0.125; 0.25]; 
fs = 1000; %sampling frequency (change if not 1000 Hz!!)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Read in the raw EMG data                                                     %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[filename, pathname]= uigetfile("*.c3d", "MultiSelect","on")
for i = 1:size(filename,2)
%    if(size(filename,2)>1)
%      filepathname(i,:)=[pathname char(filename(i))];
%    else
%      filepathname=[pathname char(filename)];
%    end
%    %[ numarr, txtarr, rawarr, limits] = xlsread(filepathname(i,:));
%    [Markers,VLABELS,VideoFrameRate,AnalogSignals,ALABELS, AUnits, AnalogFrameRate,Event,ParameterGroup,CameraInfo]... 
%            = readC3D(filepathname(i,:));
%        [m,n,o]=size(Markers);
%%        for k = 1:size(ALabels,2)
%%        if strcmp(ALabels(1,k),'Lat Gast')==1
%%            number = k;
%%        end
%%        if strcmp(ALabels(1,k),'Lat. Gastr.')==1
%%            number = k;
%%        end
%%    end
%    emgInds = [17;25;26;27;28;29];

    dt = load('C:/Paulien/NeckProject/UNCC/1002ll/session3/Fatigue.txt');
    emg_raw(:,:,1) = dt(:,2:7);
    time(:,1) = dt(:,1);
    fs = 1/(time(2,1)-time(1,1));
        
%    emg_raw(:,:,i) = AnalogSignals(:,emgInds);
%    for j=1:size(AnalogSignals,1)
%        time(j,i) = (j-1)*(1/fs);
%    end
%%    emg_raw(1:size(numarr,1),:,i) = numarr(:,2:size(numarr,2));
%    clear Markers VLABELS VideoFrameRate AnalogSignals ALABELS AUnits AnalogFrameRate Event ParameterGroup CameraInfo;
    figure,plot(time(9000:30000),emg_raw(9000:30000,:));
    axis([time(9000) time(30000) -5e-5 5e-5])
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Filter the raw EMG data                                                      %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i = 1:size(emg_raw,3)
  %[nAnalogFrames, nc] = size(emg_raw(:,i));
  for j=1:size(emg_raw,2)
    % Apply 4th order, 0-lag, Butterworth band-pass filter to raw EMG signal.
    order = 4;
    if fs >= 1080
      cutoff = [20 400]                % default
      % cutoff = [80 400];             % use when there is 60 Hz noise
    elseif fs == 600                   
      cutoff = [11 222]                % default
      % cutoff = [44 222];             % use when there is 60 Hz noise
    elseif fs == 1000
        cutoff = [20 450];
    end
    [b, a] = butter(order/2, cutoff/(0.5*fs));
    emg_band(:,j,i) = filter(b, a, emg_raw(:,j,i), [], 1);  

    % Rectify the filtered EMG signal.
    emg_rect(:,j,i) = abs(emg_band(:,j,i));
%    figure, plot(time, emg_raw(:,j,i),'b'); hold on; plot(time, emg_rect(:,j,i),'r'); title(muscles(j,i));
  end

  
  
  %% Apply 4th order, 0-lag, Butterworth low-pass filter to rectified signal.
  %order = 4;
  %cutoff = 10;
  %[b, a] = butter(order, cutoff/(0.5*fs));
  %lowEMG = filter(b, a, rectEMG, [], 1);   
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Calculate the median frequency and average amplitude for each window, and    %
% then average over all windows.                                               %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i=1 %:size(emg_raw,3) %number of files
  for ii = 1:6%size(emg_raw,2) %number of channels
    for j=4%1:size(window_size,1) % number of windows to explore
      sz = window_size(j)*fs;
      st = timestep_size(j)*fs;
      tst = time(1,i);
      tnd = time(end,i);
      tln = (tnd-tst)*fs;
      if(tln>=st)
        for k = 1:floor((tln-sz)/st)+1
          data = emg_rect((k-1)*st+1:(k-1)*st+sz,ii,i);
          amplitude(k,ii,i) = mean(data);
          %welch method:
          [Pyy1, Freq1] = periodogram(data,[],'onesided',512,fs);
          
          %FFT:
          m = length(data);
          n = pow2(nextpow2(m));
          Y = fft(data,n);
          Freq2 = (0:n-1)*(fs/n);
          Pyy2 = Y.* conj(Y) / n;
          
%          figure,plot(Freq1,Pyy1,'b'); hold on; plot(Freq2,Pyy2,'r');
          
          stF1 = min(find(Freq1>=25));
          ndF1 = max(find(Freq1<=450)); %only look at frequencies between 25 and 450, because of sampling frequency and to cancel out effect of movement
          stF = min(find(Freq2>=25));
          ndF = max(find(Freq2<=450)); %only look at frequencies between 25 and 450, because of sampling frequency and to cancel out effect of movement
          
          min1 = 1000;
          min2 = 1000;
          for kk = stF1+2:1:ndF1-2
            if( abs(sum(Pyy1(stF1:kk-1))-sum(Pyy1(kk+1:ndF1))) < min1 )
              min1 = abs(sum(Pyy1(stF1:kk-1))-sum(Pyy1(kk+1:ndF1)));
              nn_min1 = kk;
            end
          end
          for kk = stF+2:1:ndF-2
            if( abs(sum(Pyy2(stF:kk-1))-sum(Pyy2(kk+1:ndF))) < min2 )
              min2 = abs(sum(Pyy2(stF:kk-1))-sum(Pyy2(kk+1:ndF)));
              nn_min2 = kk;
            end
          end
          Pyy1_median = min1;
          Pyy2_median = min2;
          
          Freq1_median(k,ii,i) = Freq1(nn_min1);
          Freq2_median(k,ii,i) = Freq2(nn_min2);
        end
        Freq1_median_average(j,ii,i) = mean(Freq1_median(find(Freq1_median(:,ii,i)>0),ii,i));
        Freq2_median_average(j,ii,i) = mean(Freq2_median(find(Freq2_median(:,ii,i)>0),ii,i));
        amplitude_average(j,ii,i) = mean(amplitude(find(amplitude(:,ii,i)>0),ii,i));
      else
        Freq1_median_average(j,ii,i) = 0;
        Freq2_median_average(j,ii,i) = 0;
        amplitude_average(j,ii,i) = 0;
      end
    end
  end
end

%k=4: %plot for window size of 1.0 s

for i=1:size(emg_raw,2)
%  for ii = 1:size(emg_raw,2)
      figure,plot(amplitude(:,i));
      xlabel('time (s)'); ylabel('mean amplitude');
      figure,plot(Freq1_median(:,i));
      xlabel('time (s)'); ylabel('median frequency');
%      figure,plot(Freq2_median(:,i));
%      xlabel('time (s)'); ylabel('median frequency');
%  end
end
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Write output data to file                                                    %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%fname = [filepathname(1:length(filepathname(:,i))-4,i) "_frequency_analysis.txt" ]
%fid = fopen(fname, 'w');
%if fid == -1
%  error(['unable to open ', fname])
%end
%
%% Write data.
%fprintf(fid, 'filename \t');
%fprintf(fid, 'muscle\t');
%fprintf(fid, 'window \t');
%fprintf(fid, 'step size \t');
%fprintf(fid, 'mean median frequency (welch) \t');
%fprintf(fid, 'mean median frequency (FFT) \t');
%fprintf(fid, 'mean amplitude \n');
%  
%for i = 1:size(filename,2)
%  for j = 1:size(Freq1_median_average,1)
%    for k = 1:size(Freq1_median_average,2)
%      fprintf(fid, '%s\t', char(filename(1,i))); 
%      fprintf(fid, '%s\t', char(muscles(k))); 
%      fprintf(fid, '%20.8f\t', window_size(j));
%      fprintf(fid, '%20.8f\t', timestep_size(j));
%      fprintf(fid, '%20.8f\t', Freq1_median_average(j,k,i));
%      fprintf(fid, '%20.8f\t', Freq2_median_average(j,k,i));
%      fprintf(fid, '%20.8f\n', amplitude_average(j,k,i));
%    end
%  end
%  fprintf(fid, '\n');
%end
%
%fclose(fid);