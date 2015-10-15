//
//  CDMacro.h
//  CDDemo
//
//  Created by x.wang on 4/30/15.
//  Copyright (c) 2015 x.wang. All rights reserved.
//

#ifndef CDDemo_CDMacro_h
#define CDDemo_CDMacro_h

#import <UIKit/UIKit.h>

//-------------------Get screen width, height-------------------

#define CD_SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define CD_SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

//-------------------Get system version-------------------

#define CD_IOS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]
#define CD_SYSTEM_VERSION [[UIDevice currentDevice] systemVersion]

//-------------------Get system languages-------------------

#define CD_SYSTEM_LANGUAGE ([[NSLocale preferredLanguages] objectAtIndex:0])

//-------------------Judge device is iPad, iPhone-------------------

#define CD_IS_PAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define CD_IS_PHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)

// -------------------RGB color conversion-------------------

#define CD_ColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define CD_ColorWithRGBA(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define CD_ColorWithRGB(r,g,b) RGBA(r,g,b,1.0f)

//-------------------Load image from file-------------------
#define CD_LOADIMAGE(file,type) [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:file ofType:type]]

//-------------------Print logs-------------------

#if DEBUG
#   define Log(fmt, ...) fprintf(stderr,"[%s] %s", __TIME__, [[NSString stringWithFormat:fmt, ##__VA_ARGS__] UTF8String])
#else
#   define Log(...)
#endif

#if DEBUG
#   define NSLog(fmt, ...) fprintf(stderr,"\n[%s] function:%s line:%d\n-content:%s\n",__TIME__, __FUNCTION__, __LINE__, [[NSString stringWithFormat:fmt, ##__VA_ARGS__] UTF8String])
#else
#   define NSLog(fmt, ...)
#endif

#if DEBUG
#   define Alert(fmt, ...) \
    { \
        NSString *titleStr = [NSString stringWithFormat:@"%s\n [Line %d] ", __PRETTY_FUNCTION__, __LINE__]; \
        NSString *msgStr = [NSString stringWithFormat:fmt, ##__VA_ARGS__]; \
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:titleStr message:msgStr  delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil]; \
        [alert show];\
        Log(@"--------------Show Alert---------------");\
        NSLog(fmt, ##__VA_ARGS__);\
        Log(@"-----------------End-------------------");\
    }
#else
#   define Alert(...)
#endif 

//-------------------Add property with Category, Override getter and setter method-------------------
/* Example：
static const void* kCurrent = "Current";
 - (void)setList:(NSMutableArray *)list{
    objc_set(kCurrent, list);
}
 - (NSMutableArray *)getList{
    id obj = objc_get(kCurrent);
    if ([obj isKindOfClass:[NSMutableArray class]]) {
        return obj;
    }
    return nil;
}
*/
#import <objc/runtime.h>
#define objc_set(k,v) objc_setAssociatedObject(self, k, v, OBJC_ASSOCIATION_RETAIN)
#define objc_get(k) objc_getAssociatedObject(self, k)

//-------------------GCD-------------------

#define dispatch_main_sync_safe(block)\
if ([NSThread isMainThread]) {\
block();\
} else {\
dispatch_sync(dispatch_get_main_queue(), block);\
}

#define dispatch_main_async_safe(block)\
if ([NSThread isMainThread]) {\
block();\
} else {\
dispatch_async(dispatch_get_main_queue(), block);\
}

#define dispatch_global_sync(block)\
dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block)

#define dispatch_global_async(block)\
dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block)


#endif
