% test EMG functions 
clear all
close all
clc

%% 
load MVC60_Fatigue2_Biomonitor.mat

EMGdata=cell2mat(Data(:,2:8)); % 7 EMG Data
emg=EMGdata(:,1); %EMG1
t=cell2mat(Data(:,1)); %time 

% frequency
fs=round(1/(t(2)-t(1))); % sampling frequency 1500Hz

%% plot amplitude and power spectra up to the Nyquist frequency
fnyq=fs/2;
N=length(emg);
freqs=0:fs/N:fnyq;


xfft=fft(emg-mean(emg));%amplitude
figure (1);
plot(freqs,abs(xfft(1:N/2+1)));
xlabel('Frequency (Hz)')
ylabel('Amplitude')
title('Amplitude Spectrum (original)')
ylim([0,2.5*10^5])


pxx=xfft.*conj(xfft); %power
figure(2);
plot(freqs,abs(pxx(1:N/2+1)));
xlabel('Frequency (Hz)')
ylabel('Power')
title('Power Spectrum (original)')
ylim([0,5*10^10])

%% filter EMG
filtemg=EMG_filter(emg,fs);

xfft_filtered=fft(filtemg-mean(filtemg)); %amplitude
figure (3);
plot(freqs,abs(xfft_filtered(1:N/2+1)));
xlabel('Frequency (Hz)')
ylabel('Amplitude')
title('Amplitude Spectrum (filtered)')
ylim([0,2.5*10^5])

pxx_filtered=xfft.*conj(xfft_filtered); %power
figure(4);
plot(freqs,abs(pxx_filtered(1:N/2+1)));

xlabel('Frequency (Hz)')
ylabel('Power')
title('Power Spectrum (filtered)')
ylim([0,5*10^10])

%% plot raw, filtered  and rectified EMG
emg_rect=abs(filtemg);

figure (5)
subplot(3,1,1)
p1=plot(t,emg,'k'); % original EMG
legend('original EMG')
xlabel('Time (sec)')
ylabel('Potential (mV)')

subplot(3,1,2)
p2=plot(t,filtemg,'c'); % filtered EMG
legend(p2,'filtered EMG')
xlabel('Time (sec)')
ylabel('Potential (mV)')

subplot(3,1,3)
p3=plot(t,emg_rect,'m'); % filtered EMG
legend(p3,'filtered and rectified EMG')
xlabel('Time (sec)')
ylabel('Potential (mV)')



