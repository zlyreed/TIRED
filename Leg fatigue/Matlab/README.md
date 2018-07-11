## Process testing data:
**1. Record the subject/testing information into excel files.**
- There are normally three data folders (**Vicon_Matlab**, **OximeterData**, **Noraxon_mat**) under each testing (testing No. is different than the subject No. since the same subject might attend multiple tests). 
- LegFatigueTesting_subjects info.xlsx (or LegFatigueTesting_subjects info_laptop.xlsx): record subject information, measurements and trial order
- LegFatigueTesting_RPE_recording.xlsx: more detailed testing information with RPE readings and trial locations.

**2. Process Vicon data**
- From Vicon files(including **Force**, __Events__, __VMG__ and __possible EMG__) to .mat files
  - For __short trials__ (such as reference trials: resting and MVC100)
    - Run "\Matlab_batch\ [BatchSaveMat_shortTrials.m](BatchSaveMat_shortTrials.m)" (make sure input correct "testNo"; comment out the EMG section if necessary)
	  - It calls "LegFatigueTesting_subjects info.xls", which has the directory information for the Vicon trials and output location.
	  - Before run the program, make sure the Vicon Nexus program (Nexus 2.3) is opened and the desired subject and trial folder was located (no need to open the trial).
	  - The cell (with header and data) as a ".mat" file will be saved in the "output" folder.
	  - Notes: Trial_list={'Resting_1','Resting_2','MVC100_1a','MVC100_1b','MVC100_2a','MVC100_2b','MVC100_3a','MVC100_3b','MVC100_4a','MVC100_4b','MVC100_5a','MVC100_5b'}
	 
  - For __long trials__ (proximately less than 20 mins/130000frame/1300seconds?? need check)
    - Run "\Matlab_batch\ [processCSV_total.m](processCSV_total.m) (which calls functions in "processCSV_total" folder"; make sure input correct "testNo"; comment out the EMG section with "saveAllEMGMat" if necessary)
	  - Before run the program, the ".csv" files for the desired trials should be exported from Vicon Nexus.
	    - if use "batch" process in Nexus to export ASCII (.csv files), it seems only can export all devices instead of selected ones.
	  - The header ("cell") and data ("numeric array") will be saved into two ".mat" files respectively to the "output" folder.
	  - Notes: filenames={'MVC30_Fatigue1.csv','MVC30_Fatigue2.csv','MVC60_Fatigue1.csv','MVC60_Fatigue2.csv'};
	 
  - For __extremely long trials__ 
    - Run "\Matlab_batch\processCSV_total.m" carefully
	  - save separate csv files for EMG, force/event, and acceleration, respectively.
	  - make sure change file/selected functions accordingly, before run "processCSV_total.m": such as commentting out "saveAllEMGMat", "saveAllForceEventMat", or "saveAllAccelerationMat" correspondingly (save different type of data one by one).

- Obtain maximum exertion force level **(MVC100_cell)** 
  - Input the corresponding MVC100 trial informtion into "LegFatigueTesting_RPE_recording.xlsx" (at least fill the file name for each Vicon trial)
  - Make sure all the MVC100 trials have been processed in the previous step (i.e., their .mat files are available)
  - Run [MVC_data.m](MVC_data.m) (make sure input correct "totalTest" number),which calls two functions (getTimeStampsofEvents.m and getMostConsistent.m) from "funtions" folder--> output **"MVC100_cell.mat"** (use this one: for each trial, use the max average Force in a moving 1-second window, and average the max values if there are two trials) and "MVC100_cell_absoluteMax.mat" (pick the larger one between two trials) 
 	 
		 
**3. Process Noraxon data**
  - The .mat files can be exported directly from Noraxon software:
    - EMG (it was recorded in Vicon system for the first 11 tests)
    - Biomonitor Data

**4. Process Nonion Oximeter (NIRS) data**
  - The RPE Events was manually input to the oximeter;
  - Run [plot_Force_ECG_RPE_4plots.m](plot_Force_ECG_RPE_4plots.m) (make sure MVC100_cell.mat available; calls functions in "function" folder) to align all the data with Vicon time and output Oximeter and RPE data into .mat files: 
    - Check event/event time (check "Time_event" in matlab): the number of events in Nonion may not match with that in Vicon events (due to human errors, besides no 'start" and "end" recording events in Vicon)
    
**5. Extract features from experimental data**
  - extractRPEclass: Identify the fatigue level from RPE values 
    - "light" = 6 to 12; "tired" = 16 to 25 (check the number! RPE ranged from 6 to 20)
	- "pull"= 5; "stop"=21;
	- "window_length"=5 (second)
  
  - extractForceFeatures: 
  
  - extractOxiFeatures:
  
  - extractEMGFeatures: 
  
  - extractAccelerationFeatures:
 
