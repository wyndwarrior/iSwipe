//
//  ISAlgoAngleDiffGreedy.mm
//  iSwipe
//
//  Created by Andrew Liu on 6/5/12.
//  Copyright (c) 2012 Wynd. All rights reserved.
//

#import "ISAlgoAngleDiffGreedy.h"

@implementation ISAlgoAngleDiffGreedy

static double getValue(ISData *data, ISWord* iword){
    int i = 1 ,j = 1;
    double val = BASE;
    NSArray *keys = data.keys;
    NSString* word = iword.match;
    
    for( ; i<word.length && j < keys.count; j++)
        if( [word characterAtIndex:i] == [[keys objectAtIndex:j] letter] ){
            while(++i < word.length && [word characterAtIndex:i] == [[keys objectAtIndex:j] letter]) val += BONUS;
            val += [(ISKey*)[keys objectAtIndex:j] angle];
        }
    
    if( i != word.length ) val = BAD; //not possible
    
    return val;
}

-(NSArray *)findMatch:(ISData *)data dict:(NSArray *)dict{
    NSMutableArray *arr = [NSMutableArray array];
    //NSLog(@"%@", arr);
    int ct = 0;
    for(ISWord * str in dict){
        double val = getValue(data, str);
        str.weight = val*(1+0.5*((int)dict.count-ct)/dict.count);
        if( val != BAD ){
            //NSLog(@"%@ %.2f %d %d", str, val, ct, (int)dict.count-ct);
            [arr addObject:str];
        }
        ct++;
    }
    
    return arr;
}

@end
