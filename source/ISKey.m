//
//  ISKey.m
//  iSwipe
//
//  Created by Andrew Liu on 6/4/12.
//  Copyright (c) 2012 Wynd. All rights reserved.
//

#import "ISKey.h"

@implementation ISKey

@synthesize letter, angle, avg, pts;

+(id)keyWithLetter:(char)c{
    ISKey * k = [[ISKey alloc] init];
    k.angle = 0;
    k.letter = c;
    k.pts = [NSMutableArray array];
    return [k autorelease];
}

-(void)add:(CGPoint)p{
    [self.pts addObject:[CGPointWrapper wrapperWithPoint:p]];
}

static inline double calcAngle(CGPoint p1, CGPoint p2, CGPoint p3){
    return vecAng(p1.x-p2.x, p1.y-p2.y, p2.x-p3.x, p2.y-p3.y);
}

-(void)compute{
    if( self.pts.count >= 3 ){
        CGPoint p1 = [[self.pts objectAtIndex:self.pts.count-1] point];
        CGPoint p2 = CGPointZero;
        CGPoint p3 = [[self.pts objectAtIndex:0] point];
        
        //find farthest point away
        double max = 0;
        for( int i = 1; i<self.pts.count-1; i++){
            CGPoint pp = [[self.pts objectAtIndex:i] point];
            double dt = dist(pp.x-p1.x, pp.y-p1.y) + dist(pp.x-p3.x,pp.y-p3.y);
            if( dt > max){
                max = dt;
                p2 = pp;
            }
        }
        
        self.angle = calcAngle(p1, p2, p3);
        
    }
    
    float avgx = 0, avgy = 0;
    
    for(CGPointWrapper *p in self.pts){
        CGPoint pt = p.point;
        avgx += pt.x;
        avgy += pt.y;
    }
    
    avg = CGPointMake(avgx/self.pts.count, avgy/self.pts.count);
    
}

-(void)dealloc{
    self.pts = nil;
    [super dealloc];
}

@end
