int main(int argc, char **argv, char **envp) {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    for(int i = 0; i<26; i++)
        for(int j = 0; j<26; j++){
            NSString *path = [NSString stringWithFormat:@"/var/mobile/Library/Wynd/Swype/English/dictionary-%d-%d.txt", i, j];
            NSString *dictionary = [[NSString alloc] initWithContentsOfFile:path encoding:NSASCIIStringEncoding error:nil];
            
            NSArray *words = [[dictionary componentsSeparatedByString:@"\n"] retain];
            [dictionary release];
            NSMutableArray *arr = [[NSMutableArray alloc] init];
            
            for(int i = 0; i<words.count; i++){
                NSString *word = [[words objectAtIndex:i] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                if(word.length>0)
                    [arr addObject:word];
            }
            
            [words release];
            
            [[NSPropertyListSerialization dataFromPropertyList:arr format:NSPropertyListBinaryFormat_v1_0 errorDescription:nil] writeToFile:[NSString stringWithFormat:@"/var/mobile/Library/Wynd/Swype/English/%d-%d.plist", i, j] atomically:true];
            
        }
    
    [pool release];
	return 0;
}