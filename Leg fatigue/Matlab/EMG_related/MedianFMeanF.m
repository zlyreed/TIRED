function [pxx, f,MedianFr,MeanFr]=MedianFMeanF(signal, fs)

% note: use filtered EMG signal; fs: sampling frequency

filtemg=signal;

%% power spectrum
[pxx, f] = periodogram(filtemg, [], [], fs);

MedianFr=medfreq(pxx,f);

MeanFr=meanfreq(pxx,f);
