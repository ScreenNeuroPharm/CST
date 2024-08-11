# CST

[![License](https://img.shields.io/badge/license-MIT-blue.svg)](https://github.com/ScreenNeuroPharm/CST/blob/master/LICENSE)

> The repository contains the data and the functions needed to reproduce the analysis reported in the article "Cortical, striatal, and thalamic populations self-organize into a functionally connected circuit with long-term memory properties".

## Details
All uploaded scripts work with either a .mat or a .py format. 
To reproduce our analysis is necessary to convert the ```.txt``` format file in ```.mat``` format file using the function ```TxT2Mat.m``` in the folder Conversion. 
All electrophysiological recordings are sampled at 10 KHz. 
```TxT2Mat.m``` function allows obtaining for each electrode (120) the peak train .mat file. 
Peak_train file is a sparse vector that reports the spike occurring, saving the spike amplitude.

### Code folder architecture:
- BurstAnalysis folder:
    * burstFeaturesAnalysis: functions to obtain the burst feautures
    * StringMethod: functions to detect the burst
    * BurstingIndex: function to compute burstiness index

- Conversion folder:
    * Txt2Mat: function to convert ```.txt``` format file in ```.mat``` format file

- Entropy folder:
    * MemoryIndex_EntropyValue: function to extract entropy values

- Modules folder: 
containes the function to estract the temporal sequences and the number of modules

- NetworkBurstAnalysis folder: 
    * NetBurstDetection: functions for the Network Burst Detection


- SpikeAnalysis folder:
    * MFR: function to compute the Mean Firing Rate


- Utilities folder: supplementary functions

      
- StatsAnalysis folder (python 3.8 scripts, they take in input the outputs of the Matlab data extraction scripts):
    * Stats_Spiking_Bursting.py: functions to compute p values with kruskal-wallis (MFR, MBR, MFIB, RS)
    * Stats_Network_Burst_Duration.py: functions to compute p values with kruskal-wallis
    * Stats_Compartments_Involved.py: functions to compute p values with kruskal-wallis
    * Stats_Compartment_Leader.py: functions to compute p values with kolmogorov-smirnov
    * Stats_All_Strong_Connections.py: functions to compute p values with kruskal-wallis
    * Stats_Inter_Intra_Length_Connections.py: functions to compute Bhattacharya Distance
    * Stats_Path_Length.py: functions to compute p values with kruskal-wallis
    * Stats_Clustering_Coefficient.py: functions to compute p values with kruskal-wallis
    * requirements.txt: version of python packages and libraries used in the scripts

=======
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](https://github.com/ScreenNeuroPharm/CST/blob/master/LICENSE)

> The repository contains the data and the functions need to reproduce the analysis reported in the article "Cortical, striatal, and thalamic populations self-organize into a functionally connected circuit with long-term memory properties".

## Details
All uploaded scripts work with a .mat format. 
To reproduce our analysis is necessary to convert the ```.txt``` format file in ```.mat``` format file using the function ```TxT2Mat.m``` in the folder Conversion. 
All electrophysiological recordings are sampled at 10 KHz. 
```TxT2Mat.m``` function allows obtaining for each electrode (60) the peak train .mat file. 
Peak_train file is a sparse vector that reports the spike occur, saving the spike amplitudute.
>>>>>>> f2bb79d0542cfecfcf46da0dcb7f8100176e54e9
