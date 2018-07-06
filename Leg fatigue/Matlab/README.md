## Process testing data:
- **Record the subject/testing information into excel files.**
  - There are normally three data folders (**Vicon_Matlab**, **OximeterData**, **Noraxon_mat**) under each testing (testing No. is different than the subject No. since the same subject might attend multiple tests). 

- **Process the raw data into .mat files.**

   - From Vicon (including **Force**, __Events__, __VMG__, and __possible EMG__)
     - From Raw data: 
		 - For short trials (such as reference trials: resting and MVC)
		 
		 - For long trials 
			 
		 - For extremely long trials 
		 
	 - Get max. exertion force level (MVC100_cell) 
		 - Input the corresponding MVC100 trials into "LegFatigueTesting_RPE_recording.xlsx" (at least fill the Vicon Trial file name for each trial)
         - run "MVC_data.m" (make sure input correct "totalTest" number)--> output **"MVC100_cell.mat"** (use this one: for each trial, use the max average Force in a moving 1-second window, and average the max values if there are two trials) and "MVC100_cell_absoluteMax.mat" 
         - Notes (7/6/2018): process Test # 15-17 to get trial mat files first, and then run "MVC_data.m".
		 
  - From Noraxon (The .mat files can be exported directly from Noraxon software)
     - EMG
     - Biomonitor
   
   - From Nonion (Oximeter)
     - Event
     - Oxygen reading
   
