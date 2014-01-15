#import <UIKit/UIKit.h>
#import "headers/UIKeyboardLayoutStar.h"
#import "headers/UIKeyboardImpl.h"
#import "headers/UIKBKey.h"
#import "ISController.h"

%hook UIKeyboardLayoutStar
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    %orig;
    [[ISController sharedInstance] forwardMethod:self sel:_cmd touches:touches event:event];
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    %orig;
    [[ISController sharedInstance] forwardMethod:self sel:_cmd touches:touches event:event];
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    %orig;
    [[ISController sharedInstance] forwardMethod:self sel:_cmd touches:touches event:event];
}
%end

%hook UIKeyboard
-(void)removeFromSuperview{
    [[ISController sharedInstance] shouldClose:nil];
    %orig;
}
%end

%hook UIKBKeyView
-(id)initWithFrame:(CGRect)frame keyboard:(id)keyboard key:(UIKBKey*)key state:(int)state{
    self = %orig;
	if (self) {
	    [[ISController sharedInstance].kbkeys addObject:self];
	    if ([ISController sharedInstance].isSwyping && (state == 16 || state == 1) && [[key displayString] length] == 1) {
	        [self setHidden:YES];
		}
	}
    return self;
}
%end