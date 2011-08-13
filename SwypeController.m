#import "SwypeController.h"
#import "SwypeModel.h"

@interface UIAlertView (Private)
-(id)textFieldAtIndex:(int)index;
@end

@implementation SwypeController
@synthesize matches, kbkeys, isSwyping;

static SwypeController *sharedInstance;

+(SwypeController*)sharedInstance{
    if(!sharedInstance)sharedInstance = [[SwypeController alloc] init];
    return sharedInstance;
}

-(id)init{
    self = [super init];
    if(self){
        kbkeys = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void)addKey:(NSString*)key state:(NSString *)state sender:(id)sender touches:(id)touches{
    theSender = sender;
    if([state isEqualToString:@"DidStart"])
    {
        [self cleanUp];
        keys = [[NSMutableArray alloc] init];
        entrancePoints = [[NSMutableArray alloc] init];
        if(key && key.length==1){
            [keys addObject:key];
            [entrancePoints addObject:[CGPointWrapper wrapperWithPoint:[[touches anyObject] locationInView:[[touches anyObject] view]]]];
        }
        CGRect frame = [[UIKeyboard activeKeyboard] frame];
        scribbles = [[SwypeScribbleView alloc] initWithFrame:CGRectMake(0,0,frame.size.width, frame.size.height)];
        [scribbles setUserInteractionEnabled:NO];
        [[UIKeyboard activeKeyboard] addSubview:scribbles];
    }
    else if([state isEqualToString:@"DidMove"] || [state isEqualToString:@"DidEnd"])
    {
        isSwyping = YES;
        [self hideKeys];
        if(key && key.length==1)
            if((keys.count>0 && ![key isEqualToString:[keys objectAtIndex:keys.count-1]]) || keys.count==0){
                [keys addObject:key];
                [entrancePoints addObject:[CGPointWrapper wrapperWithPoint:[[touches anyObject] locationInView:[[touches anyObject] view]]]];
            }
        [scribbles drawToTouch:[touches anyObject]];
    }
    if([state isEqualToString:@"DidEnd"]){
        isSwyping = NO;
        [self showKeys];
        if(keys.count<=1){
            [self cleanUp];
            didJustSwype = NO;
            lastWasShift = NO;
        }else{
            [self findMatch:keys];
            didJustSwype = YES;
        }
    }
}

-(void)hideKeys{
    for(id key in kbkeys)
        if([key state] == 1)
            if(![key isHidden])
                [key setHidden:YES];
}

-(void)showKeys{
    for(id key in kbkeys)
        if([key state] == 1)
            if([key isHidden])
                [key setHidden:NO];
}


-(void)findMatch:(NSArray *)input{
    NSMutableString *str = [[NSMutableString alloc] init];
    for(NSString *s in input) [str appendString:s];
    NSArray *swypeMatches = [SwypeModel findBestMatches:[str lowercaseString] forPoints:entrancePoints];
    [str release];
    self.matches = swypeMatches;
    if(matches.count>0 && [[matches objectAtIndex:0] length]>0){
        NSString *bestMatch = [matches objectAtIndex:0];
        [[UIKeyboardImpl activeInstance] handleDelete];
        if(didJustSwype && [[[[UIKeyboardImpl activeInstance] delegate] text] length]>0)
            [[UIKeyboardImpl activeInstance] handleStringInput:@" " fromVariantKey:NO];
        lastWasShift = NO;
        [self addInput:bestMatch];
        matchLength = [bestMatch length];
    }
    [self cleanUp];
    if(matches.count>1){
        UIKeyboard *kb = [UIKeyboard activeKeyboard];
        suggestions = [[SwypeSuggestionsView alloc] initWithFrame:CGRectMake(0, kb.frame.origin.y-30, kb.frame.size.width, 30) suggestions:matches delegate:self];
        [kb.superview addSubview:suggestions];
        [suggestions release];
    }
}

-(void)didSelect:(id)sender{
    UIKeyboardImpl *kb = [UIKeyboardImpl activeInstance];
    for(int i = 0; i<matchLength; i++)
        [kb handleDelete];
    [self addInput:[[sender titleLabel] text]];
    [suggestions removeFromSuperview];
    suggestions = nil;
    [SwypeModel updatePreference:[[sender titleLabel] text]];
}

-(void)shouldClose:(id)sender{
    [suggestions removeFromSuperview];
    suggestions = nil;
}

-(void)addInput:(NSString *)input{
    UIKeyboardImpl *kb = [UIKeyboardImpl activeInstance];
    if([theSender shift] || lastWasShift){
        lastWasShift = YES;
        [kb handleStringInput:[NSString stringWithFormat:@"%c", [input characterAtIndex:0]-32] fromVariantKey:NO];
        if(input.length>1)
            [kb handleStringInput:[input substringFromIndex:1] fromVariantKey:NO];
    }else{
        [kb handleStringInput:input fromVariantKey:NO];
        lastWasShift = NO;
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if (buttonIndex != [alertView cancelButtonIndex]){
        NSString * word = [[[alertView textFieldAtIndex:0] text] lowercaseString];
        
        bool good = true;
        for(int i = 0; i<word.length; i++)
            if([word characterAtIndex:i]<97 || [word characterAtIndex:i]>122)
                good = false;
        
        if(word.length<2 || !good){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Inavlid Word"
                                                            message:@"The word you are trying to add is too short or does not consist of letters from the English alphabet."
                                                           delegate:nil
                                                  cancelButtonTitle:@"Dismiss"
                                                  otherButtonTitles:nil];
            [alert show];
            [alert release];
        }else{
            [SwypeModel updatePreference:word];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Word Added"
                                                            message:[NSString stringWithFormat:@"\"%@\" has been added to the dictionary", word]
                                                           delegate:nil
                                                  cancelButtonTitle:@"Dismiss"
                                                  otherButtonTitles:nil];
            [alert show];
            [alert release];
        }
    }
}

-(void)cleanUp{
    [keys release];keys = nil;
    [entrancePoints release];entrancePoints = nil;
    [scribbles removeFromSuperview];
    [scribbles release];
    scribbles = nil;
    [suggestions removeFromSuperview];
    suggestions = nil;
}
-(void)dealloc{
    [self cleanUp];
    [kbkeys release];
    [super dealloc];
}

@end