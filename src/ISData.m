//
//  SwypeData.m
//  iSwipe
//
//  Created by Andrew Liu on 6/4/12.
//  Copyright (c) 2012 Wynd. All rights reserved.
//

#import "ISData.h"

@implementation ISData

- (instancetype)init {
    self = [super init];
    if (self) {
        self.keys = [NSMutableArray array];
        self.cur = nil;
    }
    return self;
}

- (void)addData:(CGPoint)p forKey:(NSString*)k{
    
    if (k == nil || k.length != 1) return;

    if (!_cur || [k characterAtIndex:0] != self.cur.letter) {
        [self.cur compute];
        self.cur = [ISKey keyWithLetter:[k characterAtIndex:0]];
        [self.keys addObject:self.cur];
    }
    
    [self.cur add:p];
}

- (void)end {
    [self.cur compute];
}


@end
