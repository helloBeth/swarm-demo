//
//  GlobalMacro.h

//

#ifndef SearchDriver_GlobalMacro_h
#define SearchDriver_GlobalMacro_h

#import "AppDelegate.h"


#ifndef XcodeAppVersion
#define XcodeAppVersion [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]
#endif

#define LAUNCHIMG_PATH [NSString stringWithFormat:@"%@/launchImg.png",[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0]]


#define kSendOrderKey  @"sendDriveOrder"

#define INT_TO_STR(i)   [NSString stringWithFormat:@"%d", i]

#define LHError(error) if (error) { \
NSLog(@"发生错误:%@ (%d) ERROR: %@", \
[[NSString stringWithUTF8String:__FILE__] lastPathComponent], \
__LINE__, [error localizedDescription]); \
}

#endif

#define DEFINE_SINGLETON_FOR_HEADER(className) \
\
+ (className *)shared##className;

#define DEFINE_SINGLETON_FOR_CLASS(className) \
\
+ (className *)shared##className { \
    static className *shared##className = nil; \
    static dispatch_once_t onceToken; \
    dispatch_once(&onceToken, ^{ \
        shared##className = [[self alloc] init]; \
    }); \
    return shared##className; \
}





