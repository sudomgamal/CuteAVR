TEMPLATE = app
CONFIG = ""

SOURCES += main.c

# Change this to match your AVR microcontroller's part number
MCU = atmega328p
#Comment the following line (using #) if you don't want to upload the output '.hex' file after building
CONFIG += upload_hex
#Comment the following (using #) if you don't want to upload the output '.hex' file after building
CONFIG += write_eeprom

#Comment the following line (using #) if you don't want to upload the output '.hex' file after building
#CONFIG += write_fuses
#set the fuses
#LFUSE = ""
#HFUSE = ""
#EFUSE = ""

#set the avr-gcc toolchain directory
AVR_TOOLCHAIN_DIR = "C:/Program Files (x86)/Atmel/Studio/7.0/toolchain/avr8/avr8-gnu-toolchain"
#set the uploader (avrdude) directory
UPLOADER_DIR = C:\Arduino\hardware\tools\avr\bin
#specify the serial port to which the programmer is connected
UPLOADER_PORT = COM2
#set the baud rate
UPLOADER_BAUD = 115200
#set the programmer
UPLOADER_PROGRAMMER = arduino
#set optimization level *avr-gcc oprimazations levels can be one of (0, 1, 2, s)*
COMPILER_OPTIMATZTION_LEVEL = 1
#Comment this line (using #) if you don't care to watch avr programs work
CONFIG += show_progs_excution

##################################################################################################
################# YOU SHOULDN'T NEED TO MODIFY THIS FILE AFTER THIS LINE #########################
##################################################################################################



VERBOS = "@"
show_progs_excution: VERBOS = ""

TARGET_EXT = .elf
OUTPUT_ELF = $$TARGET$$TARGET_EXT
OUTPUT_HEX = $${TARGET}.hex
OUTPUT_LST = $${TARGET}.lss
OUTPUT_EEP = $${TARGET}.eep

#toolchain setup
AVR_LIB_DIR       = $$AVR_TOOLCHAIN_DIR/avr/lib
AVR_INC_DIR       = $$AVR_TOOLCHAIN_DIR/avr/include
AVRC        = avr-gcc
AVRCXX      = avr-g++
AVR_LINKER  = avr-gcc
AVRSTRIP    = $${VERBOS}avr-strip
AVROBJCPY   = $${VERBOS}avr-objcopy
AVROBJDUMP  = $${VERBOS}avr-objdump
AVRSIZE     = @echo "---------------------------------------------------------------" && \
@echo "Size of each section (bytes):" && $${VERBOS}avr-size

#setup the upload tool (avrdude)
UPLOADER = $${UPLOADER_DIR}\avrdude.exe
UPLOADER_PARTNO = $$MCU
UPLOADER_ARGS = -c$$UPLOADER_PROGRAMMER -P$$UPLOADER_PORT -b$$UPLOADER_BAUD -p$$UPLOADER_PARTNO
UPLOADER_FLASH = -Uflash:w:"$$OUTPUT_HEX":i

# C compiler flags
CSTANDARD   = "-std=gnu99"
CDEBUG      = "-g2"
CWARN_OPTS  = "-Wall"
C_OTHER     = "-x c -MD -MP -MT \"$(OBJECTS)\" -funsigned-char -funsigned-bitfields -ffunction-sections -fdata-sections -fpack-struct -fshort-enums"
COPTIMIZE   = "-O$${COMPILER_OPTIMATZTION_LEVEL}"
CMCU        = "-mmcu=$$MCU"

AVR_CFLAGS  =   $$CSTANDARD $$CDEBUG $$CWARN_OPTS $$C_OTHER $$COPTIMIZE $$CMCU
AVR_LFLAGS  = "-Wl,-Map=\"$${TARGET}.map\" -Wl,--start-group -Wl,-lm  -Wl,--end-group -Wl,--gc-sections $$CMCU"

QMAKE_INCDIR = $$AVR_INC_DIR
QMAKE_LIBDIR = $$AVR_LIB_DIR
QMAKE_CC = $$AVRC
QMAKE_CXX = $$AVRCXX
QMAKE_LINK = $$AVR_LINKER
QMAKE_LFLAGS_RELEASE = $$AVR_LFLAGS
DEFINES = DEBUG
QMAKE_CFLAGS_RELEASE = $$AVR_CFLAGS
QMAKE_LFLAGS = ""
QMAKE_CFLAGS = ""

#additional avr-specific targets
avr_strip.target = .strip
#avr_strip.commands = $$AVRSTRIP $$OUTPUT_ELF
avr_strip.depends = all

avr_gen_hex.target = .genhex
avr_gen_hex.commands = $$AVROBJCPY  -O ihex -R .eeprom -R .fuse -R .lock -R .signature -R .user_signatures $$OUTPUT_ELF $$OUTPUT_HEX
avr_gen_hex.depends = avr_strip

avr_eeprom.target = .eeprom
avr_eeprom.commands = $$AVROBJCPY -j .eeprom  --set-section-flags=.eeprom=alloc,load\
 --change-section-lma .eeprom=0  --no-change-warnings -O ihex $$OUTPUT_ELF $$OUTPUT_EEP
avr_eeprom.depends = avr_gen_hex

avr_gen_lst.target = .genlst
avr_gen_lst.commands = $$AVROBJDUMP -h -S $$OUTPUT_ELF > $$OUTPUT_LST
avr_gen_lst.depends = avr_eeprom

avr_prntsize.target = .prntsize
avr_prntsize.commands = $$AVRSIZE $$OUTPUT_ELF
avr_prntsize.depends = avr_gen_lst

avr_upload.target = .avr_upload
avr_upload.depends = avr_prntsize
upload_hex {
avr_upload.commands = "$$UPLOADER $$UPLOADER_ARGS $$UPLOADER_FLASH"
}

avr_write_eeprom.target = .avr_write_eeprom
avr_write_eeprom.depends = avr_upload
write_eeprom {
avr_write_eeprom.commands = "$$UPLOADER $$UPLOADER_ARGS  $$UPLOADER_EEPROM"
}

avr_write_fuses.target = .avr_write_fuses
avr_write_fuses.depends = avr_write_eeprom
write_eeprom {
avr_write_fuses.commands = "$$UPLOADER $$UPLOADER_ARGS $$UPLOADER_FUSES"
}


first.depends = avr_write_fuses
QMAKE_EXTRA_TARGETS += first avr_strip avr_gen_hex avr_eeprom avr_gen_lst avr_prntsize\
 avr_upload avr_write_fuses avr_write_eeprom
#message("All done. Have fun with make")
