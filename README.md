# CuteAVR
The main file in this repository is [CuteAVR.pro](https://github.com/eng-mg/CuteAVR/blob/master/CuteAVR.pro) which allows you to write, build and/or deploy programs for AVR microcontrollers using [Qt creator IDE](https://www.qt.io/ide/).

###System requirements
 - [Qt framework](https://www.qt.io/download-open-source/): Only Qmake and [Qt creator](https://www.qt.io/ide/) is needed.
 - [AVR GNU Toolchain](http://www.atmel.com/tools/atmelavrtoolchainforwindows.aspx).
 - [avrdude](http://savannah.nongnu.org/projects/avrdude/). (Optional)

##How to use it...
 1. Open Qt creator and make new empty qmake project.
   - Click *File menu* the click *New file or project* then choose *Other Project* then *Empty qmake project*. This will create an empty project which has an empty Qt project (.pro) file.
 2. Open [CuteAVR.pro](https://github.com/eng-mg/CuteAVR/blob/master/CuteAVR.pro) file in any text editor and copy it's contents to your empty Qt project (*.pro) file.
 3. Change the contents of your .pro file to match your needs. Note that you need to run qmake everytime you change the .pro file to allow the changes to take effect.
 4. Add C files and and header files to your new qt creator project as usual.
 5. Write code then build it *aaaaaaaaand Have Fun*.

#### What you need to change in the .pro file
This is a list of some important qmake variables and configuration directives that you need to worry about before building the project. Most of these configurations need to be set only once and don't change 
 1. **MCU = atmega328p**: set the variable MCU to the part number of the AVR microcontroller you're using. (atmega328p is the default).
 2. **CONFIG += upload_hex**: This line is used to tell qmake to generate an *upload step* after building the source code. in the upload step qmake uses avrdude tool to upload the resulted .hex file to the avr microcontroller you're using. ***If you don't want this step to be executed comment this line out (i.e precede it with a #)***
 3. **AVR_TOOLCHAIN_DIR = ""**: Use this qmake variable to tell qmake where to find avr-gnu toolchain directory in your system.
 4. **UPLOADER_DIR = ""**: use this qmake variable to tell qmake where your uploader (avrdude) binary lives in your system.
 5. **UPLOADER_PORT = ""**: Tell qmake you're connecting your programmer to which port.

