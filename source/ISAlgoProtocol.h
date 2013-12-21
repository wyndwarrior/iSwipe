//
//  ISAlgoProtocol.h
//  iSwipe
//
//  Created by Andrew Liu on 6/5/12.
//  Copyright (c) 2012 Wynd. All rights reserved.
//

#import <Foundation/Foundation.h>

#define BASE 360
#define BAD -1
#define BONUS -5

@class ISData;
@protocol ISAlgoProtocol <NSObject>
@required 
-(NSArray *)findMatch:(ISData *)data dict:(NSArray *)dictionary;
@end
