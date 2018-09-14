function [freqRes,emg_FFT,pxx, f,MedianFr,MeanFr]=EMG_fftMFP(signal, fs)

% note: use filtered EMG signal

filtemg=signal;

N = length(filtemg);
% 
% index = 0:1:N-1;%Range of frequency (starting at DC freq)
% 
% fres = fs/N; 
% 
% freq = index.*fres; %Determine frequency resolution

filtemg_FFT= fft(filtemg);%fft of force

filtemg_FFT = abs(filtemg_FFT);% absolute value of fft

filtemg_FFT = abs(filtemg_FFT/(length(filtemg_FFT)/2));% absolute value of fft

emg_FFT = filtemg_FFT(1:length(filtemg_FFT)/2);

fres = fs/N; 

index = 0:1:(N-1)/2;

freqRes = index.*fres;

%% power spectrum
[pxx, f] = periodogram(filtemg, [], [], fs);

MedianFr=medfreq(pxx,f);

MeanFr=meanfreq(pxx,f);


