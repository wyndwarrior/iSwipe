#import <UIKit/UIKit.h>
@interface SwypeScribbleView : UIView {
    UIImageView *scribbles;
}
-(void)drawToTouch:(UITouch*)touch;
@end
