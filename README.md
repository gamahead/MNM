MNM
===

Me/Not-me Paradigm Psychology Experiment

A simple matlab application for performing the me/not-me experiment with a given list of potential characteristics

PsychToolbox install instructions for windows:
==

1) Install subversion 32 bit: http://www.sliksvn.com/en/download

2) Install the GStreamer Runtime and Dev Files: http://docs.gstreamer.com/display/GstSDK/Installing+on+Windows

3) Create a folder called 'toolbox' in C:

4) Download the DownloadPsychtoolbox installer to C:\toolbox - https://raw.github.com/Psychtoolbox-3/Psychtoolbox-3/master/Psychtoolbox/DownloadPsychtoolbox.m

5) Open Matlab

6) At the command line, type: 
```matlab
>> cd C:\toolbox
>> DownloadPsychtoolbox('C:\toolbox')
```

Running MNM:
===

Make sure you are in the MNM directory and simply type "main" at the matlab command line

### Specific instructions for the Jamieson Lab:

type 
```matlab
>> cd C:\Users\jamiesonlab\Documents\GitHub\MNM
>> main
```

The program should then display a popup dialog asking for the subject's id and condition