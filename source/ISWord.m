//
//  ISWord.m
//  iSwipe
//
//  Created by Andrew Liu on 6/5/12.
//  Copyright (c) 2012 Wynd. All rights reserved.
//

#import "ISWord.h"

@implementation ISWord

@synthesize word, weight,count, match;

+(id)word:(NSString*)word match:(NSString *)m weight:(double)wei count:(int)c{
    ISWord *w = [[ISWord alloc] init];
    w.word = word;
    w.weight = wei;
    w.count = c;
    w.match = m;
    return [w autorelease];
}

-(NSComparisonResult)compare:(ISWord *)obj{
    if(weight>obj.weight) return NSOrderedAscending;
    if(weight<obj.weight) return NSOrderedDescending;
    if(word.length<obj.word.length) return NSOrderedAscending;
    if(word.length>obj.word.length) return NSOrderedDescending;
    return NSOrderedSame;
}

-(void)dealloc{
    self.word = nil;
    self.match = nil;
    [super dealloc];
}

-(NSString*) description{
    return [NSString stringWithFormat:@"%@(%@) - %.2f", word, match, weight];
}

@end
