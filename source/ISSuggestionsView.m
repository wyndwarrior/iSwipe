#import "ISSuggestionsView.h"

@interface ISSuggestionsView ()

@property (nonatomic, strong) UIScrollView *suggestionsView;
@property (nonatomic, strong) UIButton *close;

@end

@implementation ISSuggestionsView
@synthesize suggestions;

- (id)initWithFrame:(CGRect)frame suggestions:(NSArray *)arr delegate:(id)delegate
{
    self = [super initWithFrame:frame];
    if (self) {
        self.suggestions = arr;
        self.suggestionsView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width-frame.size.height, frame.size.height)];
        int curX = 10;
        for(int i = 0; i<suggestions.count; i++){
            NSString *suggestion = [suggestions[i] word];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            CGSize size = [suggestion sizeWithFont:[UIFont systemFontOfSize:17]];
#pragma clang diagnostic pop
            //CGSize size = [suggestion sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]}];
            UIButton *btn = [[UIButton alloc] initWithFrame:
                             CGRectMake(curX, (frame.size.height-size.height-2)/2, size.width+10, size.height+2)];
            [btn setTitle:suggestion forState:UIControlStateNormal];
            [btn addTarget:delegate action:@selector(didSelect:) forControlEvents:UIControlEventTouchUpInside];
            btn.titleLabel.font = i==0?[UIFont boldSystemFontOfSize:17]:[UIFont systemFontOfSize:17];
            [suggestionsView addSubview:btn];
            curX+=size.width+20;
        }
        [self addSubview:suggestionsView];
        suggestionsView.contentSize = CGSizeMake(curX, frame.size.height);
        suggestionsView.showsHorizontalScrollIndicator = NO;
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:.7];
        
        self.close = [[UIButton alloc] initWithFrame:CGRectMake(frame.size.width-frame.size.height, 0, frame.size.height, frame.size.height)];
        [close setTitle:@"X" forState:UIControlStateNormal];
        [close addTarget:delegate action:@selector(shouldClose:) forControlEvents:UIControlEventTouchUpInside];
        close.titleLabel.font = [UIFont systemFontOfSize:17];
        [self addSubview:close];
        
        
        self.alpha = 0;
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.25];
        [UIView setAnimationDelay:0.5];
        self.alpha = 1;
        [UIView commitAnimations];
    }
    return self;
}

- (void)setFrame:(CGRect)frame {
	[super setFrame:frame];
	_suggestionsView.frame = CGRectMake(0, 0, frame.size.width-frame.size.height, frame.size.height);
	_close.frame = CGRectMake(frame.size.width-frame.size.height, 0, frame.size.height, frame.size.height);
}

- (void)dealloc
{
    [[ISController sharedInstance] shouldClose:self];
}

@end
