#import "SwypeSuggestionsView.h"


@implementation SwypeSuggestionsView
@synthesize suggestions;

- (id)initWithFrame:(CGRect)frame suggestions:(NSArray *)arr delegate:(id)delegate
{
    self = [super initWithFrame:frame];
    if (self) {
        self.suggestions = arr;
        suggestionsView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width-frame.size.height, frame.size.height)];
        int curX = 10;
        for(NSString *suggestion in suggestions){
            CGSize size = [suggestion sizeWithFont:[UIFont systemFontOfSize:17]];
            UIButton *btn = [[UIButton alloc] initWithFrame:
                             CGRectMake(curX, (frame.size.height-size.height-2)/2, size.width+10, size.height+2)];
            [btn setTitle:suggestion forState:UIControlStateNormal];
            [btn addTarget:delegate action:@selector(didSelect:) forControlEvents:UIControlEventTouchUpInside];
            btn.titleLabel.font = [UIFont systemFontOfSize:17];
            [suggestionsView addSubview:btn];
            [btn release];
            curX+=size.width+20;
        }
        [self addSubview:suggestionsView];
        suggestionsView.contentSize = CGSizeMake(curX, frame.size.height);
        suggestionsView.showsHorizontalScrollIndicator = NO;
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:.7];
        
        close = [[UIButton alloc] initWithFrame:CGRectMake(frame.size.width-frame.size.height, 0, frame.size.height, frame.size.height)];
        [close setTitle:@"X" forState:UIControlStateNormal];
        [close addTarget:delegate action:@selector(shouldClose:) forControlEvents:UIControlEventTouchUpInside];
        close.titleLabel.font = [UIFont systemFontOfSize:17];
        [self addSubview:close];
        [close release];
    }
    return self;
}

- (void)dealloc
{
    [[SwypeController sharedInstance] shouldClose:self];
    [suggestionsView release];
    self.suggestions = nil;
    [super dealloc];
}

@end
