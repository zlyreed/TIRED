## Process testing data:
- **Record the subject/testing information into excel files.**
  - There are normally three data folders (**Vicon_Matlab**, **OximeterData**, **Noraxon_mat**) under each testing (testing No. is different than the subject No. since the same subject might attend multiple tests). 

- **Process the raw data into .mat files.**

   - From Vicon (including **Force**, __Events__, __VMG__, and __possible EMG__)
	 - For short trials (such as reference trials: resting and MVC100)
	   - Run "BatchSaveMat_shortTrials.m" (make sure input correct "testNo"; comment out the EMG section if necessary)
		 - It calls "LegFatigueTesting_subjects info.xls", which has the directory information for the Vicon trials and output location.
		 - Before run the program, make sure the Vicon Nexus program (Nexus 2.3) is opened and the desired subject and trial folder was located (no need to open the trial).
		 - The cell (with header and data) as a ".mat" file will be saved in the "output" folder.
		 - Notes: Trial_list={'Resting_1','Resting_2','MVC100_1a','MVC100_1b','MVC100_2a','MVC100_2b','MVC100_3a','MVC100_3b','MVC100_4a','MVC100_4b','MVC100_5a','MVC100_5b'}
		 
	 - For long trials (proximately less than 20 mins/130000frame/1300seconds?? need check)
	   - Run "processCSV_total.m" (make sure input correct "testNo"; comment out the EMG section with "saveAllEMGMat" if necessary)
		 - Before run the program, the ".csv" files for the desired trials should be exported from Vicon Nexus.
		   - Use "batch" process in Nexus to export ASCII (.csv files) (only can export all, instead of selected devices)
		 - The header ("cell") and data ("numeric array") will be saved into two ".mat" files respectively to the "output" folder.
		 - Notes: filenames={'MVC30_Fatigue1.csv','MVC30_Fatigue2.csv','MVC60_Fatigue1.csv','MVC60_Fatigue2.csv'};
		 
	 - For extremely long trials 
	   - Run "processCSV_total.m" carefully
		 - save separate csv file for EMG, force/event, and acceleration, respectively.
		 - make sure change file/selected functions accordingly, before run "processCSV_total.m": such as commentting out "saveAllEMGMat", "saveAllForceEventMat", or "saveAllAccelerationMat" correspondingly (save different type of data one by one).
	 
	 
		 
  - From Noraxon (The .mat files can be exported directly from Noraxon software)
     - EMG
     - Biomonitor
   
   - From Nonion (Oximeter)
     - Event
     - Oxygen reading
 
- **Obtain maximum exertion force level (MVC100_cell)** 
	 - Input the corresponding MVC100 trials into "LegFatigueTesting_RPE_recording.xlsx" (at least fill the Vicon Trial file name for each trial)
	 - run "MVC_data.m" (make sure input correct "totalTest" number)--> output **"MVC100_cell.mat"** (use this one: for each trial, use the max average Force in a moving 1-second window, and average the max values if there are two trials) and "MVC100_cell_absoluteMax.mat" 
	 - Notes (7/6/2018): process Test # 15-17 to get trial mat files first, and then run "MVC_data.m".
 
