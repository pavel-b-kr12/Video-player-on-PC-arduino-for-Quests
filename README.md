# Video-player-on-PC-arduino-for-Quests
Run videos with sound on display, connected to computer, corresponding to arduino pins and switch relays after each videos end. Operator can choose set of video e.g. with different language.  Useful for quest rooms. 

## Install:
Upload standart Firmata (or HEX file in this repo) to Arduino ar other MCU. 
Connect MCU to PC via USB (or COM port). Install virtual serial  (COM) port driver if need.
Open and run pde file with Processing software or run **Video-player-on-PC-arduino-for-Quests.exe** file.
put video in "Data" folder near .exe
Rename video to "e0.avi" where "e" is prefix . 0 is counter related to MCU pin.

## Usage:
Connect A0..A7 pins with GND to start video
Press PC keyboard (english) q w e r t y u i o p to select and save video prefix e.g.  "e0.avi" (mean english №0)
Watch video and after it feel change from +5v to 0 on output pins.
Play file manually via pressing PC keyboard 1 2 3 4 5 6 7 (1 is correspond to file "0.avi")

## Hardware:
PC with USB or COM port. Enough CPU power to play video (java is not fast). 

Any MCU with Firmata can be supported. Tested with Nano/ pro mini 328. To use atmega168 you need to delete unused stuff from Firmata.

(In this version: Disable any unused COM-port in bios if available. Port to arduino have to be first in list.)

pins A0-A8 for input and must pull-up. Activated by LOW level.

pins D2-D10 for output LOW level. Best use with china Blue (low-level) 5v 8-chennel relay modules.


## Software:
any OS that can run Processig (Java)
Standart Firmata on Arduino board


## File format:
any supported by GStreamer/ processing.video. Almost any working.


## TODO: test which File format is fastest


