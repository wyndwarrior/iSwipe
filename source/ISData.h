#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "ISKey.h"
#import "ISUtils.h"
#import "CGPointWrapper.h"

@interface ISData : NSObject{
    double len;
    NSMutableArray *keys;
    ISKey *cur;
}

@property (nonatomic, strong) ISKey *cur;
@property (nonatomic, strong) NSMutableArray *keys;

-(bool)addData:(CGPoint)p forKey:(NSString*)k;
-(void)end;

@end
