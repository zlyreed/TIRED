# EMG analysis

- check out the example singal analysis from [delsys](https://www.delsys.com/use-emgscripts-fatigue-analysis/)


- possible useful software from [motion labs](https://www.motion-labs.com/index_downloads.html)

1. **Raw EMG data**
- Difference between in voltage between two electrodes (surface or needle)
- recommended above 1000Hz 

2. **Filter**

- Berchicci, 2013: use band-pass 10-500Hz
- [Muscle-Fatigue-Experiment](https://github.com/DharaRan/Muscle-Fatigue-Experiment): applied a bandpass filter with a cutoff frequency of 5 Hz a high pass filter and 350 Hz with a low pass filter using the butterworth's filter in MATLAB. The sampling frequency of 1000Hz was used to have a Nyquist rate of 2000Hz. Moreover, the noise from the powerline of 60 Hz was also removed by using a band stop filter with a cutoff frequency of 58 to 62 Hz. 
- CFD research group ([FatigueFrequencyAnalysisC3D.m](FatigueFrequencyAnalysisC3D.m)): used a 4th order, 0-lag, Butterworth band-pass filter (cutoff = [20 400] and a few other options) to raw EMG signal.
- ABC of EMG: Given the recommended amplifier bandpass settings from 10 Hz high-pass up to at least 500 Hz low pass (SENIAM,ISEK); most of the surface EMG frequency power is located between 10 and 250 Hz.

Notes: Plot the original amplitude/power spectrum, explore the possible filters and take a look at the filtered data/spectrum([test_emgSpectra.m](test_emgSpectra.m)).


3. **Rectify**

4. **Spectral Analysis**
- To plot time-median/mean frequency 
- 9/12/2018: continue working on 'EMG_FFT_fatigue.m' and 'testEMGfunctions_timeFrequencyPlot.m' (under folder ...\MuscleFatigue_Testing\LegFatigue_matlab\Check later\Muscle-Fatigue-Experiment_github)
