#import "SwypeModel.h"
#import "CGPointWrapper.h"

@interface SwypeModel : NSObject {
}
+(NSArray *)findBestMatches:(NSString *)input forPoints:(NSArray *)entrancePoints;
+(void)updatePreference:(NSString*)str;
@end
