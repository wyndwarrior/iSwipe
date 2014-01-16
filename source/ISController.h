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
    NSMutableArray *kbkeys; //list of kbkeyviews to hide when swiping
    
    ISScribbleView *scribbles;
    ISData *swipe;
    
    bool show;
    bool lastShift;
    int matchLength;
}

@property (nonatomic, strong) ISSuggestionsView *suggestions;
@property (nonatomic, strong) ISScribbleView *scribbles;
@property (nonatomic, strong) ISData *swipe;
@property (nonatomic, strong) NSMutableArray *kbkeys;
@property (nonatomic, readonly) BOOL isSwyping;
@property (nonatomic, assign) BOOL charAdded;

+(ISController*)sharedInstance;

-(void)forwardMethod:(id)sender sel:(SEL)cmd touches:(NSSet *)touches event:(UIEvent *) event;
-(void)setupSwipe;
-(void)cleanSwipe;

//hide/show key conformation views
-(void)hideKeys;
-(void)showKeys;

-(void)shouldClose:(id)sender;
-(void)addInput:(NSString *)input;
-(void)kbinput:(NSString *)input;

-(void)deleteChar;
-(void)deleteLast;

@end