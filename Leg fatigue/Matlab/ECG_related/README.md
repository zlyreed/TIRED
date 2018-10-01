**ECG**

- Some basic [terms](https://www.physionet.org/tutorials/hrv/#hr-extraction)
  - [QRS](https://en.wikipedia.org/wiki/QRS_complex): The QRS complex is a name for the combination of three of the graphical deflections seen on a typical electrocardiogram (EKG or ECG). In other words, it's the main spike seen on an ECG line.
    
	<img src="pics/QRS.png" alt="drawing" width="400"/>
  - [R-R interval](https://emedicine.medscape.com/article/2172196-overview)
    ![R-R-interval-trace.png](pics/R-R-interval-trace.png "R-R-interval-trace")
  - [Normal-to-Normal(NN) interval](https://psychology.stackexchange.com/questions/16076/what-is-the-difference-between-rr-intervals-and-nn-intervals-in-hrv-data) (filter RR intervals to produce NN intervals): all intervals between adjacent QRS complexes resulting sinus node depolarization.
     - The difference between RR interval and NN interval: NN intervals refer to the intervals between **normal** R-peaks. During a measurement, artifacts may arise due to arrhythmic events or faulty sensors, for example (Citi, Brown & Barbieri, 2012). This may lead to abnormal R-peaks, which may in turn distort the statistical measures. To ensure reliable and valid data, only normal R-peaks are selected. Alternatively, the abnormal R-peaks can be corrected. 
	 In practice, however, RR-intervals and NN-intervals are synonymous (Tarvainen, 2014; Wiki). The use of "NN-intervals" is merely used to emphasize that normal R-peaks were used. 

- Heart rate variability:
  - [HRV standards,1996](https://www.ncbi.nlm.nih.gov/pubmed/8737210)
  - [wikipedia HRV](https://en.wikipedia.org/wiki/Heart_rate_variability)
  - [Heart rate variability – a historical perspective, 2011](https://www.frontiersin.org/articles/10.3389/fphys.2011.00086/full)
  - [An introduction to heart rate variability: methodological considerations and clinical applications, 2015](https://www.frontiersin.org/articles/10.3389/fphys.2015.00055/full#B1)
  

 - [PhysioZoo](https://physiozoo.com/)
    - Github [webpage](https://github.com/physiozoo)
	- Github [physiozoo](https://github.com/physiozoo/physiozoo)
    - Github [mhrv](https://github.com/physiozoo/mhrv) (main toolbox functions)
	  - follow "Usage" example: 
	    1. Initialize MATLAB environment of the mhrv tools: 
		```
		mhrv_init [-f/--force];
		```
		2. If there is no example dataset,download the mitdb/111 record from PhysioNet to local folder named 'db': 'download_wfdb_records('mitdb', '111', 'db')';
		   - [File Format](https://physionet.org/faq.shtml): 
		     - MIT Signal files (.dat) are binary files containing samples of digitized signals. These store the waveforms, but they cannot be interpreted properly without their corresponding header files. These files are in the form: RECORDNAME.dat.
			 - MIT Header files (.hea) are short text files that describe the contents of associated signal files. These files are in the form: RECORDNAME.hea.
			 - MIT Annotation files are binary files containing annotations (labels that generally refer to specific samples in associated signal files). Annotation files should be read with their associated header files. If you see files in a directory called RECORDNAME.dat, or RECORDNAME.hea, any other file with the same name but different extension, for example RECORDNAME.atr, is an annotation file for that record.
		3. Run HRV analysis: mhrv('db/mitdb/111', 'window_minutes', 15, 'plot', true);

	    - Notes: missing padarray function (image processing toolbox); here using several online functions ([padarray.m](padarray.m) calls [checkstrs.m](checkstrs.m) and [mkconstarray.m](mkconstarray.m)) to substitute.
      - test the online dataset: [Stress Recognition in Automobile Drivers](https://physionet.org/physiobank/database/drivedb/)
 
 - Other softwares
	- Kaufmann, 2011: [ARTiiFACT](http://www.artiifact.de/) 
	- Vollmer, 2017 (HRVTool v0.99 from Github): [MarcusVollmer/HRV](https://github.com/MarcusVollmer/HRV)
	- PhysioNet, 2016: [WFDB Toolbox for MATLAB and Octave](https://www.physionet.org/physiotools/matlab/wfdb-app-matlab/)
 
 
 - Other reading
   - from imotions: [HRV and brain](https://imotions.com/blog/heart-rate-variability/)
