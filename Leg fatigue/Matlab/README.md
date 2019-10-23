## Process testing data:
**1. Record the subject/testing information into excel files.**
- There are normally three data folders (**Vicon_Matlab**, **OximeterData**, **Noraxon_mat**) under each testing (testing No. is different than the subject No. since the same subject might attend multiple tests). 
- LegFatigueTesting_subjects info.xlsx (or LegFatigueTesting_subjects info_laptop.xlsx): record subject information, measurements and trial order
- LegFatigueTesting_RPE_recording.xlsx: more detailed testing information with RPE readings and trial locations.

**2. Process Vicon data**
- From Vicon files(including **Force**, __Events__, __VMG__ and __possible EMG__) to .mat files
  - For __short trials__ (such as reference trials: resting and MVC100)
    - Run "\Matlab_batch\ [BatchSaveMat_shortTrials.m](BatchSaveMat_shortTrials.m)" (make sure input correct "testNo"; comment out the EMG section if necessary)
	  - It calls "LegFatigueTesting_subjects info.xls" (make sure it updates as the same file in folder 'LegFatigue_matlab'), which has the directory information for the Vicon trials and output location.
	  - Before run the program, make sure the Vicon Nexus program (Nexus 2.3) is opened and the desired subject and trial folder was located (no need to open the trial).
	  - The cell (with header and data) as a ".mat" file will be saved in the "output" folder.
	  - Notes: Trial_list={'Resting_1','Resting_2','MVC100_1a','MVC100_1b','MVC100_2a','MVC100_2b','MVC100_3a','MVC100_3b','MVC100_4a','MVC100_4b','MVC100_5a','MVC100_5b'}
	 
  - For __long trials__ (proximately less than 20 mins/130000frame/1300seconds?? need check)
    - Run "\Matlab_batch\ [processCSV_total.m](processCSV_total.m) (which calls functions in "processCSV_total" folder"; make sure input correct "testNo"; comment out the EMG section with "saveAllEMGMat" if necessary)
	  - Before run the program, the ".csv" files for the desired trials should be exported from Vicon Nexus.
	    - if use "batch" process in Nexus to export ASCII (.csv files), it seems only can export all devices instead of selected ones.
	  - The header ("cell") and data ("numeric array") will be saved into two ".mat" files respectively to the "output" folder.	  - Notes: filenames={'MVC30_Fatigue1.csv','MVC30_Fatigue2.csv','MVC60_Fatigue1.csv','MVC60_Fatigue2.csv'};
	 
  - For __extremely long trials__ 
    - Run "\Matlab_batch\processCSV_total.m" carefully
	  - save separate csv files for EMG, force/event, and acceleration, respectively.
	  - make sure change file/selected functions accordingly, before run "processCSV_total.m": such as commentting out "saveAllEMGMat", "saveAllForceEventMat", or "saveAllAccelerationMat" correspondingly (save different type of data one by one).

- Obtain maximum exertion force level **(MVC100_cell.mat)** 
  - Input the corresponding MVC100 trial informtion into "LegFatigueTesting_RPE_recording.xlsx" (at least fill the file name for each Vicon trial)
  - Make sure all the MVC100 trials have been processed in the previous step (i.e., their .mat files are available)
  - Run [MVC_data.m](MVC_data.m) (make sure input correct "totalTest" number),which calls two functions (getTimeStampsofEvents.m and getMostConsistent.m) from "funtions" folder--> output **"MVC100_cell.mat"** (use this one: for each trial, use the max average Force in a moving 1-second window, and average the max values if there are two trials) and "MVC100_cell_absoluteMax.mat" (pick the larger one between two trials) 
 	 
		 
**3. Process Noraxon data**
  - The .mat files can be exported directly from Noraxon software:
    - EMG (it was recorded in Vicon system for the first 11 tests)
    - Biomonitor Data: 
      - work on choosing filter for ECG signal (band-pass filter 1-40Hz) (at ...\Research_NIOSH\ECG)

