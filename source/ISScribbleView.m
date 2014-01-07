#import "ISScribbleView.h"

#define PTSLIM 300

@implementation ISScribbleView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        scribbles = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,
                                                                  frame.size.width,
                                                                  frame.size.height)];
        [self addSubview:scribbles];
        points = [[NSMutableArray alloc] initWithCapacity:PTSLIM];
    }
    return self;
}

- (double)length{
    double tot = 0;
    CGPoint p = [points[0] point];
    for(int i = 1; i<points.count; i+=2){
        CGPoint p2 = [points[i] point];
        tot += dist(p2.x-p.x, p2.y-p.y);
        p = p2;
    }
    return tot;
}

- (void)drawToTouch:(UITouch*)touch{
    CGPoint point = [touch locationInView:[touch view]];
    [points addObject:[CGPointWrapper wrapperWithPoint:point]];
    while([self length] > PTSLIM )
        [points removeObjectAtIndex:0];

     //this hasn't been tested cause I can't compile ;(
    if (UIGraphicsBeginImageContextWithOptions != NULL) {
       UIGraphicsBeginImageContextWithOptions(scribbles.frame.size, NO, 0.0);
    } else {
       UIGraphicsBeginImageContext(scribbles.frame.size);
    }
    //UIGraphicsBeginImageContext(scribbles.frame.size);
    //[scribbles.image drawInRect:CGRectMake(0, 0, scribbles.frame.size.width, scribbles.frame.size.height)];
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(), 7.5);
    CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), 0, .58, .9, 1);
    
    point = [points[0] point];
    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), point.x, point.y);
    for(int i = 1; i<points.count; i++){
        point = [points[i] point];
        CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), 0, .58, .9, pow((double)i/points.count, .7));
        CGContextSetLineWidth(UIGraphicsGetCurrentContext(), pow((double)i/points.count, .55)*9);
        CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), point.x, point.y);
        CGContextStrokePath(UIGraphicsGetCurrentContext());
        CGContextMoveToPoint(UIGraphicsGetCurrentContext(), point.x, point.y);
    }
    
    CGContextFlush(UIGraphicsGetCurrentContext());
    scribbles.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
}

- (void)startupAnimationDone:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
    [self removeFromSuperview];
}


@end
