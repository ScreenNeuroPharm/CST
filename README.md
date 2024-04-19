# CST
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](https://github.com/ScreenNeuroPharm/CST/blob/master/LICENSE)

> The repository contains the data and the functions need to reproduce the analysis reported in the article "Cortical, striatal, and thalamic populations self-organize into a functionally connected circuit with long-term memory properties".

## Details
All uploaded scripts work with a .mat format. 
To reproduce our analysis is necessary to convert the ```.txt``` format file in ```.mat``` format file using the function ```TxT2Mat.m``` in the folder Conversion. 
All electrophysiological recordings are sampled at 10 KHz. 
```TxT2Mat.m``` function allows obtaining for each electrode (60) the peak train .mat file. 
Peak_train file is a sparse vector that reports the spike occur, saving the spike amplitudute.
