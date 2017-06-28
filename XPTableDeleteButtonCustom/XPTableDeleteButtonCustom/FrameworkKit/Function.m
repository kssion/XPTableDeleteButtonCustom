//
//  Function.m
//  CTools
//
//  Created by Chance on 15/7/1.
//  Copyright (c) 2015年 Chance. All rights reserved.
//

#import "Function.h"
#import <objc/runtime.h>

@implementation Function

dispatch_source_t timer_create_v3(double starttime, double timeout, double increase, double interval, void(^runingHandler)(double currentTime), void(^stopHandler)(double stopTime)) {
    if ((runingHandler || stopHandler)) {
        __block double      _time       = 0.0f;
        dispatch_queue_t    _queue      = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_source_t   _timer      = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, _queue);
        
        dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), interval * NSEC_PER_SEC, 0);
        dispatch_source_set_event_handler(_timer, ^{
            
            if (_time < timeout) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (runingHandler) {
                        runingHandler(_time);
                    }
                    _time += increase;
                });
            } else {
                dispatch_source_cancel(_timer);
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (stopHandler) {
                        stopHandler(_time);
                    }
                });
            }
        });
        dispatch_resume(_timer);
        return _timer;
    }
    return NULL;
}

dispatch_source_t countdown_create_v3(double duration, double decrease, double interval, void(^runingHandler)(double currentTime), void(^stopHandler)(double stopTime)) {
    if ((runingHandler || stopHandler)) {
        __block double      _timeout    = duration;
        dispatch_queue_t    _queue      = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_source_t   _timer      = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, _queue);
        
        dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), interval * NSEC_PER_SEC, 0);
        dispatch_source_set_event_handler(_timer, ^{
            
            if (_timeout > 0) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (runingHandler) {
                        runingHandler(_timeout);
                    }
                    _timeout -= decrease;
                });
            } else {
                dispatch_source_cancel(_timer);
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (stopHandler) {
                        stopHandler(_timeout);
                    }
                });
            }
        });
        dispatch_resume(_timer);
        return _timer;
    }
    return NULL;
}

dispatch_source_t timer_create_v4(double starttime, double increase, double interval, void(^runingHandler)(double currentTime, bool *stop)) {
    
    if (runingHandler) {
        
        __block bool        _stop   = NO;
        __block double      _time   = 0.0f;
        dispatch_queue_t    _queue  = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_source_t   _timer  = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, _queue);
        
        dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), interval * NSEC_PER_SEC, 0);
        dispatch_source_set_event_handler(_timer, ^{
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (_time >= starttime) {
                    runingHandler(_time, &_stop);
                    if (_stop) dispatch_source_cancel(_timer);
                }
                _time += increase;
            });
        });
        dispatch_resume(_timer);
        return _timer;
    }
    return NULL;
}

dispatch_source_t countdown_create_v4(double duration, double decrease, double interval, void(^runingHandler)(double currentTime)) {
    
    if (runingHandler && duration > 0) {
        __block double            _time     = duration;
        dispatch_queue_t          _queue    = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_source_t _timer    = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, _queue);
        
        dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), interval * NSEC_PER_SEC, 0);
        dispatch_source_set_event_handler(_timer, ^{
            
            dispatch_async(dispatch_get_main_queue(), ^{
                runingHandler(_time);
                _time -= decrease;
                if (_time < 0) dispatch_source_cancel(_timer);
            });
        });
        dispatch_resume(_timer);
        return _timer;
    }
    return NULL;
}


#pragma mark -
void dispatch_sync_main_safe(dispatch_block_t block) {
    if ([NSThread isMainThread]) {
        block();
    } else {
        dispatch_sync(dispatch_get_main_queue(), block);
    }
}

void dispatch_async_main_safe(dispatch_block_t block) {
    if ([NSThread isMainThread]) {
        block();
    } else {
        dispatch_async(dispatch_get_main_queue(), block);
    }
}

void dispatch_sync_global(dispatch_block_t block) {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block);
}

void dispatch_async_global(dispatch_block_t block) {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block);
}

