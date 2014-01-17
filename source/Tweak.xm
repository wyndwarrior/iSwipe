#import <UIKit/UIKit.h>
#import "headers/UIKeyboardLayoutStar.h"
#import "headers/UIKeyboardImpl.h"
#import "headers/UIKBKey.h"
#import "headers/UIKBKeyplaneView.h"
#import "ISController.h"

%hook UIKBKeyplaneView
	
// state == 2 => normal
// state == 4 => pressed
- (void)setState:(int)arg1 forKey:(id)arg2 {
	if (![ISController sharedInstance].isSwyping) {
		%orig;
	} else {
		%orig(2,arg2);
	}
}
	
/*- (int)stateForKey:(id)arg1 {
	// state == 2 => normal
	// state == 4 => pressed
	
	if (![ISController sharedInstance].isSwyping) {
		return %orig;
	}
	
	return 2;
}*/
	
%end

%hook UIKeyboardImpl

- (void)longPressAction {
	if (![ISController sharedInstance].isSwyping) {
		%orig;
	}
}
	
%end

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

- (void)setFrame:(CGRect)frame {
	%orig;
	// Fix the size and position of the suggestionview
	[ISController sharedInstance].suggestions.frame = CGRectMake(0, frame.origin.y-30, frame.size.width, 30);
}
%end

%hook UIKBKeyView
-(id)initWithFrame:(CGRect)frame keyboard:(id)keyboard key:(UIKBKey*)key state:(int)state{
	exit(0);
    self = %orig;
	if (self) {
		NSLog(@"UIKBKeyView subviews: %@",self.subviews);
	    [[ISController sharedInstance].kbkeys addObject:self];
	    if ([ISController sharedInstance].isSwyping && (state == 16 || state == 1) && [[key displayString] length] == 1) {
	        [self setHidden:YES];
		}
	}
    return self;
}
%end