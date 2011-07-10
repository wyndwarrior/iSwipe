#import <UIKit/UIKeyboardLayoutStar.h>
#import <UIKit/UIKeyboardImpl.h>
#import <UIKit/UIKeyboard.h>
#import "SwypeScribbleView.h"
#import "CGPointWrapper.h"

@interface SwypeController : NSObject {
    NSMutableArray *keys;
    NSMutableArray *entrancePoints;
    NSMutableArray *kbkeys;
    NSArray *matches;
    SwypeScribbleView *scribbles;
    
    BOOL isSwyping;
    
    id theSender;
    
    BOOL didJustSwype;
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

-(void)cleanUp;
@end