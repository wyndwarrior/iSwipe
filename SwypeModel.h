#import "SwypeModel.h"
#import "CGPointWrapper.h"

@interface SwypeModel : NSObject {
}
+(NSArray *)findBestMatches:(NSString *)input forPoints:(NSArray *)entrancePoints;
+(NSArray *)findAnglesForPoints:(NSArray *)entrancePoints;
+(NSArray *)findAngleDifferences:(NSArray *)angles;
@end
