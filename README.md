#SFC　特設授業　2018 「データ・ドリブンアート」
### 筧泰明、真鍋大度、藤井新谷  


#### はじめに

OpenBCIをインストールする

EMSを繋いでから、
1.MultiEMS_system_channel.maxpat を開きます。
こちらにあるチャンネルのトグルを on/ off にすることによって、繋いであるチャンネルに対応しているEMSの機械を通して電気を流すことができます。


#### Openframeworks

- FFT_OpenBCIReceiverExample
- FFT_OpenBCIDataFilter
- receiveTimeseries
- OpenBCIExportWithLabel


OpenBCI -> Openframeworks -> piripiriデバイス

#### Processing
- openbci_osc_example
- openbci_osc_example_timeseries
- openbci2serial

#### Maxmsp
MultiEMS_system_channel.maxpat　でチャンネルの on/off

openbci_osc_example.maxpat で OpenBCI -> Maxmsp -> piripiriデバイス


### Dependencies 
* ofxOpenBCI
* ofxFaceTracker

