
#skfly add begin
THEOS_DEVICE_IP = 192.168.0.70
#skfly add end


ARCHS := armv7 arm64

include theos/makefiles/common.mk

TWEAK_NAME = SSLKillSwitch2
SSLKillSwitch2_FILES = SSLKillSwitch/SSLKillSwitch.m ./public/skfly_utility.m

SSLKillSwitch2_FRAMEWORKS = Security

SSLKillSwitch2_LIBRARIES += substrate_armv7


# Build as a Substrate Tweak
#SSLKillSwitch2_CFLAGS=-DSUBSTRATE_BUILD
SSLKillSwitch2_CFLAGS = -ferror-limit=102400 -Ipublic -Wno-error -Wno-implicit-function-declaration -O0 -fstandalone-debug -gdwarf-2

include $(THEOS_MAKE_PATH)/tweak.mk
include $(THEOS_MAKE_PATH)/aggregate.mk


after-install::
	# Respring the device
	install.exec "killall -9 SpringBoard"