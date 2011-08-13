#import <UIKit/UIKeyboardLayoutStar.h>
#import <UIKit/UIKBKey.h>
#import <SpringBoard/SpringBoard.h>
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


%hook UIKeyboard
-(void)removeFromSuperview{
    [[SwypeController sharedInstance] shouldClose:nil];
    %orig;
}
%end

%hook UIKBKeyView
-(id)initWithFrame:(CGRect)frame keyboard:(UIKBKeyboard*)keyboard key:(UIKBKey*)key state:(int)state{
    self = %orig;
    [[SwypeController sharedInstance].kbkeys addObject:self];
    return self;
}
%end

%hook SBApplicationIcon
-(void)launch{
    if([[[self application] bundleIdentifier] isEqualToString:@"com.wynd.iswipe.add"]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Add Word" message:@"Must consist of letters from the English alphabet." delegate:[SwypeController sharedInstance] cancelButtonTitle:@"Cancel" otherButtonTitles:@"Add", nil];
        [alert addTextFieldWithValue:@"" label:nil];
        [alert show];
        [alert release];
    }else
        %orig;
}

%end