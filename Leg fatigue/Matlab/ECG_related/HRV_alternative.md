**Calcualte the regular HRV parameters in the beginning and ending windows of the isometric tasks**
Preprocess:
  - run [plot_Force_ECG_RPE_4plots.m](plot_Force_ECG_RPE_4plots.m) and make sure the RPE mat files were saved in "ViconMatlab" folder (e.g., MVC30_Fatigue2_RPEData.mat)


1. load RR data: only 10 subjects (S13-S22; Testing12-21) have the Biomonitor/ECG data

2. Remove the 'steps' (preprocess RR data)

3. Obtain the desired windows:
   - get the time value of the starting pulling and fatigue (RPE=19)
     - S14: MVC30_Fatigue 1 (very long); MVC30_Fatigue2 (short, ~250S)
	 - S19: MVC30_Fatigue1 &2 (very short, ~200s)
   - in the begining
   - at the ending
   
4. Functions of HRV 
   - HRV_time   
   - HRV_nonlinear   
   - HRV_frequency
   - HRV_fragmentation
   
 5. Comparison between two windows (begining vs. ending)


  