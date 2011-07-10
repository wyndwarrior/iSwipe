#import <UIKit/UIKeyboardLayoutStar.h>
#import <UIKit/UIKeyboardImpl.h>
#import <UIKit/UIKeyboard.h>
#import "SwypeScribbleView.h"
#import "SwypeSuggestionsView.h"
#import "CGPointWrapper.h"

@class SwypeSuggestionsView;
@interface SwypeController : NSObject {
    NSMutableArray *keys;
    NSMutableArray *entrancePoints;
    NSMutableArray *kbkeys;
    NSArray *matches;
    
    SwypeScribbleView *scribbles;
    SwypeSuggestionsView *suggestions;
    
    id theSender;
    BOOL didJustSwype;
    BOOL isSwyping;
    BOOL lastWasShift;
    int matchLength;
}
@property (nonatomic, retain) NSArray *matches;
@property (nonatomic, retain) NSMutableArray *kbkeys;
@property (nonatomic, readonly) BOOL isSwyping;

+(SwypeController*)sharedInstance;

-(void)addKey:(NSString*)key state:(NSString *)state sender:(id)sender touches:(id)touches;
-(void)addInput:(NSString *)input;
-(void)findMatch:(NSArray *)input;

-(void)hideKeys;
-(void)showKeys;

-(void)shouldClose:(id)sender;
-(void)cleanUp;
@end