void dispatch_async_global_main(dispatch_block_t global, dispatch_block_t main) {
    dispatch_async_global(^{
        global();
        dispatch_async_main_safe(^{
            main();
        });
    });
}

void dispatch_after_main(NSTimeInterval t, dispatch_block_t block) {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        block();
    });
}

void dispatch_after_global(NSTimeInterval t, dispatch_block_t block) {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        block();
    });
}



#pragma mark -
NSString *strWithInt(int i) {
    return [NSString stringWithFormat:@"%d", i];
}

NSURL *URLWithString(NSString *str) {
    return [NSURL URLWithString:str];
}

NSString *str(NSString *format, ...) {
    va_list list;
    va_start(list, format);
    NSString *text = [[NSString alloc] initWithFormat:format arguments:list];
    va_end(list);
    return text;
}

NSString *str_i(int arg) {
    return str(@"%d", arg);
}
NSString *str_l(long arg) {
    return str(@"%ld", arg);
}
NSString *str_d(double arg) {
    return str(@"%f", arg);
}
NSString *str_f(float arg) {
    return str(@"%f", arg);
}


#pragma mark -
CGPoint v_center(UIView *view) {
    return CGPointMake(view.frame.size.width * .5, view.frame.size.height * .5);
}


#pragma mark -
UIColor *color_rgb(UInt8 r, UInt8 g, UInt8 b) {
    return color_rgba(r, g, b, 1);
}

UIColor *color_rgb_f(CGFloat r, CGFloat g, CGFloat b) {
    return color_rgba_f(r, g, b, 1);
}

UIColor *color_rgba(UInt8 r, UInt8 g, UInt8 b, CGFloat a) {
    return [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a];
}

UIColor *color_rgba_f(CGFloat r, CGFloat g, CGFloat b, CGFloat a) {
    return [UIColor colorWithRed:r green:g blue:b alpha:a];
}

UIColor *color_image(UIImage *image) {
    return [UIColor colorWithPatternImage:image];
}

UIColor *color_hex(NSUInteger hex) {
    return color_hexAlpha(hex, 1);
}

UIColor *color_hexAlpha(NSUInteger hex, CGFloat alpha) {
    CGFloat red = (hex >> 16 & 0xFF) / 255.0f;
    CGFloat green = (hex >> 8 & 0xFF) / 255.0f;
    CGFloat blue = (hex & 0xFF) / 255.0f;
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

#pragma mark -
UIImage *image_name(NSString *name) {
    return [UIImage imageNamed:name];
}

UIImage *image_color(UIColor *color) {
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

UIImage *image_colorHex(NSUInteger hex) {
    return image_color(color_hex(hex));
}

UIFont *font(CGFloat size) {
    return [UIFont systemFontOfSize:size];
}

UIFont *font_bold(CGFloat size) {
    return [UIFont boldSystemFontOfSize:size];
}


#pragma mark -
BOOL checkValidateCamera() {
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] &&
    [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
}

BOOL isPhoneNumber(NSString *str) {
    //
    NSString *MOBILE    = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    NSString *CM        = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[2378]|7[7])\\d)\\d{7}$";   // 包含电信4G 177号段
    NSString *CU        = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    NSString *CT        = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    
    //
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    BOOL res1 = [regextestmobile evaluateWithObject:str];
    BOOL res2 = [regextestcm evaluateWithObject:str];
    BOOL res3 = [regextestcu evaluateWithObject:str];
    BOOL res4 = [regextestct evaluateWithObject:str];
    
    if (res1 || res2 || res3 || res4 ) {
        return YES;
    }
    
    return NO;
}

BOOL callTelNumber(NSString *number, BOOL isPrompt) {
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", number]];
    
    if (isPrompt) {
        URL = [NSURL URLWithString:[NSString stringWithFormat:@"telprompt://%@", number]];
    }
    BOOL status = [[UIApplication sharedApplication] canOpenURL:URL];
#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_10_0
    if (status) {
        status = [[UIApplication sharedApplication] openURL:URL];
    }
#else
    [[UIApplication sharedApplication] openURL:URL options:@{UIApplicationOpenURLOptionUniversalLinksOnly: @YES} completionHandler:nil];
#endif
    return status;
}

