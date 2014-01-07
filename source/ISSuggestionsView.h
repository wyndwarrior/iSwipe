#import <QuartzCore/QuartzCore.h>
#import "ISWord.h"
#import "ISController.h"

@interface ISSuggestionsView : UIView {
    UIScrollView *suggestionsView;
    NSArray *suggestions;
    UIButton *close;
}
@property (nonatomic, strong) NSArray *suggestions;
-(id)initWithFrame:(CGRect)frame suggestions:(NSArray *)arr delegate:(id)delegate;
@end
