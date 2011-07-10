#import "CGPointWrapper.h"

@implementation CGPointWrapper
@synthesize point;
+(id)wrapperWithPoint:(CGPoint)p{
    CGPointWrapper *wrap = [[CGPointWrapper alloc] init];
    wrap.point = p;
    return [wrap autorelease];
}
@end
