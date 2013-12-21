//
//  ISAlgoAngleDiffDP.m
//  iSwipe
//
//  Created by Andrew Liu on 6/11/12.
//  Copyright (c) 2012 Wynd. All rights reserved.
//

#import "ISAlgoAngleDiffDP.h"

@implementation ISAlgoAngleDiffDP


static double getValue(ISData *data, ISWord* iword, double** mat){
    NSArray *keys = data.keys;
    NSString *word = iword.word;
    
    for(int i = 0; i<=word.length; i++)
        mat[i][0] = BAD;
    for(int j = 0; j<=keys.count; j++)
        mat[0][j] = BAD;
    mat[0][0] = BASE;
    
    for(int i = 1; i<=word.length; i++)
        for(int j = 1; j<=keys.count; j++){
            mat[i][j] = BAD;
            if( [word characterAtIndex:i-1] == [[keys objectAtIndex:j-1] letter] && (mat[i-1][j-1] != -1 || mat[i-1][j] != BAD) ) //matches
                mat[i][j] = MAX(mat[i-1][j-1] + [[keys objectAtIndex:j-1] angle] , mat[i-1][j] + BONUS);
            if( mat[i][j-1] != BAD )
                mat[i][j] = MAX(mat[i][j], mat[i][j-1]);
        }
    
    return mat[word.length][keys.count];
}

-(NSArray *)findMatch:(ISData *)data dict:(NSArray *)dict{
    NSMutableArray *arr = [NSMutableArray array];
    
    int max = 0;
    for(ISWord * word in dict)
        max = MAX(max, word.match.length);
    max ++;
    double** mat = new double*[max];
    for(int i = 0; i<max; i++)
        mat[i] = new double[data.keys.count+1];
    
    for(ISWord * str in dict){
        double val = getValue(data, str, mat);
        str.weight = val;
        if( val != BAD )
            [arr addObject:str];
    }
    
    for(int i = 0; i<max; i++)
        delete[] mat[i];
    delete[] mat;
    
    return arr;
}

@end
