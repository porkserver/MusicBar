TARGET = iphone:clang:10.3:10.0
ARCHS = arm64
FINALPACKAGE = 1

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = MusicBar
MusicBar_FILES = MusicBar.xm $(wildcard *.m)
MusicBar_FRAMEWORKS = UIKit MediaPlayer
MusicBar_PRIVATE_FRAMEWORKS = MediaPlayerUI MediaRemote
#MusicBar_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk

before-stage::
	find . -name ".DS_Store" -delete

after-stage::
	$(ECHO_NOTHING)find $(FW_STAGING_DIR) -iname '*.png' -exec pincrush-osx -i {} \;$(ECHO_END)

after-install::
	install.exec "killall -9 SpringBoard"
