## VMG analysis
### Basic Concept of Accelerometer:
- from [wikipedia](https://en.wikipedia.org/wiki/Accelerometer): An accelerometer is a device that measures proper acceleration.[1] Proper acceleration, being the acceleration (or rate of change of velocity) of a body in its own instantaneous rest frame,[2] is not the same as coordinate acceleration, being the acceleration in a fixed coordinate system. For example, an accelerometer at rest on the surface of the Earth will measure an acceleration due to Earth's gravity, straight upwards (by definition) of g ≈ 9.81 m/s2. By contrast, accelerometers in free fall (falling toward the center of the Earth at a rate of about 9.81 m/s2) will measure zero. 


### Measurement from our lab: 

- **Raw data**
	- Device: used tri-axial accelerometers (Endevco, M35B, mass = 0.55g).The accelerometers were glue onto 3D-printed flat adapters, which were attached to the skin surface using double-sided adhesive tape.
	- Use the recording from SX: SamplingFq=8192 Hz
	- The data recorded in Vicon didn't seem right (1000Hz);
	- X: along the surface; Y: perpendicular to the surface.

- **Filtering**
	- recommend to **detrend** data first: rawdata=detrend(rawdata); 
	- use [VMG_filter.m](VMG_filter.m): band-pass filtered at 2–100 Hz and remove 60 Hz

- **Time domain**: Rectify/RMS
	- use [VMG_RecRms.m](VMG_RecRms.m): 
	  - Calculates windowed (over- and non-overlapping) RMS of a signal using the specified windowlength;
	  - y = rms(signal, windowlength, overlap, zeropad)

- **Frequency domain**:
	- Median frequency and Mean frenqency:
	  - input **filtered** signal;
	  - use the matlab functions (recommended): MedianFr=medfreq(signalS, SamplingFq); MeanFr=meanfreq(signalS, SamplingFq);
		- similarly, use [MedianFMeanF.m](MedianFMeanF.m): [pxx, f,MedianFr,MeanFr]=MedianFMeanF(signal, fs)
	- High, Medium and Lower frequency/power and ratios:
	  - lower frequency (2-20Hz), mid (20-40Hz)and high (>40 Hz and <100Hz)
	  - use the matlab functions (recommended): powerL = bandpower(signalS, SamplingFq,[2 20]);
		- similarly, use [HMLpowerRatio.m](HMLpowerRatio.m): [H2Lratio,H2Mratio,M2Lratio,powerL,powerM,powerH]=HMLpowerRatio(f,pxx); 
		- note: results are different than the bandpower results
		- fixed error in calcualting power 

### Analysis workflow for our VMG measurements
1. 	**Reorganize related recordings into .mat files** (so that the recordings are easy to acess in future analysis)
-  use [ReOrganize_VMG.m](ReOrganize_VMG.m): to output a .mat file ("VMG_Cell_T14_to_T21.mat") which contains a "VMG_Cell" including the VMG data from  T14 to T21.
    - Note: use "save('VMG_Cell_T14_to_T21.mat','VMG_Cell','-v7.3')" to save a large cell ('-v7.3')
-  use [ReOrganize_Force.m](ReOrganize_Force.m): to output a .mat file ("T14_to_T21_ForceCell.mat" ) which contains a "Force_Cell" including the force data from  T14 to T21.
    - Note: "MVC100_cell.mat" will be needed for percetage force calcualtion
	- or use [ReOrganize_Force_total.m](ReOrganize_Force_total.m): to output a .mat file ("ForceCell_total.mat" ) which contains a "Force_Cell" including all the force data.
-  use [ReOrganize_RPE.m](ReOrganize_RPE.m): to output a .mat file ("T14_to_T21_RPECell.mat" ) which contains a "RPE_Cell" including the RPE data from  T14 to T21.
    - or use [ReOrganize_RPE_total.m](ReOrganize_RPE_total.m): to output a .mat file ("RPECell_total.mat" ) which contains a "RPE_Cell" including all the RPE data.

2. **Calculate the desired parameters in time and frequency domains:**
- In time domain ("rms"; magnitude): 
  - calculated for each location (Fat, Muscle and Bone) and each direction (X,Y,Z and total): magnitude for FatX, FatY, FatZ,... and FatTotal
  - call functions: [VMG_filter.m](VMG_filter.m) and [VMG_RecRms.m](VMG_RecRms.m)
- In frequency domain:
  - calculated for each location (Fat, Muscle and Bone) and each direction (X,Y and Z)
  - Parameters: Median Frequency, Mean Frequency, H2Lratio, H2Mratio, M2Lratio, powerLow, powerMed, powerHigh, powerTotal
  - use matlab functions: "medfreq", "meanfreq" and "bandpower"
- Use [VMG_Force_RPE_plot_RmsFft_mat.m](VMG_Force_RPE_plot_RmsFft_mat.m) to process the data and output those parameters for each trial:
  - output example files for a trial: "Testing14_MVC30_Fatigue1_VMG_rms.mat" and "Testing14_MVC30_Fatigue1_VMG_fft.mat" (data in in a structure)
  
3. **Save grouped slope and begin/end data into tables  (.mat file)**
- Obtain Begin ("non-fatiguing"), End ("fatiguing") and total ("Begin to End") windows for each trial 
  - use function [selectedWindows.m](selectedWindows.m)
- Calculate mean, SD and fitted functions (e.g., slope) of the different time- and frenqency-domain parameters for each windowed
  - use function [fittedWindow.m](fittedWindow.m)
- Use [VMG_Force_RPE_BeginEnd_Slope.m](VMG_Force_RPE_BeginEnd_Slope.m) to organize and output grouped parameters
    - BeginEnd_rmsTable.mat (magnitude results in Begin and End windows)
		- BeginEnd_MVC30_rmsTable.mat (magnitude results in Begin and End windows, grouped MVC30 trials only)
		- BeginEnd_MVC60_rmsTable.mat (magnitude results in Begin and End windows, grouped MVC60 trials only)
	- BeginEnd_fftTable.mat (frenqency results in Begin and End windows)
		- BeginEnd_MVC30_fftTable.mat (frenqency results in Begin and End windows, grouped MVC30 trials only)
		- BeginEnd_MVC60_fftTable.mat (frenqency results in Begin and End windows, grouped MVC60 trials only)
	- slopeTotal_rmsTable.mat (slopes of the fitted lines of the magnitude-domain results in total (from begin to end) window)
	    - slopeTotal_MVC30_rmsTable.mat 
		- slopeTotal_MVC60_rmsTable.mat
	- slopeTotal_fftTable.mat (slopes of the fitted lines of the frenqency-domain results in total (from begin to end) window)
	    - slopeTotal_MVC30_fftTable.mat
		- slopeTotal_MVC60_fftTable.mat
  
  



### Previous filtering/analysis information:
- In general:
  - [The Scientist and Engineer's Guide to Digital Signal Processing](http://www.dspguide.com/pdfbook.htm)
  - Cognitive and Neural Dynamics Lab Tutorials: 
    - [Power Spectral Density (PSD)](https://nbviewer.jupyter.org/github/voytekresearch/tutorials/blob/master/Power%20Spectral%20Density%20and%20Sampling%20Tutorial.ipynb)
    - [Neuro Digital Signal Processing Toolbox](https://neurodsp-tools.github.io/neurodsp/)
	- [Filtering examples with pictures and python code](https://neurodsp-tools.github.io/neurodsp/auto_tutorials/plot_1-Filtering.html#sphx-glr-download-auto-tutorials-plot-1-filtering-py)
- Some of previous studies used: band-pass filtered at 2–100 Hz (Madeleine, 2002; Woodward, 2019) or at 3-100Hz (Zhang, 1992)

### Literature
- [Zhang and Herzog, 1992](https://www.ncbi.nlm.nih.gov/pubmed/1452170): 
  - used two miniature accelerometers (Dytran 3015A);
  - The signals were conditioned with bandpass filters with band widths 3-100Hz for the VMG and 10-300 Hz for EMG
  - the study indicates that **the averaged median frequency (MF) (6-24 Hz) and peak frequency (PF) (9-19 Hz) of the VMG signals** are much lower than **the MF (75-109 Hz) and PF (40-80 Hz) of the EMG signals**.
- [Herzog, 1994](https://www.ncbi.nlm.nih.gov/pubmed/7935522): 
  - The purpose of this study was to investigate the behavior of electromyographical (EMG) and vibromyographical (VMG) signals in the time and frequency domains during a fatigue protocol. EMG and VMG records were obtained from the rectus femoris (RF) and vastus lateralis (VL) muscles of 11 adult male subjects during sustained, isometric knee extensor contractions performed at **70% of maximal voluntary contraction (MVC)**. The average median frequencies of the power density spectra decreased during the fatigue protocol for the **EMG (from 73 to 54 Hz for RF, and from 75 to 57 Hz for VL)** and the **VMG signals (from 40 to 19 Hz for RF, and from 25 to 12 Hz for VL)**. Raw EMG signals remained the same qualitatively throughout the fatigue protocol, whereas corresponding VMG records appeared to become "smoother." The results of this study indicate that the pronounced decrease in the high-frequency content of the VMG signal may be observed in the time domain as a "smoothing" of the signal, and thus, that the raw VMG records (which may be displayed readily online) can be used to assess qualitatively the onset and progression of muscular fatigue.
  - When a muscle is fatigued, MF of 12-19 Hz are measured. At least part of the vibrations recorded in this situation are caused by a low-frenqency shaking of the limb, sometimes referredd to as tremor. Tremor is casued by contractions of all the muscles invovlved in a task, not only the muscles from which VMG recordings are obtained... The frequencies of the "pure" VMG (about 10-30Hz) and the frequencies of the phyiological tremor (about 1-25 Hz) overlap...
- [Yoshitake, et al., 2001](https://www.ncbi.nlm.nih.gov/pubmed/?term=11320632)
  - The MMG was detected by a specially designed microphone sensor (10 mm in diameter, mass 5 g, Daia Medical, Japan) with a flat frequency response between 5 Hz and 2000 Hz.
  - The root mean square amplitude value (RMS) of the EMG signal was significantly increased at the initial phase of contraction and then fell significantly, while mean power frequency (MPF) of the EMG signal decreased significantly and progressively as a function of time. There were also significant initial increases in RMS-MMG that were followed by progressive decreases at the end of fatiguing contractions. MPF-MMG remained unchanged. 
- [Madeleine, et al., 2002](https://www.ncbi.nlm.nih.gov/pubmed/12172870)	
  -  Prior to data analysis, the MMG and EMG signals were off-line digitally band-pass filtered at 2–100 Hz and 10– 400 Hz, respectively.
  -  For fatiguing contractions, differences in magnitude of the **increase** in the RMS or average rectified value (ARV) and **decrease** in the MNF or MDF were observed for EMG and MMG. **The MMG amplitude and spectral changes followed the subjective sensation of fatigue and were not correlated to their EMG counterparts**, suggesting that they may reflect different phenomena.
- [Okkesim, 2016](https://www.ncbi.nlm.nih.gov/pubmed/27821615)
  - The mean power frequency and median frequency, which are used in the literature, were compared to the frequency ratio change, the new measure; correlations between the frequency ratio change and the mean power frequency and median frequency were analysed. There was a high correlation between the features, and frequency ratio change can be used to quantitatively evaluate muscle fatigue.
- A systematic review of muscle activity assessment of the biceps brachii muscle using mechanomyography. [Talib, 2018](https://www.ncbi.nlm.nih.gov/pubmed/30511949)
  
- Segmenting Mechanomyography Measures of Muscle Activity Phases Using Inertial Data. [on Scientific Reports, by Woodward, et al., 2019](https://www.ncbi.nlm.nih.gov/pubmed/30944380)
  - Electromyography (EMG) is the standard technology for monitoring muscle activity in laboratory environments, either using surface electrodes or fine wire electrodes inserted into the muscle. Due to limitations such as cost, complexity, and technical factors, including skin impedance with surface EMG and the invasive nature of fine wire electrodes, EMG is impractical for use outside of a laboratory environment. Mechanomyography (MMG) is an alternative to EMG, which shows promise in pervasive applications. The present study used an exerting squat-based task to induce muscle fatigue. MMG and EMG amplitude and frequency were compared before, during, and after the squatting task. Combining MMG with inertial measurement unit (IMU) data enabled segmentation of muscle activity at specific points: entering, holding, and exiting the squat. Results show MMG measures of muscle activity were similar to EMG in timing, duration, and magnitude during the fatigue task. The size, cost, unobtrusive nature, and usability of the MMG/IMU technology used, paired with the similar results compared to EMG, suggest that such a system could be suitable in uncontrolled natural environments such as within the home.