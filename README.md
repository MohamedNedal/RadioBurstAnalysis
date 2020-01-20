# Solar Radio Burst Analysis 
This repository is dedicated to analyzing data of solar radio bursts obtained from the CALLISTO spectrometer and applying electron density models to calculate the parameters of the coronal shock waves associated with the CME. It is mainly for type-II radio bursts. 


The main language is MATLAB. 

This work is inspired from the IDL code of Pietro Zucca and the Python code of Christian Monstein. 

### Describtion 
##### R_7.fit: a type-II radio burst event obtained from CALLISTO website. 
##### newkirk.m: the Newkirk electron density model (Newkirk, 1961). 
##### callisto_single.m: a function for single-band (without band-splitting). 
###### [n,r,f,t] = callisto_single(filename,pointsNum,activity_deg,f_or_hr) 
##### where 
###### n: the electron density (#/cm^-3). 
###### r: source height of emission (in solar radii). 
###### f: plasma frequency (MHz). 
###### t: time of observation (s). 
###### filename: the file name of the data file from CALLISTO (format: Flexible and Interoperable Data Transfer - FIT). 
###### pointsNum: the number of data points obtained. 
###### activity_deg: the degree of solar activity (1: low - 4: high). 
###### f_or_hr: press 1 for fundamental band, or press 2 for harmonic band. 
##### callisto_bandsplit.m: a function for band-splitting events. 
###### [f1,f2,n1,n2,r1,r2,t] = callisto_bandsplit(filename,pointsNum,activity_deg,f_or_hr,bandsplit) 
##### where 
###### f1: plasma frequency from the lower frequency band (LFB). 
###### f2: plasma frequency from the upper frequency band (UFB). 
###### n1: electron density from LFB. 
###### n2: electron density from UFB. 
###### r1: source height from LFB. 
###### r2: source height from UFB. 
###### t: time of observation (s) - it is the same for both UFB and LFB. 