id not_nil_object(id opt1, id opt2) {
    if (opt1) {
        return opt1;
    }
    return opt2;
}

id params(id o1, id o2) {
    return not_nil_object(o1, o2);
}

NSString *not_null_string(NSString *str1, NSString *str2) {
    if (str1) {
        if ([str1 isKindOfClass:[NSString class]]) {
            return str1;
        }
        if ([str1 isKindOfClass:[NSNumber class]]) {
            return [NSString stringWithFormat:@"%@", str1];
        }
        if ([str1 isKindOfClass:[NSNull class]]) {
            return @"";
        }
        if ([str1 isKindOfClass:[NSDictionary class]]) {
            return [NSString stringWithFormat:@"%@", str1];
        }
        if ([str1 isKindOfClass:[NSArray class]]) {
            return [NSString stringWithFormat:@"%@", str1];
        }
    }
    if (str2) {
        if ([str2 isKindOfClass:[NSString class]]) {
            return str2;
        }
        if ([str2 isKindOfClass:[NSNumber class]]) {
            return [NSString stringWithFormat:@"%@", str2];
        }
        if ([str2 isKindOfClass:[NSNull class]]) {
            return @"";
        }
        if ([str2 isKindOfClass:[NSDictionary class]]) {
            return [NSString stringWithFormat:@"%@", str2];
        }
        if ([str2 isKindOfClass:[NSArray class]]) {
            return [NSString stringWithFormat:@"%@", str2];
        }
    }
    return @"";
}

NSString *stringNotEmpty(id ostr, NSString *pstr) {
    if (ostr) {
        if ([ostr isKindOfClass:[NSString class]]) {
            return ostr;
        }
        if ([ostr isKindOfClass:[NSNumber class]]) {
            return [NSString stringWithFormat:@"%@", ostr];
        }
    }
    return pstr;
}

NSString *string_not_empty(NSString *str, ...) {
    va_list list;
    va_start(list, str);
    NSString *text = [[NSString alloc] initWithFormat:str arguments:list];
    va_end(list);
    return text;
}

BOOL fileExistsAtPath(NSString *path) {
    return [[NSFileManager defaultManager] fileExistsAtPath:path];
}

bool StringIsEmpty(NSString *str) {
    if ([str isKindOfClass:[NSString class]] && [str length] > 0) {
        return false;
    }
    return true;
}

bool StringIsBlank(NSString *str) {
    if (StringIsEmpty(str)) {
        return true;
    }
    return StringIsEmpty([str stringByReplacingOccurrencesOfString:@" " withString:@""]);
}

bool ArrayIsEmpty(NSArray *array) {
    if ([array isKindOfClass:[NSArray class]] && [array count] > 0) {
        return false;
    }
    return true;
}

bool DictionaryIsEmpty(NSDictionary *dict) {
    if ([dict isKindOfClass:[NSDictionary class]] && [dict count] > 0) {
        return false;
    }
    return true;
}

bool SetIsEmpty(NSSet *set) {
    if ([set isKindOfClass:[NSSet class]] && [set count] > 0) {
        return false;
    }
    return true;
}


#pragma mark -
id userDefaultsGet(NSString *key) {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    return [ud objectForKey:key];
}

void userDefaultsSet(id obj, NSString *key) {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:obj forKey:key];
    [ud synchronize];
}

void userDefaultsRemove(NSString *key) {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud removeObjectForKey:key];
    [ud synchronize];
}

void userDefaultsClear() {
    [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:[[NSBundle mainBundle] bundleIdentifier]];
}

#pragma mark -
NSString *pathForDocuments() {
    return [NSString stringWithFormat:@"%@/Documents/", NSHomeDirectory()];
}

NSString *pathForCaches() {
    return [NSString stringWithFormat:@"%@/Library/Caches/", NSHomeDirectory()];
}

NSString *pathForDocumentsFileName(NSString *name) {
    NSMutableString *ms = [NSMutableString stringWithFormat:@"%@/Documents/", NSHomeDirectory()];
    
    if (name && ![name isEqualToString:@""]) {
        [ms appendFormat:@"%@", name];
    }
    
    return [ms copy];
}