**4. Process Nonion Oximeter (NIRS) data**
  - The RPE Events was manually input to the oximeter;
  - Run [plot_Force_ECG_RPE_4plots.m](plot_Force_ECG_RPE_4plots.m) (make sure MVC100_cell.mat available; calls functions in "function" folder) to align all the data with Vicon time and output Oximeter and RPE data into .mat files: 
    - Check event/event time (check "Time_event" in matlab): 
	  - Due to human errors,the number of events in Nonion may not match with that in Vicon events 
      - The number of events in Vicon should be same as that in "RPE_recording_Sxx.docx"  (no 'start" and "end" recording events in Vicon); 
	    - How to input the time in the docx file: "Insert"--> "Data&Time" (e.g., 10:49:01 AM)
	  - notes: in case there are missing events in Vicon, predicted event label (add '5*ones(62,1)'/0.062-second-long to 'ForceEvent_data') can be added based on the time in "RPE_recording" file.
	  
	  
**5. Extract features from experimental data (matlab function files are under ".../LegFatigue_matlab/functions")**
  - **extractRPEclass**: Identify the fatigue level from RPE values and select windows (run first)
    - "light" = 6 to 12; "tired" = 16 to 20 (check the number! RPE ranged from 6 to 20)
	- "pull"= 6; "stop"=20;
	- "window_length"=5 (second);
	- changed to curved fitting (use "pchip"; 2019/5/6) the RPE values and resample the data;
	- **Input**: RPEcell (2 columns: time and RPE; time aligned with Vicon recording), window_length (in seconds), window_overlap (in percentage),Fs(resampling frequency; Hz);
	- **Output (only including data for the selected windows labeled as "light" and "tired")**: 
	  - 'RPE_ClassTable'=[startingTime_second,endingTime_second,FatigueLevel]; % starting and ending time and RPE label for specified windows 
      - 'RPE_SectionedTable'=[TimePointsInSeconds_within_a_window,Corresponding Interpolated_RPE]. % for each column, time points within a window and corresponding RPE values (including the resampled data for the entire trial, roughly from pull to stop),
	
  
  - extractForceFeatures: 
    - **Input**: ForceEvent_data, MVC100_force (average among 5 MVC trials), RPE_ClassTable
	- **Output**: 
	  - 'forceFeatureTable'=[force.forceMean (percentage of MVC), force.forceSTD (standard deviation of forceMean), force.forceCV (coefficient of variation, in percentage), force.timeOffset (the time difference in windows)]
	  - PS: timeOffset=the difference between the selected RPE window and the selected Force window (due to sampling frequency didference)
	
  - extractOxiFeatures:
    - **Input**: OxiCell,RPE_ClassTable,fs(resampling frequency);
	- **Output**: 
	  - 'oxiFeatureTable'=[Oxi.OxiCerebral_abs, Oxi.OxiCerebral_wrtRef_Pct, Oxi.OxiMuscle_abs, Oxi.OxiMuscle_wrtRef_Pct, Oxi.timeOffset]
    
  
  - extractEMGFeatures: 
    - [EMG analysis](EMG_related/README.md) about filtering, rectifying and spectral analysis  
    - **Input**: EMGData,RPE_ClassTable,Fs_EMG (EMG frequency),T_average (averaging time),fftlength (# seconds of data to perform FFT)
	- **Output**: 
	  - 'FeatureTable_EMG'=[EMG.EMG_rmsMean, EMG.EMG_rmsMedian, EMG.EMG_rmsSTD, EMG.EMG_medianFrq, EMG.EMG_meanFrq, EMG.EMG_H2Lratio, EMG.EMG_H2Mratio, EMG.EMG_M2Lratio]
	- Notes: 
	  - New EMG data was located in "Data" (first column=time, started before 0 second); old EMG data: in "EMG_data", the first column=time (starts from 0 second);
	  
	
	
  - extractAccelerationFeatures (VMG):
    - [VMG analysis](VMG_related/README.md) about filtering and spectral analysis 
	- **Input**:
	- **Output**: 
	- Notes: Check 'Acceleration_medFrq.m' function (FFT and median frequency on Acceleration data)

  - Organize features for all the subjects
    - use "FatigueFeatures_allSubjects.m"  

**6. Use "Classification Learner" app in Matlab.2017b**	

**7. Feature selection approach**
  - Use [ClassificationModels_test.m](ClassificationModels_test.m)
<<<<<<< HEAD
  
  
Notes (9/15/2018):
 - Use folder "Testing13_S14_featurTest
 - add % of powder of low frequency band(15.625-62.5Hz) vs. high frequency band (62.5-250Hz) 
 - fix Accelearation FFT
 - In addition, the Borg RPE scale and [CSI](https://www.ncbi.nlm.nih.gov/pubmed/26115515) were positively correlated, suggesting that the factors due to cardiac stress might also contribute to fatigue state during physical exercise.
 - [Heart rate variability analysis during muscle fatigue due to prolonged isometric contraction](https://www.ncbi.nlm.nih.gov/pubmed/29060120)
