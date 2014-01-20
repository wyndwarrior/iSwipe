#import <UIKit/UIKit.h>
#import "headers/UIKeyboardLayoutStar.h"
#import "headers/UIKeyboardImpl.h"
#import "headers/UIKeyboard.h"
#import "headers/UIKBKey.h"
#import "headers/UIKBKeyView.h"
#import "ISScribbleView.h"
#import "ISSuggestionsView.h"
#import "CGPointWrapper.h"
#import "ISData.h"

@class ISSuggestionsView;
@interface ISController : NSObject {
    int matchLength;
}
@property (nonatomic, strong) ISSuggestionsView *suggestionsView;
@property (nonatomic, strong) ISScribbleView *scribbleView;
@property (nonatomic, strong) ISData *swipe;
@property (nonatomic, readonly) BOOL isSwyping;
//@property (nonatomic, assign) BOOL charAdded;

+ (ISController *)sharedInstance;

- (void)forwardMethod:(id)sender sel:(SEL)cmd touches:(NSSet *)touches event:(UIEvent *) event;

- (void)addInput:(NSString *)input;
- (void)kbinput:(NSString *)input;

- (void)deleteChar;
- (void)deleteLast;

@end