#import "CGPointWrapper.h"
#import "ISData.h"
#import "ISKey.h"
#import "ISAlgoAngleDiffGreedy.h"
#import "ISAlgoAngleDiffDP.h"
#import "ISAlgoProtocol.h"
#import "ISUtils.h"

@interface ISModel : NSObject 

+(id)sharedInstance;
-(NSArray *)findMatch:(ISData *)data;

@end
