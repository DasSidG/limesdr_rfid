# limesdr_rfid

This repo contains a collection of code related to using the LimeSDR as a passive UHF RFID reader, to read tags compliant with the EPC Global Gen 2 Class 1 standard. It includes:

1. A version of the [Lime Suite](https://github.com/myriadrf/LimeSuite) drivers (taken at [commit fe53178](https://github.com/myriadrf/LimeSuite/tree/fe53178a3c74ce983ca8314c582c0547f723ec20)) edited for use as a passive UHF RFID reader.
2. A GNU Radio flowgraph to use the LimeSDR as a Gen2 passsive UHF RFID reader
3. A MATLAB script useful for decoding RFID communications.



## Setup

In order to use this GNU Radio program, the following programs must be installed, in the following order (if LimeSuite is installed before SoapySDR, it will not install SoapyLMS7 as well, which is needed):

1. [SoapySDR](https://github.com/pothosware/SoapySDR/wiki/BuildGuide)

2. [LimeSuite](https://github.com/myriadrf/LimeSuite) (installed from the version of drivers provided in this limesdr_rfid repository,  but using the instructions in the given link)

3. [GNU Radio](https://www.gnuradio.org/)

4. [SoapyUHD](https://github.com/pothosware/SoapyUHD)

5. [Gen2 Reader Library by Nikos Kargas](https://github.com/nkargas/Gen2-UHF-RFID-Reader/)

Follow the installation instructions provided in each link.

Then, copy the ```lime_reader.py``` file provided here into the ```Gen2-UHF-RFID-Reader/gr-rfid/apps/``` directory of the Gen2 Reader library.

## Running the GNU Radio flowgraph

The GNU Radio script needs to be run in such a way that real-time scheduling is enabled in GNU Radio. This is achieved by running the script in the following way:
```
cd Gen2-UHF-RFID-Reader/gr-rfid/apps/
sudo GR_SCHEDULER=STS nice -n -20 python ./lime_reader.py
```

For more details on the implementation of the Gen2 Reader Library, see the readme of the [github page](https://github.com/nkargas/Gen2-UHF-RFID-Reader/) 

## Modified version of the Lime Suite drivers

Changes were made to the SoapyLMS7 section of the Lime Suite drivers, in order to enable the RFID reader to work successfully. These changes are labelled in the code with 'SID' (alternatively, a diff could be taken between this version of the drivers and the original). Additional lines of code have also been added in order to aid in debugging (some of these are commented out, but can be re-enabled if desired). Note that some of the changes weren't actually used in the final version of the drivers (i.e. they are in functions which never end up being called), but I unfortunately no longer have access to the LimeSDR and so cannot safely say which ones are or are not necessary. This version of the drivers is what was used for the experiments discussed in the report. Most of the changes have print statements associated with them, so it should hopefully be clear with a bit of investigation which are active and which are not. Apologies for this laziness!

This modified driver set is based on quite an old version of the Lime Suite drivers (~December 2017), so I would recommend modifying a more modern set of the drivers in the same way as this was modified, rather than just using this set of drivers as it is. It's possible that some of the problems that these modifications solve have already been solved in updates since.

## RFID decoder MATLAB script

A MATLAB script is provided here which can be used to analyse the raw samples present in the file_sink block after a test has been run. It can deduce the following information:

1. Durations of communication blocks
2. Latency between communication blocks
3. Number of successful/failed communication blocks
4. Decoding of RN16s, ACKs, and EPCs
5. Number of EPCs returned

However, the script is a bit simplistic, and so suffers from the following drawbacks:

1. It is slow to run. For around 100 MB worth of samples, it takes around 5 minutes to run on an (admittedly fairly old) computer.
2. While the framework is there for checking whether EPCs are valid (i.e. checking the CRC), a proper CRC check function was not implemented. Currently the script just compares a section of the EPC to a fixed EPC from a known tag. This could probably be implemented fairly easily however.
3. The script does not work very well when the signal to noise ratio is not very high, as it uses rather simplistic techniques to locate communication blocks and decode them.
4. The script currently only acknowledges the existence of QUERY, RN16, ACK, and EPC commands.

I hope the script can provide at least the starting point for a useful tool for analysing and debugging RFID communications.

## Report

This investigation was the basis of a final year project for an engineering degree; a report on the project is included in this repo. The report details the rationale behind the changes made to the SoapyLMS7 drivers and this particular choice of software stack (i.e. via OsmoSDR is not used). The report also discusses some experiments carried out to evaluate the performance of the RFID reader resulting from this implementation.

## Disclaimer

I was and still am very much a complete beginner to SDR when carrying out this project. It is possible (indeed likely) that some of the methods or conclusions presented in my report are not correct. If considering using the LimeSDR for RFID, I hope you find this code useful, but please perform your own experiments for evaluation of the LimeSDR performance for your particular purpose, as I cannot guarantee the veracity of the particular figures presented in the report.

## Support

As I no longer have access to a LimeSDR, there is not a huge amount of support I can give, and I don't really intend to work on it further. However, I am perfectly happy to answer any questions about my report and/or the modifications I made to the drivers. Feel free to email me ```gupta.siddharth96@gmail.com```, or better yet, ask it in the discourse thread (I will add a link to the thread once I have made it).

## Licensing

Please feel free to use this code however you wish, with whatever modifications you want, for whatever purpose; I take no responsibility for the performance of the code or any of the assertions I have made in the report.
