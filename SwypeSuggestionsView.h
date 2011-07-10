#import <QuartzCore/QuartzCore.h>
#import "SwypeController.h"

@interface SwypeSuggestionsView : UIView {
    UIScrollView *suggestionsView;
    NSArray *suggestions;
    UIButton *close;
}
@property (nonatomic, retain) NSArray *suggestions;
-(id)initWithFrame:(CGRect)frame suggestions:(NSArray *)arr delegate:(id)delegate;
@end
