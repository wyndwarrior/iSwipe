#import "ISController.h"
#import "ISModel.h"


@interface ISController ()

@property (nonatomic, strong) NSString *initialKey;
@property (nonatomic, strong) UITouch *startingTouch;

@end

@implementation ISController
@synthesize kbkeys, scribbles, swipe, charAdded;

+(ISController *)sharedInstance {
	static ISController *shared = nil;
	static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        shared = [[ISController alloc]init];
    });
	return shared;
}

-(id)init{
    self = [super init];
    if(self){
        self.kbkeys = [NSMutableArray array];
    }
    return self;
}

-(void)forwardMethod:(id)sender sel:(SEL)cmd touches:(NSSet *)touches event:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:touch.view];
    NSString *key = [[[sender keyHitTest:point] displayString] lowercaseString];

    if (cmd == @selector(touchesBegan:withEvent:)) {
		self.initialKey = key;
		self.swipe = [[ISData alloc] init];
	    [self shouldClose:nil];
	    show = false;
	} else if (cmd == @selector(touchesMoved:withEvent:)) {
		if (_initialKey && ![_initialKey isEqualToString:key]) {
			[self.scribbles drawToTouch:_startingTouch];
			self.startingTouch = nil;
			[self setupSwipe];
			self.initialKey = nil;
		} else {
		    [self.scribbles drawToTouch:touch];

		    if (key.length == 1) {
		        bool disp;
		        if (!show & (disp=[self.swipe addData:point forKey:key])) {
		            show = true;
		
					[UIView animateWithDuration:0.5f animations:^{
						self.scribbles.alpha = 1;
					}];
		        }
		        if (disp) {
		            [self hideKeys];
		        }
		    }
		}
	} else if( cmd == @selector(touchesEnded:withEvent:) ){
		self.initialKey = nil;
        [self.swipe end];
        lastShift = NO;

        if (self.swipe.keys.count >= 2) {
            NSArray * arr = [[ISModel sharedInstance] findMatch:self.swipe];
            
            if (arr.count != 0) {
                if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad) {
                    [self deleteChar];
                }
                [self addInput:[arr[0] word]];
                if (arr.count > 1) {
                    UIKeyboard *kb = [UIKeyboard activeKeyboard];
                    self.suggestions = [[ISSuggestionsView alloc] initWithFrame:CGRectMake(0, kb.frame.origin.y-30, kb.frame.size.width, 30) suggestions:arr delegate:self];
                    [kb.superview addSubview:_suggestions];
                }
            }
        }
        [self cleanSwipe];
    }
}

-(void)setupSwipe{
	if (!self.swipe) {
		self.swipe = [[ISData alloc] init];
	    [self shouldClose:nil];
	    show = false;
	}
    
    //load scribble view
    UIKeyboard * kb = [UIKeyboard activeKeyboard];
    CGRect frame = kb.frame;
    if( self.scribbles )
        [self.scribbles removeFromSuperview];
    self.scribbles = [[ISScribbleView alloc] initWithFrame:CGRectMake(0,0,frame.size.width, frame.size.height)];
    self.scribbles.userInteractionEnabled = NO;
    self.scribbles.alpha = 0;
    [kb addSubview:scribbles];
}

-(void)cleanSwipe{
    self.swipe = nil;
    
	[UIView animateWithDuration:0.5f animations:^{
		self.scribbles.alpha = 0;
	} completion:^(BOOL finished){
		[self.scribbles removeFromSuperview];
		self.scribbles = nil;
	}];
    
    [self performSelector:@selector(showKeys) withObject:nil afterDelay:0.1]; //should keys always stay hidden?
}

-(BOOL)isSwyping{
    return self.swipe != nil;
}

-(void)hideKeys{
    for(UIKBKeyView *k in self.kbkeys)
        if( (k.state & 0x11) != 0 && [[[k key] displayString] length] == 1)
            k.hidden = YES;
}
-(void)showKeys{
    for(UIKBKeyView *k in self.kbkeys)
        if( (k.state & 0x11) != 0 && [[[k key] displayString] length] == 1)
            k.hidden = NO;
}

-(void)shouldClose:(id)sender{
    [_suggestions removeFromSuperview];
    self.suggestions = nil;
}

-(void)deleteChar{
    [[UIKeyboardImpl activeInstance] handleDelete];
}

-(void)deleteLast{
    for(int i = 0; i<matchLength; i++)
        [self deleteChar];
}

-(void)didSelect:(id)sender{
    [self deleteLast];
    [self deleteChar];
    [self addInput:[[sender titleLabel] text]];
    [self shouldClose:nil];
}

-(void)addInput:(NSString *)input{
    UIKeyboardImpl *kb = [UIKeyboardImpl activeInstance];
    
    matchLength = [input length];
    if([kb isShifted]){
        lastShift = YES;
        char c = [input characterAtIndex:0];
        if( c <= 'z' && c >= 'a' ){
            [self kbinput:[NSString stringWithFormat:@"%c", [input characterAtIndex:0]-'a'+'A']];
            if(input.length>1)
                [self kbinput:[input substringFromIndex:1]];
        }else{
            [self kbinput:input];
        }
    }else{
        [self kbinput:input];
        lastShift = NO;
    }
	
	[self kbinput:@" "];
}
    
-(void)kbinput:(NSString *)input{
    UIKeyboardImpl *kb = [UIKeyboardImpl activeInstance];
	//[kb handleStringInput:input fromVariantKey:NO];
    if( [kb respondsToSelector:@selector(addInputString:)])
        [kb addInputString: input];
    else if( [kb respondsToSelector:@selector(handleStringInput:fromVariantKey:)])
        [kb handleStringInput:input fromVariantKey:NO];
}


@end