# Video-player-on-PC-arduino-for-Quests
Run videos with sound on display, connected to computer, corresponding to arduino pins and switch relays after each videos end. Operator can choose set of video e.g. with different language.  Useful for quest rooms. 


#Hardware:
PC with USB or COM port. Enough CPU power to play video (java is not fast). 

Any MCU with Firmata can be supported. Tested with Nano/ pro mini 328. To use atmega168 you need to delete unused stuff from Firmata.

(In this version: Disable any unused COM-port in bios if available. Port to arduino have to be first in list.)

pins A0-A8 for input and must pull-up. Activated by LOW level.

pins D2-D10 for output LOW level. Best use with china Blue (low-level) 5v 8-chennel relay modules.


#Software:
any OS that can run Processig (Java)
Standart Firmata on Arduino board


#File format:
any supported by GStreamer/ processing.video. Almost any working.


#TODO: test which File format is fastest


