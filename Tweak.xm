#import <UIKit/UIKeyboardLayoutStar.h>
#import <UIKit/UIKBKey.h>
#import <SpringBoard/SpringBoard.h>
#import <Foundation/NSTask.h>
#import "SwypeController.h"

%hook UIKeyboardLayoutStar

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    %orig;
    UITouch *touch = [touches anyObject];
    NSString *key = [[self keyHitTest:[touch locationInView:touch.view]] displayString];
    [[SwypeController sharedInstance] addKey:key state:@"DidStart" sender:self touches:touches];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    %orig;
    UITouch *touch = [touches anyObject];
    NSString *key = [[self keyHitTest:[touch locationInView:touch.view]] displayString];
    [[SwypeController sharedInstance] addKey:key state:@"DidMove" sender:self touches:touches];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    %orig;
    UITouch *touch = [touches anyObject];
    NSString *key = [[self keyHitTest:[touch locationInView:touch.view]] displayString];
    [[SwypeController sharedInstance] addKey:key state:@"DidEnd" sender:self touches:touches];
}
%end

%hook UIKBKey

-(NSArray*) variantKeys{
    if([SwypeController sharedInstance].isSwyping) return nil;
    return %orig;
}

%end

%hook UIKBKeyView

-(id)initWithFrame:(CGRect)frame keyboard:(UIKBKeyboard*)keyboard key:(UIKBKey*)key state:(int)state{
    self = %orig;
    [[SwypeController sharedInstance].kbkeys addObject:self];
    return self;
}

%end

%hook SBUserInstalledApplicationIcon
-(void)launch{
    if(![[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithFormat:@"%@/.swype/enabled", [[self application] path]]])
        [[SwypeController sharedInstance] performSelectorInBackground:@selector(copyDictionary:) withObject:[[self application] path]];
    %orig;
}
%end

static __attribute__((constructor)) void kbloggerinit() {
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	%init;
	[SwypeController sharedInstance];
	[pool release];
}