NSString *pathForDocumentsFilePathName(NSString *subPath, NSString *name) {
    NSMutableString *ms = [NSMutableString stringWithFormat:@"%@/Documents/", NSHomeDirectory()];
    
    if (subPath && ![subPath isEqualToString:@""]) {
        if (![ms hasPrefix:@"/"]) {
            [ms appendString:@"/"];
        }
        
        [ms appendString:subPath];
        
        if (![ms hasSuffix:@"/"]) {
            [ms appendString:@"/"];
        }
    }
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:ms]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:ms withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    if (name && ![name isEqualToString:@""]) {
        [ms appendFormat:@"%@", name];
    }
    
    return [ms copy];
}

NSString *pathForCachesFileName(NSString *name) {
    NSMutableString *ms = [NSMutableString stringWithFormat:@"%@/Library/Caches/", NSHomeDirectory()];
    
    if (name && ![name isEqualToString:@""]) {
        [ms appendFormat:@"%@", name];
    }
    
    return [ms copy];
}

NSString *pathForCachesFilePathName(NSString *subPath, NSString *name) {
    NSMutableString *ms = [NSMutableString stringWithFormat:@"%@/Library/Caches/", NSHomeDirectory()];
    
    if (subPath && ![subPath isEqualToString:@""]) {
        if (![ms hasPrefix:@"/"]) {
            [ms appendString:@"/"];
        }
        
        [ms appendString:subPath];
        
        if (![ms hasSuffix:@"/"]) {
            [ms appendString:@"/"];
        }
    }
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:ms]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:ms withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    if (name && ![name isEqualToString:@""]) {
        [ms appendFormat:@"%@", name];
    }
    
    return [ms copy];
}
    
NSString *pathForLibraryFilePathName(NSString *subPath, NSString *name) {
    NSMutableString *ms = [NSMutableString stringWithFormat:@"%@/Library/", NSHomeDirectory()];
    
    if (subPath && ![subPath isEqualToString:@""]) {
        if (![ms hasPrefix:@"/"]) {
            [ms appendString:@"/"];
        }
        
        [ms appendString:subPath];
        
        if (![ms hasSuffix:@"/"]) {
            [ms appendString:@"/"];
        }
    }
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:ms]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:ms withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    if (name && ![name isEqualToString:@""]) {
        [ms appendFormat:@"%@", name];
    }
    
    return [ms copy];
}
    
BOOL create_path(NSString *path) {
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        return YES;
    }
    return [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
}



#pragma mark -
NSArray *getVarListForClass(Class cla) {
    NSMutableArray *array = [NSMutableArray array];
    unsigned int count = 0;
    Ivar *members = class_copyIvarList(cla, &count);
    for (int i = 0; i < count; ++i) {
        Ivar var = members[i];
        const char *name = ivar_getName(var);
        const char *type = ivar_getTypeEncoding(var);
        
        NSDictionary *dict = @{@"name": [NSString stringWithUTF8String:name], @"type":[NSString stringWithUTF8String:type]};
        [array addObject:dict];
    }
    free(members);
    return array;
}

void xpprint(const char *file, int line, NSString *text) {
    file = [[[NSString stringWithUTF8String:file] lastPathComponent] UTF8String];
    fprintf(stderr, "%s:%d　\t%s\n", file, line, [text UTF8String]);
}

UIView *find(UIView *v) {
    
    NSLog(@"%@", v.class);
    
    if ([v isKindOfClass:NSClassFromString(@"UIControl")]) {
        return v;
    }
    
    for (UIView *subv in v.subviews) {
        return find(subv);
    }
    
    return nil;
}

double radian(float deg) {
    return deg / 180 * M_PI;
}

CGSize CGSizeScale(CGSize size, float scale) {
    return CGSizeMake(size.width * scale, size.height * scale);
}

CGPoint CGPointScale(CGPoint point, float scale) {
    return CGPointMake(point.x * scale, point.y * scale);
}



@end
