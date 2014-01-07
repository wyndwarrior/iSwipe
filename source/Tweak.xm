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
    //id del = [[UIKeyboardImpl activeInstance] delegate];
    //NSString *s1 = [del text];
    %orig;
    //NSString *s2 = [del text];
    
    //[ISController sharedInstance].charAdded = ![s1 isEqualToString:s2];
    
    [[ISController sharedInstance] forwardMethod:self sel:_cmd touches:touches event:event];
}
%end

/*%hook UIKBKey
-(NSArray*) variantKeys{
    if([ISController sharedInstance].isSwyping) return nil;
    return %orig;
}
%end*/


%hook UIKeyboard
-(void)removeFromSuperview{
    [[ISController sharedInstance] shouldClose:nil];
    %orig;
}
%end

%hook UIKBKeyView
-(id)initWithFrame:(CGRect)frame keyboard:(id)keyboard key:(UIKBKey*)key state:(int)state{
    self = %orig;
    [[ISController sharedInstance].kbkeys addObject:self];
    if( [ISController sharedInstance].isSwyping && (state == 16 || state == 1) && [[key displayString] length] == 1)
        [self setHidden:YES];
    return self;
}
%end

/*%hook SBApplicationIcon
-(void)launch{
    if([[[self application] bundleIdentifier] isEqualToString:@"com.wynd.iswipe.add"]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Add Word" message:@"Must consist of letters from the English alphabet." delegate:[SwypeController sharedInstance] cancelButtonTitle:@"Cancel" otherButtonTitles:@"Add", nil];
        [alert addTextFieldWithValue:@"" label:nil];
        [alert show];
        [alert release];
    }else
        %orig;
}

%end*/