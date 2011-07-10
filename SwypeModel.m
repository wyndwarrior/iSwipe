#import "SwypeModel.h"

@interface SwypeDictionaryObject : NSObject{
    NSString *word;
    double weight;
}
@property(assign) NSString *word;
@property(assign) double weight;
@end
@implementation SwypeDictionaryObject
@synthesize word, weight;
-(NSComparisonResult)compare:(SwypeDictionaryObject *)obj{
    if(weight>obj.weight) return NSOrderedAscending;
    else if(weight<obj.weight) return NSOrderedDescending;
    return NSOrderedSame;
}
@end


@implementation SwypeModel
static double mat[300][300];
static double wei[300];

static double wlcs(NSString *input, NSString *word){
    for(int i = 0; i<=word.length; i++){
        mat[0][i] = 0;
        mat[i][0] = 0;
    }
    for(int i = 1; i<=word.length; i++)
        for(int j = 1; j<=input.length; j++){
            if([input characterAtIndex:j-1]==[word characterAtIndex:i-1])
                mat[i][j] = MAX(mat[i-1][j-1]+wei[j-1], mat[i-1][j]-10);
            else
                mat[i][j] = MAX(mat[i-1][j], mat[i][j-1]);
        }
    return mat[word.length][input.length];
}

static bool matches(NSString *input, NSString *word){
    int j = 0;
    for(int i = 0; i<input.length && j<word.length; i++)
        if([input characterAtIndex:i] == [word characterAtIndex:j])
            while(j<word.length && [input characterAtIndex:i] == [word characterAtIndex:j])
                j++;
    return j==word.length;
}

static double angleFromPoints(CGPoint start, CGPoint end);
static inline double toDeg(double rad);
static inline double minAngle(double a1, double a2);

+(NSArray *)findBestMatches:(NSString *)input forPoints:(NSArray *)entrancePoints{
    int begin = [input characterAtIndex:0]-97, end = [input characterAtIndex:input.length-1]-97;
    NSString *path = [NSString stringWithFormat:@"/var/mobile/Library/Wynd/Swype/dictionary-%d-%d.txt", begin, end];
    NSString *dictionary = [[NSString alloc] initWithContentsOfFile:path encoding:NSASCIIStringEncoding error:nil];
    NSString *path2 = [NSString stringWithFormat:@"%@/.swype/dictionary-%d-%d.txt", [[NSBundle mainBundle] resourcePath], begin, end];
    if(!dictionary)
        dictionary = [[NSString alloc] initWithContentsOfFile:path2 encoding:NSASCIIStringEncoding error:nil];
    
    NSArray *weights = [self findAnglesForPoints:entrancePoints];
    weights = [self findAngleDifferences:weights];
    
    for(int i = 1; i<weights.count; i++)
        wei[i+1] = [[weights objectAtIndex:i] doubleValue];
    
    wei[1] = 0;wei[weights.count+2] = 0;
    
    NSArray *words = [[dictionary componentsSeparatedByString:@"\n"] retain];
    [dictionary release];
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    
    for(int i = 0; i<words.count; i++){
        NSString *word = [[words objectAtIndex:i] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if(word.length>0 && matches(input, word)){
            SwypeDictionaryObject *tmp = [[SwypeDictionaryObject alloc] init];
            tmp.weight = (words.count-i)/(double)words.count*70+wlcs(input,word);
            tmp.word = word;
            [arr addObject:tmp];
            [tmp release];
        }
    }
    
    [words release];
    NSArray *sort = [arr sortedArrayUsingSelector:@selector(compare:)];
    [arr release];
    
    NSMutableArray *ret  = [[NSMutableArray alloc] init];
    for(SwypeDictionaryObject *tmp in sort)
        [ret addObject:tmp.word];
    
    return [ret autorelease];
}

+(NSArray *)findAnglesForPoints:(NSArray *)entrancePoints{
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    
    for(int i = 1; i<entrancePoints.count; i++){
        CGPoint one = [[entrancePoints objectAtIndex:i-1] point];
        CGPoint two = [[entrancePoints objectAtIndex:i] point];
        [arr addObject:[NSNumber numberWithDouble:angleFromPoints(one,two)]];
    }
    
    return [arr autorelease];
}

+(NSArray *)findAngleDifferences:(NSArray *)angles{
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    
    for(int i = 1;i<angles.count; i++)
        [arr addObject:[NSNumber numberWithDouble:minAngle([[angles objectAtIndex:i-1] doubleValue],[[angles objectAtIndex:i] doubleValue])]];
    
    return [arr autorelease];
}

static double angleFromPoints(CGPoint start, CGPoint end){
    if(start.x<=end.x && start.y<=end.y){
        //      |
        //      |   e
        //      |
        // -----s-----
        //      |
        //      |
        
        double opp = end.y-start.y;
        double adj = end.x-start.x;
        
        if(adj==0)return 90;
        return toDeg(atan(opp/adj));
    }else if(start.x>=end.x && start.y<=end.y){
        //      |
        //  e   |
        //      |
        // -----s-----
        //      |
        //      |
        
        double opp = end.y-start.y;
        double adj = start.x-end.x;
        
        if(adj==0)return 90;
        return 180-toDeg(atan(opp/adj));
    }else if(start.x>=end.x && start.y>=end.y){
        //      |
        //      |
        //      |
        // -----s-----
        //      |
        //   e  |
        
        double opp = start.y-end.y;
        double adj = start.x-end.x;
        
        if(adj==0)return 270;
        return 180+toDeg(atan(opp/adj));
    }else if(start.x<=end.x && start.y>=end.y){
        //      |
        //      |
        //      |
        // -----s-----
        //      |
        //      |   e
        
        double opp = start.y-end.y;
        double adj = end.x-start.x;
        
        if(adj==0)return 270;
        return 360-toDeg(atan(opp/adj));
    }
    return 0;
}

static inline double minAngle(double a1, double a2){
    double min = MIN(a1,a2);
    double max = MAX(a1,a2);
    return MIN(max-min,min-max+360);
}


static inline double toDeg(double rad){
    return rad/M_PI*180;
}

@end
