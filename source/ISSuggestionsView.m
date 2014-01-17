#import "ISSuggestionsView.h"

#define ANIM_LENGTH 0.25f

@interface ISSuggestionsView ()

@property (nonatomic, strong) UIScrollView *suggestionsView;
@property (nonatomic, strong) UIButton *close;

@end

@implementation ISSuggestionsView

- (void)showAnimated:(BOOL)animated {
	[[UIKeyboard.activeKeyboard superview] addSubview:self];
	
	if (animated) {
		[UIView animateWithDuration:ANIM_LENGTH animations:^{
			self.alpha = 1;
		}];
	} else {
		self.alpha = 1;
	}
}

- (void)hideAnimated:(BOOL)animated {
	if (animated) {
		[UIView animateWithDuration:ANIM_LENGTH animations:^{
			self.alpha = 1;
		} completion:^(BOOL finished){
			[self removeFromSuperview];
			[self setSuggestions:nil];
		}];
	} else {
		self.alpha = 0;
		[self removeFromSuperview];
		[self setSuggestions:nil];
	}
}

- (void)setSuggestions:(NSArray *)suggestions {
	_suggestions = suggestions;
	
    int curX = 10;
	int i = 0;
	
	for (UIView *view in _suggestionsView.subviews) {
		[view removeFromSuperview];
	}
	
	for (ISWord *word in _suggestions) {
        NSString *suggestion = [word word];
		CGSize size = [suggestion sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]}];
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(curX, (self.frame.size.height-size.height-2)/2, size.width+10, size.height+2)];
        [btn setTitle:suggestion forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(callDelegateWithSuggestionButton:) forControlEvents:UIControlEventTouchUpInside];
        btn.titleLabel.font = i==0?[UIFont boldSystemFontOfSize:17]:[UIFont systemFontOfSize:17];
        [_suggestionsView addSubview:btn];
        curX+=size.width+20;
		i++;
	}
	
	_suggestionsView.contentSize = CGSizeMake(curX, self.frame.size.height);
}

- (void)callDelegateWithSuggestionButton:(UIButton *)button {
	if (_delegate && [_delegate respondsToSelector:@selector(suggestionsView:didSelectSuggestion:)]) {
		[_delegate suggestionsView:self didSelectSuggestion:button.titleLabel.text];
	}
}

- (void)closeButtonPressed {
	[self hideAnimated:YES];
}

- (instancetype)init {
    self = [super init];
    if (self) {
		self.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.7f];
		
        self.suggestionsView = [[UIScrollView alloc]init];
		_suggestionsView.showsHorizontalScrollIndicator = NO;
        [self addSubview:_suggestionsView];

        self.close = [[UIButton alloc]init];
        [_close setTitle:@"X" forState:UIControlStateNormal];
        [_close addTarget:self action:@selector(closeButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        _close.titleLabel.font = [UIFont systemFontOfSize:17];
        [self addSubview:_close];
        
        self.alpha = 0;
    }
    return self;
}

- (void)setFrame:(CGRect)frame {
	[super setFrame:frame];
	_suggestionsView.frame = CGRectMake(0, 0, frame.size.width-frame.size.height, frame.size.height);
	_close.frame = CGRectMake(frame.size.width-frame.size.height, 0, frame.size.height, frame.size.height);
}

- (void)dealloc {
	[self hideAnimated:NO];
}

@end
