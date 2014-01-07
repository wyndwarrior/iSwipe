#import <UIKit/UIKit.h>
@interface CGPointWrapper : NSObject {
    CGPoint point;
}
@property(nonatomic, assign) CGPoint point;
+(id)wrapperWithPoint:(CGPoint)p;
@end
