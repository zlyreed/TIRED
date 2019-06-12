## VMG analysis

### filtering:
- In general:
  - [The Scientist and Engineer's Guide to Digital Signal Processing](http://www.dspguide.com/pdfbook.htm)
  - Cognitive and Neural Dynamics Lab Tutorials: 
    - [Power Spectral Density (PSD)](https://nbviewer.jupyter.org/github/voytekresearch/tutorials/blob/master/Power%20Spectral%20Density%20and%20Sampling%20Tutorial.ipynb)
    - [Neuro Digital Signal Processing Toolbox](https://neurodsp-tools.github.io/neurodsp/)
	- [Filtering examples with pictures and python code](https://neurodsp-tools.github.io/neurodsp/auto_tutorials/plot_1-Filtering.html#sphx-glr-download-auto-tutorials-plot-1-filtering-py)

### Literature
- [Zhang and Herzog, 1992](https://www.ncbi.nlm.nih.gov/pubmed/1452170): 
  - used two miniature accelerometers (Dytran 3015A);
  - The signals were conditioned with bandpass filters with band widths 3-100Hz for the VMG and 10-300 Hz for EMG
  - the study indicates that the averaged median frequency (MF) (6-24 Hz) and peak frequency (PF) (9-19 Hz) of the VMG signals are much lower than the MF (75-109 Hz) and PF (40-80 Hz) of the EMG signals.
- [Herzog, 1994](https://www.ncbi.nlm.nih.gov/pubmed/7935522): 
  - The purpose of this study was to investigate the behavior of electromyographical (EMG) and vibromyographical (VMG) signals in the time and frequency domains during a fatigue protocol. EMG and VMG records were obtained from the rectus femoris (RF) and vastus lateralis (VL) muscles of 11 adult male subjects during sustained, isometric knee extensor contractions performed at 70% of maximal voluntary contraction (MVC). The average median frequencies of the power density spectra decreased during the fatigue protocol for the EMG (from 73 to 54 Hz for RF, and from 75 to 57 Hz for VL) and the VMG signals (from 40 to 19 Hz for RF, and from 25 to 12 Hz for VL). Raw EMG signals remained the same qualitatively throughout the fatigue protocol, whereas corresponding VMG records appeared to become "smoother." The results of this study indicate that the pronounced decrease in the high-frequency content of the VMG signal may be observed in the time domain as a "smoothing" of the signal, and thus, that the raw VMG records (which may be displayed readily online) can be used to assess qualitatively the onset and progression of muscular fatigue.
  - When a muscle is fatigued, MF of 12-19 Hz are measured. At least part of the vibrations recorded in this situation are caused by a low-frenqency shaking of the limb, sometimes referredd to as tremor. Tremor is casued by contractions of all the muscles invovlved in a task, not only the muscles from which VMG recordings are obtained... The frequencies of the "pure" VMG (about 10-30Hz) and the frequencies of the phyiological tremor (about 1-25 Hz) overlap...
- [Yoshitake, et al., 2001](https://www.ncbi.nlm.nih.gov/pubmed/?term=11320632)
  - The MMG was detected by a specially designed microphone sensor (10 mm in diameter, mass 5 g, Daia Medical, Japan) with a flat frequency response between 5 Hz and 2000 Hz.
  - The root mean square amplitude value (RMS) of the EMG signal was significantly increased at the initial phase of contraction and then fell significantly, while mean power frequency (MPF) of the EMG signal decreased significantly and progressively as a function of time. There were also significant initial increases in RMS-MMG that were followed by progressive decreases at the end of fatiguing contractions. MPF-MMG remained unchanged. 
		