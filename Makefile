include /framework/makefiles/common.mk

TWEAK_NAME = Swype
Swype_FILES = Tweak.xm SwypeModel.m SwypeController.m SwypeScribbleView.m CGPointWrapper.m
Swype_FRAMEWORKS = Foundation UIKit CoreGraphics

include /framework/makefiles/tweak.mk

