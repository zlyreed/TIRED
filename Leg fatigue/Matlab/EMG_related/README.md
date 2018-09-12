# EMG analysis

- check out the example singal analysis from [delsys](https://www.delsys.com/use-emgscripts-fatigue-analysis/)


- possible useful software from [motion labs](https://www.motion-labs.com/index_downloads.html)

1. **Raw EMG data**
- Measure different between in voltae between two electrodes (surface or needle)
- recommended above 1000Hz 

2. **Filter**

- Berchicci, 2013: use band-pass 10-500Hz
- [Muscle-Fatigue-Experiment](https://github.com/DharaRan/Muscle-Fatigue-Experiment): applied a bandpass filter with a cutoff frequency of 5 Hz a high pass filter and 350 Hz with a low pass filter using the butterworth's filter in MATLAB. The sampling frequency of 1000Hz was used to have a Nyquist rate og 2000Hz. Moreover, the noise from the powerline of 60 Hz was also removed by using a band stop filter with a cutoff frequency of 58 to 62 Hz. 
- CFD research group ([FatigueFrequencyAnalysisC3D.m](FatigueFrequencyAnalysisC3D.m)): used a 4th order, 0-lag, Butterworth band-pass filter (cutoff = [20 400] and a few other options) to raw EMG signal.

3. **Rectify**

4. **Spectral Analysis**
