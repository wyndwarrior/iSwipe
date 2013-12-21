//
//  ISWord.h
//  iSwipe
//
//  Created by Andrew Liu on 6/5/12.
//  Copyright (c) 2012 Wynd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ISWord : NSObject{
    NSString *word;
    NSString *match;
    double weight;
    int count;
}
@property(nonatomic, retain) NSString *word;
@property(nonatomic, retain) NSString *match;
@property(nonatomic, assign) double weight;
@property(nonatomic, assign) int count;

+(id)word:(NSString*)w match:(NSString*)m weight:(double)wei count:(int)c;

@end
