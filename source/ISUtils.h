//
//  ISUtils.h
//  iSwipe
//
//  Created by Andrew Liu on 6/4/12.
//  Copyright (c) 2012 Wynd. All rights reserved.
//

#ifndef iSwipe_ISUtils_h
#define iSwipe_ISUtils_h

#import <Foundation/Foundation.h>

#define FMAN [NSFileManager defaultManager]
static inline bool dirExists(NSString * path){
    BOOL b;
    BOOL e = [FMAN fileExistsAtPath:path isDirectory:&b];
    return e && b;
}

static inline bool fileExists(NSString * path){
    BOOL b;
    BOOL e = [FMAN fileExistsAtPath:path isDirectory:&b];
    return e && !b;
}
#define createDir(path) ([FMAN createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil])
#define timeStamp(path) [[FMAN attributesOfItemAtPath:path error:nil] fileModificationDate]
#define getDir(path) [FMAN contentsOfDirectoryAtPath:path error:nil]
#define deleteFile(path) [FMAN removeItemAtPath:path error:nil]
#define _alert(x) [[[UIAlertView alloc] initWithTitle:@"Alert" message:x delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles: nil] show]

#define TESTING 0

#if TESTING
#define DPATH ([documents() stringByAppendingPathComponent:@"Dictionary"])
#define PATH [[NSBundle mainBundle] bundlePath]
#else
#define PATH @"/usr/share/iSwipe"
#define DPATH [PATH stringByAppendingPathComponent:@"Dictionaries/EN"]
#endif

static inline NSString* documents(){
#if TESTING
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return documentsDirectory;
#else
    return @"/var/mobile/Library/Keyboard/iSwipe";
#endif
}

#define PI 3.14159265358

#define toDegrees(x) (x * 180 / PI)

static inline double dist(double dx1, double dy1){
    return sqrt(dx1*dx1 + dy1*dy1);
}

static inline double dot(double dx1, double dy1, double dx2, double dy2){
    return dx1 * dx2 + dy1 * dy2;
}

static inline double cross(double dx1, double dy1, double dx2, double dy2){
    return dx1 * dy2 - dx2 * dy1;
}

static inline double vecAng(double dx1, double dy1, double dx2, double dy2){
    double dt = dot(dx1, dy1, dx2, dy2);
    dt /= dist(dx1, dy1) * dist(dx2, dy2);
    if( dt > 1 ) dt = 1;
    else if( dt < -1) dt = -1;
    return toDegrees(acos(dt));
}

static inline double ptDist(double x1, double y1, double x2, double y2, double px, double py){
    
    double dx1 = x2-x1; //vec p1 -> p2
    double dy1 = y2-y1;
    double dx2 = px-x1; //p1 -> pt
    double dy2 = py-y1;
    double dx3 = px-x2; //p2 -> pt
    double dy3 = py-y2; 
    double dx4 = x1-x2; //p2 -> p1
    double dy4 = y1-y2;
    
    
    /* p1->p2 X p1->pt
     
           pt
           |
           |
     p1 ------ p2
     
     */
    double d1 =  cross(dx1, dy1, dx2, dy2) / dist(dx1, dy1);
    
    /*  p2->pt * p1->p2
     
                   pt
                  /
                 /
     p1 ------ p2 
     
     */
    if(dot(dx3, dy3, dx1, dy1) > 0) return dist(dx3, dy3);
    
    /*  p1->pt * p2->p1
     
     pt
      \
       \
        p1 ------ p2 
     
     */
    if(dot(dx2, dy2, dx4, dy4) > 0)return dist(dx2, dy2);
    
    return abs(d1);
}

static inline void WRITEPLIST(NSString *path, NSObject *obj) {
    NSLog(@"%@", path);
    [[NSPropertyListSerialization dataFromPropertyList:obj format:NSPropertyListBinaryFormat_v1_0 errorDescription:nil] writeToFile:path atomically:true];
}

#endif
