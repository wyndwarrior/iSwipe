#import "SwypeModel.h"

@interface SwypeDictionaryObject : NSObject{
    NSString *word;
    double weight;
}
@property(nonatomic, retain) NSString *word;
@property(nonatomic, assign) double weight;
@end
@implementation SwypeDictionaryObject
@synthesize word, weight;
-(NSComparisonResult)compare:(SwypeDictionaryObject *)obj{
    if(weight>obj.weight) return NSOrderedAscending;
    else if(weight<obj.weight) return NSOrderedDescending;
    return NSOrderedSame;
}
-(void)dealloc{
    [word release];
    [super dealloc];
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
        for(int j = 1; j<=input.length; j++)
            if([input characterAtIndex:j-1]==[word characterAtIndex:i-1])
                mat[i][j] = MAX(mat[i-1][j-1]+wei[j-1], mat[i-1][j]-30);
            else
                mat[i][j] = MAX(mat[i-1][j], mat[i][j-1]);
    
    return mat[word.length][input.length];
}

static bool matches(NSString *input, NSString *word){
    int j = 0, i = 0;
    for(; i<input.length && j<word.length; i++)
        if([input characterAtIndex:i] == [word characterAtIndex:j])
            while(j<word.length && [input characterAtIndex:i] == [word characterAtIndex:j])
                j++;
    return j==word.length;
}

static double angleFromPoints(CGPoint start, CGPoint end);
static NSArray* findAnglesForPoints(NSArray* entrancePoints);
static NSArray* findAngleDifferences(NSArray * angles);
static inline double toDeg(double rad);
static inline double minAngle(double a1, double a2);

+(NSArray *)findBestMatches:(NSString *)input forPoints:(NSArray *)entrancePoints{
    int begin = [input characterAtIndex:0]-97, end = [input characterAtIndex:input.length-1]-97;
    NSString *path = [NSString stringWithFormat:@"/var/swype/English/%d-%d.plist", begin, end];
    NSArray *words = [[NSArray alloc] initWithContentsOfFile:path ];
    
    NSArray *weights = findAngleDifferences(findAnglesForPoints(entrancePoints));
    
    for(int i = 0; i<weights.count; i++)
        wei[i+1] = [[weights objectAtIndex:i] doubleValue];
    
    wei[0] = 180;wei[weights.count+1] = 180;
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    
    for(int i = 0; i<words.count; i++){
        NSString *word = [words objectAtIndex:i];
        if(matches(input, word)){
            SwypeDictionaryObject *tmp = [[SwypeDictionaryObject alloc] init];
            tmp.weight = (words.count-i)/words.count*180+wlcs(input,word);
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

static NSArray* findAnglesForPoints(NSArray* entrancePoints){
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    
    for(int i = 1; i<entrancePoints.count; i++){
        CGPoint one = [[entrancePoints objectAtIndex:i-1] point];
        CGPoint two = [[entrancePoints objectAtIndex:i] point];
        [arr addObject:[NSNumber numberWithDouble:angleFromPoints(one,two)]];
    }
    
    return [arr autorelease];
}

static NSArray* findAngleDifferences(NSArray * angles){
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


+(void)updatePreference:(NSString *)str{
    int begin = [str characterAtIndex:0]-97, end = [str characterAtIndex:str.length-1]-97;
    NSString *path = [NSString stringWithFormat:@"/var/swype/English/%d-%d.plist", begin, end];
    NSMutableArray *words = [[NSMutableArray alloc] initWithContentsOfFile:path];
    
    //TODO: optimize this
    [words removeObject:str];
    [words insertObject:str atIndex:0];
    
    [[NSPropertyListSerialization dataFromPropertyList:words format:NSPropertyListBinaryFormat_v1_0 errorDescription:nil] writeToFile:path atomically:true];
}

@end
