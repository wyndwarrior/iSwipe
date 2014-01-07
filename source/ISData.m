//
//  SwypeData.m
//  iSwipe
//
//  Created by Andrew Liu on 6/4/12.
//  Copyright (c) 2012 Wynd. All rights reserved.
//

#import "ISData.h"


@implementation ISData

@synthesize keys, cur;

-(id) init{
    self = [super init];
    if( self ){
        self.keys = [NSMutableArray array];
        self.cur = nil;
    }
    
    return self;
}

-(bool)addData:(CGPoint)p forKey:(NSString*)k{
    
    if( k == nil || k.length != 1) return false;
    
    bool ret = false;
    
    if (self.cur == nil || [k characterAtIndex:0] != self.cur.letter){
        if( self.cur != nil )
            ret = true;
        [self.cur compute];
        self.cur = [ISKey keyWithLetter:[k characterAtIndex:0]];
        [self.keys addObject:self.cur];
    }
    
    [self.cur add:p];
    
    return ret;
}

-(void)end{
    [self.cur compute];
}


@end
