#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "ISKey.h"
#import "ISUtils.h"
#import "CGPointWrapper.h"

@interface ISData : NSObject

@property (nonatomic, strong) ISKey *cur;
@property (nonatomic, strong) NSMutableArray *keys;

- (void)addData:(CGPoint)p forKey:(NSString*)k;
- (void)end;

@end
