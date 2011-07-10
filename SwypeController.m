#import "SwypeController.h"
#import "SwypeModel.h"

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

-(void)copyDictionary:(NSString *)path{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    NSFileManager *man = [NSFileManager defaultManager];
    NSString *dir = [NSString stringWithFormat:@"%@/.swype", path];
    if(![man fileExistsAtPath:dir])
        [man createDirectoryAtPath:dir withIntermediateDirectories:YES attributes:nil error:nil];
    NSArray *cont = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:@"/var/mobile/Library/Wynd/Swype" error:nil];
    for (NSString* file in cont)
        [[NSFileManager defaultManager] copyItemAtPath:[@"/var/mobile/Library/Wynd/Swype" stringByAppendingPathComponent:file] toPath:[dir stringByAppendingPathComponent:file] error:nil];
    [pool drain];
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
        [self addInput:bestMatch];
    }
    [self cleanUp];
}

-(void)addInput:(NSString *)input{
    UIKeyboardImpl *kb = [UIKeyboardImpl activeInstance];
    if([theSender shift]){
        [kb handleStringInput:[NSString stringWithFormat:@"%c", [input characterAtIndex:0]-32] fromVariantKey:NO];
        if(input.length>1)
            [kb handleStringInput:[input substringFromIndex:1] fromVariantKey:NO];
    }else
        [kb handleStringInput:input fromVariantKey:NO];
}

-(void)cleanUp{
    [keys release];keys = nil;
    [entrancePoints release];entrancePoints = nil;
    [scribbles removeFromSuperview];
    [scribbles release];
    scribbles = nil;
}
-(void)dealloc{
    [self cleanUp];
    [kbkeys release];
    [super dealloc];
}

@end