include /framework/makefiles/common.mk

TWEAK_NAME = Swype
Swype_FILES = Tweak.xm SwypeModel.m SwypeController.m SwypeScribbleView.m CGPointWrapper.m SwypeSuggestionsView.m
Swype_FRAMEWORKS = Foundation UIKit CoreGraphics QuartzCore

include /framework/makefiles/tweak.mk

