//
//  ISAlgoAngleDiffDP.h
//  iSwipe
//
//  Created by Andrew Liu on 6/11/12.
//  Copyright (c) 2012 Wynd. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ISAlgoProtocol.h"
#import "ISData.h"
#import "ISKey.h"
#import "ISWord.h"

//find best possible matching
//in practice there is little, if any, difference from greedy
@interface ISAlgoAngleDiffDP : NSObject <ISAlgoProtocol>
-(NSArray *)findMatch:(ISData *)data dict:(NSArray *)dictionary;

@end
