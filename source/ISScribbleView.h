#import <UIKit/UIKit.h>
#import "CGPointWrapper.h"
#import "ISUtils.h"

@interface ISScribbleView : UIView {
    UIImageView *scribbles;
    NSMutableArray *points;
}
-(void)drawToTouch:(UITouch*)touch;
-(double)length;
@end
