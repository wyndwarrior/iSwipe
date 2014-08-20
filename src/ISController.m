#import "ISController.h"
#import "ISModel.h"

@interface ISController () <ISSuggestionsViewDelegate>

@property (nonatomic, strong) NSString *initialKey;
@property (nonatomic, strong) UITouch *startingTouch;

@end

@implementation ISController

+ (ISController *)sharedInstance {
	static ISController *shared = nil;
	static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        shared = [[ISController alloc]init];
    });
	return shared;
}

- (instancetype)init {
    self = [super init];
    if (self) {
		self.suggestionsView = [[ISSuggestionsView alloc] init];
		self.scribbleView = [[ISScribbleView alloc] init];
		_suggestionsView.delegate = self;
    }
    return self;
}

- (void)forwardMethod:(id)sender sel:(SEL)cmd touches:(NSSet *)touches event:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:touch.view];
    NSString *key = [[[sender keyHitTest:point] displayString] lowercaseString];

    if (cmd == @selector(touchesBegan:withEvent:)) {
		self.initialKey = key;
		self.swipe = [[ISData alloc] init];
		[self.suggestionsView hideAnimated:YES];
        [self.scribbleView resetPoints];
		self.startingTouch = touch;
	} else if (cmd == @selector(touchesMoved:withEvent:)) {
		if (_initialKey && ![_initialKey isEqualToString:key]) {
            if( [self.initialKey isEqualToString:@"delete"] && matchLength != -1){
                [self deleteLast];
                [sender touchesEnded:touches withEvent:event];
                [self deleteChar];
                [self resetSwipe];
            }else{
                [self.scribbleView show];
                [self.scribbleView drawToTouch:_startingTouch];
                self.startingTouch = nil;
            }
			self.initialKey = nil;
		} else {
		    [self.scribbleView drawToTouch:touch];

		    if (key.length == 1) {
				[self.swipe addData:point forKey:key];
		    }
		}
	} else if (cmd == @selector(touchesEnded:withEvent:)) {
		self.initialKey = nil;
        [self.swipe end];
        
        if( matchLength != -1){
            if( key && [@".?,!:;@-" rangeOfString:key].location != NSNotFound){
                [self deleteChar];
                [self deleteChar];
                [self kbinput:key];
                [self kbinput:@" "];
                matchLength = -1;
            }
        }
        if( !([key isEqualToString:@".?123"] || [key isEqualToString:@"abc"]) )
            matchLength = -1;
        if (self.swipe && self.swipe.keys.count >= 2) {
            NSArray *arr = [[ISModel sharedInstance] findMatch:self.swipe];
            
            if (arr.count != 0) {
                if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad)
                    [self deleteChar];
				
                [self addInput:[arr[0] word]];
				
                if (arr.count > 1) {
					[_suggestionsView showAnimated:YES];
					_suggestionsView.suggestions = arr;
                }
            }
        }
        
        
        [self resetSwipe];
    }
}

- (void)resetSwipe {
	self.swipe = nil;
	[self.scribbleView hide];
}

- (BOOL)isSwyping {
    return self.swipe.keys.count > 0;
}

- (void)deleteChar {
    [[UIKeyboardImpl activeInstance] handleDelete];
}

- (void)deleteLast {
    for (int i = 0; i<matchLength; i++) {
    	[[UIKeyboardImpl activeInstance] handleDelete];
    }   
}

- (void)suggestionsView:(ISSuggestionsView *)suggestionsView didSelectSuggestion:(NSString *)suggestion {
    [self deleteLast];
    [self deleteChar];
    [self addInput:suggestion];
    [self.suggestionsView hideAnimated:YES];
}

- (void)addInput:(NSString *)input{
    UIKeyboardImpl *kb = [UIKeyboardImpl activeInstance];
    
    matchLength = [input length];
    NSLog(@"%d %d %d", [kb isShifted] ,[kb isAutoShifted], [kb isShiftLocked]);
    if( [kb isShiftLocked] ){
        input = [input uppercaseString];
    }else if([kb isShifted] || [kb isAutoShifted]) {
        input = [NSString stringWithFormat:@"%@%@", [[input substringToIndex:1] uppercaseString], [input substringFromIndex:1]];
    }
    
    [self kbinput:input];
	[self kbinput:@" "];
}
    
- (void)kbinput:(NSString *)input {
    UIKeyboardImpl *kb = [UIKeyboardImpl activeInstance];
    if ([kb respondsToSelector:@selector(addInputString:)]) {
    	[kb addInputString: input];
    } else if ([kb respondsToSelector:@selector(handleStringInput:fromVariantKey:)]) {
    	[kb handleStringInput:input fromVariantKey:NO];
    }   
}

@end