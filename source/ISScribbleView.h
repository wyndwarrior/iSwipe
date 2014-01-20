#import <UIKit/UIKit.h>
#import "CGPointWrapper.h"
#import "ISUtils.h"

@interface ISScribbleView : UIView

@property (nonatomic, assign) BOOL isVisible;

- (void)show;
- (void)hide;

- (void)resetPoints;

- (void)drawToTouch:(UITouch *)touch;
- (double)length;

@end
