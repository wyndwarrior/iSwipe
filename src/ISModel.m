#import "ISModel.h"

@implementation ISModel

+(id)sharedInstance{
    static ISModel *shared = nil;
    if( !shared) shared = [[ISModel alloc] init];
    return shared;
}

-(id) init{
    self = [super init];
    return self;
}

-(NSArray *)findMatch:(ISData *)data{
    int begin = [(data.keys)[0] letter]-'a';
    int end = [(data.keys)[data.keys.count-1] letter]-'a';
    NSString *path = [NSString stringWithFormat:@"%@/%c%c.plist", DPATH,  begin+'a', end+'a'];
    NSArray *words = [[NSArray alloc] initWithContentsOfFile:path ];
    //NSLog(@"%@ %@", words, path);
    NSMutableArray *iswords = [[NSMutableArray alloc] initWithCapacity:words.count];
    for(int i = 0; i<words.count; i++){
        NSDictionary * tmp = words[i];
        [iswords addObject:[ISWord word:tmp[@"Word"] match:tmp[@"Match"] weight:0 count:[tmp[@"Count"] integerValue]]];
    }
    //NSLog(@"%@", iswords);
    id<ISAlgoProtocol> algo = [[ISAlgoAngleDiffGreedy alloc] init];
    NSArray * arr = [algo findMatch:data dict:iswords];
    
    arr = [arr sortedArrayUsingSelector:@selector(compare:)];
    
    if( arr.count == 0) return arr;
    
    NSMutableArray * ret = [NSMutableArray array];
    double best = [arr[0] weight];
    for(ISWord *word in arr)
        if( word.weight > best*.5 )
            [ret addObject:word];
    
    return ret;
}

@end
