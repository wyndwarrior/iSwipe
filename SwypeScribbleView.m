#import "SwypeScribbleView.h"
@implementation SwypeScribbleView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        scribbles = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,
                                                                  frame.size.width,
                                                                  frame.size.height)];
        [self addSubview:scribbles];
    }
    return self;
}

- (void)drawToTouch:(UITouch*)touch{
    UIView *touchView = touch.view;
    CGPoint prevPoint = [touch previousLocationInView:touchView];
    CGPoint currPoint = [touch locationInView:touchView];
    
    UIGraphicsBeginImageContext(scribbles.frame.size);
    [scribbles.image drawInRect:CGRectMake(0, 0, scribbles.frame.size.width, scribbles.frame.size.height)];
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(), 4);
    CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), 0, .65, .9, 1);
    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), prevPoint.x, prevPoint.y);
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), currPoint.x, currPoint.y);
    CGContextStrokePath(UIGraphicsGetCurrentContext());
    CGContextFlush(UIGraphicsGetCurrentContext());
    scribbles.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
}

- (void)dealloc
{
    [scribbles release];
    [super dealloc];
}

@end
