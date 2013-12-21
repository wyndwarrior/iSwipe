//
//  ISKey.h
//  iSwipe
//
//  Created by Andrew Liu on 6/4/12.
//  Copyright (c) 2012 Wynd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CGPointWrapper.h"
#import "ISUtils.h"

@interface ISKey : NSObject{
    char letter;
    double angle;
    NSMutableArray *pts;
    CGPoint avg;
}

@property(nonatomic, assign) char letter;
@property(nonatomic, assign) double angle;
@property(nonatomic, retain) NSMutableArray *pts;
@property(nonatomic, readonly) CGPoint avg;

+(id)keyWithLetter:(char)c;
-(void)add:(CGPoint)p;
-(void)compute;

@end
