## High Density EMG 

Prodcut:
 - [Bio elettronica](https://www.otbioelettronica.it/index.php?lang=en)
    - [Publications](https://www.otbioelettronica.it/index.php?option=com_content&view=article&id=54&Itemid=259&lang=en)
 - Delsys
   1. The [Neuromap](https://www.delsys.com/neuromap/) system – which uses our Galileo sensor to extract Neural Firings from Individual Motor Units during functional movements. This is a mini-grid system that has its own software (API also available/included) and the primary use is for motor unit data. It is available now.
      - [MU-based simulation of muscle fatigue](https://www.delsys.com/neuromap/simulation/)
   2. The maize system is a 16ch grid sensor that like all other avanti sensors (including galileo/Neuromap), will be compatible with the Trigno wireless receiver. Est release is closer to fall 2019. Estimated cost $6K
   3. The Tiber system is a 64ch grid system that will also be wireless, but will have its own dedicated receiver. Est release end of 2019, early 2020. I don’t have any pricing on this as yet.

 
	
References using HD EMG:
 - Central and peripheral **fatigue** in knee and elbow extensor muscles after a long-distance cross-country ski race.[Boccia, 2017](https://www.ncbi.nlm.nih.gov/pubmed/?term=Central+and+peripheral+fatigue+in+knee+and+elbow+extensor+muscles+after+a+long-distance+cross-country+ski+race)
 - Severe COPD Alters Muscle Fiber Conduction Velocity During Knee Extensors Fatiguing Contraction (Boccia, 2016)
 - Muscle Activity Adaptations to Spinal Tissue Creep in the Presence of Muscle Fatigue [(Abboud, 2016)](https://www.ncbi.nlm.nih.gov/pubmed/26866911)
 - Mechanisms of Fatigue and Recovery in Upper versus Lower Limbs in Men. [(Vernillo, 2018)](https://www.ncbi.nlm.nih.gov/pubmed/28991037)
 - Electromechanical delay components during relaxation after voluntary contraction: Reliability and effects of fatigue. [(Ce, 2014)](https://www.ncbi.nlm.nih.gov/pubmed/?term=Electromechanical+delay+components+during+relaxation+after+voluntary+contraction%3A+Reliability+and+effects+of+fatigue)
 - Motor unit activity, force steadiness, and perceived fatigability are correlated with mobility in older adults.[(Mani and Enoka, 2018)](https://www.ncbi.nlm.nih.gov/pubmed/?term=motor+unit+activity%2C+force+steadiness%2C+and+perceived+fatigability)
   - HD EMG: W-EMG; Bitro, Turin, Italy; 32 electrons (8 rows X 4 columns); placed on medial gastrocnemius,soleus and tibialis anterior
   - a custom decomposition algorithm (Holobar et al., 2010; Holobar and Zazula, 2007)
   - analysis: 
     - motor unit number
     - interspike interval (ISI; unit:ms): mean,coefficient of variation (%); [ ISI distribution skewness (degree of symmetry)](https://en.wikipedia.org/wiki/Skewness) and [ISI distribution kurtosis (breadth)](https://en.wikipedia.org/wiki/Kurtosis) 
 - Higher Neuromuscular Manifestations of Fatigue in Dynamic than Isometric Pull-Up Tasks in Rock Climbers.[(Boccia, 2015)](https://www.ncbi.nlm.nih.gov/pubmed/26557188)
   - HD EMG: OT, Bioeletronica, Torino, Italy; 8 electrods (5mm of interelctrode distance) and dry linear array of 16 electrodes (silver bar electrodes); placed on brachioradialis and teres major muscles
   - Muscle fiber conduction velocity (CV): The three single differential signals with higher similarity and propagation were used t oestimate muscle fiber CV [(Rainoldi, 1999)](https://www.ncbi.nlm.nih.gov/pubmed/?term=repeatability+of+surface+EMG+variables+during+voluntary+isometric+contractions+of+the+biceps+brachii+muscle). CVs were estiamted using two adjacent double differential signals (based on one triplet of single differential signals).
   - The rate of decrease of muscle fiber CV was found steeper in the dynamic than isometric task in both muscles. A sequence of dynamic pull-ups lead to higher fatigue than sustaining the body weight in an isometric condition at half-way of pull-up.
   