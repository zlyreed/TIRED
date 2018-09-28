**ECG**

- Some basic [terms](https://www.physionet.org/tutorials/hrv/#hr-extraction)
  - [QRS](https://en.wikipedia.org/wiki/QRS_complex): The QRS complex is a name for the combination of three of the graphical deflections seen on a typical electrocardiogram (EKG or ECG). In other words, it's the main spike seen on an ECG line.
    
	<img src="pics/QRS.png" alt="drawing" width="400"/>
  - [R-R interval](https://emedicine.medscape.com/article/2172196-overview)
    ![R-R-interval-trace.png](pics/R-R-interval-trace.png "R-R-interval-trace")
  - NN interval (normal-to-normal interval; filter RR intervals to produce NN intervals): all intervals between adjacent QRS complexes resulting sinus node depolarization.

- Heart rate variability:
  - [HRV standards,1996](https://www.ncbi.nlm.nih.gov/pubmed/8737210)
  - [wikipedia HRV](https://en.wikipedia.org/wiki/Heart_rate_variability)
  - [Heart rate variability – a historical perspective, 2011](https://www.frontiersin.org/articles/10.3389/fphys.2011.00086/full)
  - [An introduction to heart rate variability: methodological considerations and clinical applications, 2015](https://www.frontiersin.org/articles/10.3389/fphys.2015.00055/full#B1)
  
 - HRV software [ARTiiFACT](http://www.artiifact.de/)
 - [PhysioZoo](https://physiozoo.com/)
    - Github [webpage](https://github.com/physiozoo)
    - Github [mhrv](https://github.com/physiozoo/mhrv) (try this one first)
      - test the online dataset: [Stress Recognition in Automobile Drivers](https://physionet.org/physiobank/database/drivedb/)
      - Github[physiozoo](https://github.com/physiozoo/physiozoo)
 - Github [MarcusVollmer/HRV](https://github.com/MarcusVollmer/HRV): 
   - follow "Usage" example: missing padarray function (image processing toolbox); here using several online functions ([padarray.m](padarray.m) calls [checkstrs.m](checkstrs.m) and [mkconstarray.m](mkconstarray.m)) to substitute
 - [WFDB Toolbox for MATLAB and Octave](https://www.physionet.org/physiotools/matlab/wfdb-app-matlab/)
 
 
 - Other reading
   - from imotions: [HRV and brain](https://imotions.com/blog/heart-rate-variability/)
