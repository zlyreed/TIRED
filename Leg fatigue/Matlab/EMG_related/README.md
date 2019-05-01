# EMG analysis
- [Normalization on EMG](https://www.intechopen.com/books/computational-intelligence-in-electromyography-analysis-a-perspective-on-current-applications-and-future-challenges/normalization-of-emg-signals-to-normalize-or-not-to-normalize-and-what-to-normalize-to-)

- check out the example singal analysis from [delsys](https://www.delsys.com/use-emgscripts-fatigue-analysis/)


- possible useful software from [motion labs](https://www.motion-labs.com/index_downloads.html)

1. **Raw EMG data**
- **On the Noraxon data**( most of the later subjects have total 7 channels):
  - Data locations: in the Vicon folders for Test No 1-11 (unit: V); in the Noraxon folders for Test 12-21 (unit: uV) 
  - Missing and bad data: 
    - Test No. 1 to 8: no recording for Channel 6 and 7 (zeros); Testing No. 12 to 21: with the recording from Channel 6 and 7
    - Test No 5 (S8): Channel 1 was not good after MVC30_fatigue 1 and MVC100_1; for the rest trials, use Channel 6 recording for Rectus Femoris. 
      - fixed Test No. 5 (updated at '...\LegFatigueTesting05_2017-09-15_S08\Vicon_Matlab' on 04-05-2019): move the recording from Channel 6 to Channel 2, replace Channel 6 with zeros (use [Fix_EMG_Channels.m](Fix_EMG_Channels.m), which calls [fixArrayColumn.m](fixArrayColumn.m) and [fixCellColumn.m](fixCellColumn.m)). 
    - Test No.9 (S11): missing recording of Channel 6 and 7 for MVC60_Fatigue1 trial (the first trial)
  - Need to fix the unit (5/1/2019)	: run [modifyUnitOfEMG.m](modifyUnitOfEMG.m) in the Vicon_Matlab folder as needed.
	
Notes: 
- Difference between in voltage between two electrodes (surface or needle)
- "ABC of EMG" [(Peter Konrad, 2006)](https://www.noraxon.com/wp-content/uploads/2014/12/ABC-EMG-ISBN.pdf): This would result in a sampling frequency of at least 1000 Hz (double band of EMG) or even 1500 Hz to avoid signal loss. 

	  
2. **Filter**

- Berchicci, 2013: use band-pass 10-500Hz
- [Muscle-Fatigue-Experiment](https://github.com/DharaRan/Muscle-Fatigue-Experiment): applied a bandpass filter with a cutoff frequency of 5 Hz a high pass filter and 350 Hz with a low pass filter using the butterworth's filter in MATLAB. The sampling frequency of 1000Hz was used to have a Nyquist rate of 2000Hz. Moreover, the noise from the powerline of 60 Hz was also removed by using a band stop filter with a cutoff frequency of 58 to 62 Hz. 
- CFD research group ([FatigueFrequencyAnalysisC3D.m](FatigueFrequencyAnalysisC3D.m)): used a 4th order, 0-lag, Butterworth band-pass filter (cutoff = [20 400] and a few other options) to raw EMG signal.
- "ABC of EMG": Given the recommended amplifier bandpass settings from 10 Hz high-pass up to at least 500 Hz low pass (SENIAM,ISEK); most of the surface EMG frequency power is located between 10 and 250 Hz... The peak frequency is typically located between 50 and 80 Hz.


 Notes about filters: 
- General approach: Plot the original amplitude/power spectrum, explore the possible filters and take a look at the filtered data/spectrum([test_emgSpectra.m](test_emgSpectra.m), which calls [EMG_filter.m](EMG_filter.m) or [EMG_filter_bandonly.m](EMG_filter_bandonly.m) ).
- The additional "stop" filter (to remove 60Hz and other frequency) doesn't seem to change time-frequency results (moving window to look at median/mean frequency change wrt time).
- The median/mean frequency during resting period (baseline noise, which is close to white noise) are not consistent. The amplitude can be checked during resting since the power should be pretty low. 

3. **Rectify**
- Start with filtered EMG data;
- obtain the absolute value ('abs(emg_filt)')
- moving average, etc.
- use [EMG_RecRms.m](EMG_RecRms.m)


4. **Spectral Analysis**
- Start with **filtered** EMG data;
- To plot time-median/mean frequency: use [EMG_TimeMedianFrequencyPlot.m](EMG_TimeMedianFrequencyPlot.m) (calls [MedianFMeanF.m](MedianFMeanF.m), [HLpowerRatio.m](HLpowerRatio.m) and [areaCal.m](areaCal.m) )
- High-low frequency amplitude ratio: low=15-45 Hz and High > 95Hz (Allison, et al., 2002); Hight-to-Low power ratio seems have the similar trend as the median frequency wrt time. Look at the function [HLpowerRatio.m](HLpowerRatio.m).
  - Another option: based on the previous study on power ratio of low-to-high frequency bands (Allison and Fujiwara 2002; Cardozo, Gonçalves, and Dolan 2011; Chowdhury et al. 2013), here you can also look at the power frequency ratio (P-R) between low frequency band (15.625—62.5Hz) and high frequency band (62.5—250Hz) 

**Summary:**
- Check the spectrum of the signal in the beginning and then choose approperiate filters:  [test_emgSpectra.m](test_emgSpectra.m)
- Use moving windows to obtain time-median/mean frequency plot: [EMG_TimeMedianFrequencyPlot.m](EMG_TimeMedianFrequencyPlot.m)
- Useful funtions will be used in feature extraction later:
  - filter EMG: [EMG_filter.m](EMG_filter.m) or [EMG_filter_bandonly.m](EMG_filter_bandonly.m) 
  - rectify EMG using moving window: [EMG_RecRms.m](EMG_RecRms.m)
  - calculate late median or mean frequency: [MedianFMeanF.m](MedianFMeanF.m)
  - calculate high to low power ratio: [HLpowerRatio.m](HLpowerRatio.m) and [areaCal.m](areaCal.m)


**Notes:**

- Please refer to the following papers (the list obviously includes only a small body of work) to get some ideas on using EMG data for assessing fatigue([a related post on Biomch](https://biomch-l.isbweb.org/threads/24744-EMG-Fatigue-Analysis?highlight=EMG+frequency)).
  1. Cifrek, M., Medved, V., Tonkovic, S., Ostojic, S., 2009. [Surface EMG based muscle fatigue evaluation in biomechanics](https://www.ncbi.nlm.nih.gov/pubmed/19285766). Clinical Biomechanics 24, 327-340.
  2. Dimitrova, N.A., Dimitrov, G.V., 2003. [Interpretation of EMG changes with fatigue: facts, pitfalls, and fallacies](https://www.ncbi.nlm.nih.gov/pubmed/12488084). Journal of Electromyography and Kinesiology 13, 13-36.
  3. Viitasalo, J.H.T., Komi, P.V., 1977. [Signal characteristics of EMG during fatigue](https://www.ncbi.nlm.nih.gov/pubmed/902652). European Journal of Applied Physiology and Occupational Physiology 37, 111-121.
  4. Vøllestad, N.K., 1997. [Measurement of human muscle fatigue](https://www.ncbi.nlm.nih.gov/pubmed/9219890). Journal of Neuroscience Methods 74, 219-227.
  5. Sparto, P.J., Parnianpour, M., Barria, E.A., Jagadeesh, J.M., 2000. [Wavelet and short-time Fourier transform analysis of electromyography for detection of back muscle fatigue](https://www.ncbi.nlm.nih.gov/pubmed/11001525). IEEE Transactions on Rehabilitation Engineering 8, 433-436.
  6. Subasi, A., Kiymik, M.K., 2010. [Muscle fatigue detection in EMG using time–frequency nethods, ICA and neural networks](https://www.ncbi.nlm.nih.gov/pubmed/20703933). Journal of Medical Systems 34, 777-785.

- Online book for [spectral analysis](https://www.dspguide.com/ch9/1.htm)
