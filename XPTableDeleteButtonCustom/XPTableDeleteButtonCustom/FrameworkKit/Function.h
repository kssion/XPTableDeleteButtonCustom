//
//  Function.h
//  CTools
//
//  Created by Chance on 15/7/1.
//  Copyright (c) 2015年 Chance. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Function : NSObject

#pragma mark - 计时器

/**
 *  定时器 v3
 *
 *  @date   2016.05.08
 *
 *  @param starttime        开始时间
 *  @param timeout          超时时间
 *  @param increase         每个时间间隔的增加量
 *  @param interval         时间间隔
 *  @param runingHandler    每个时间间隔执行(当前时间)
 *  @param stopHandler      停止时执行(停止时间)
 *
 *  @return                 返回一个 t 用来控制运行. 取消运行dispatch_source_cancel(t)
 */
dispatch_source_t timer_create_v3(double starttime, double timeout, double increase, double interval, void(^runingHandler)(double currentTime), void(^stopHandler)(double stopTime));

/**
 *  倒计时 v3
 *
 *  @date   2016.05.08
 *
 *  @param duration         总时长
 *  @param decrease         每个时间间隔减少量
 *  @param interval         时间间隔
 *  @param runingHandler    每个时间间隔执行(当前时间)
 *  @param stopHandler      停止时执行(停止时间)
 *
 *  @return                 返回一个 t 用来控制运行. 取消运行dispatch_source_cancel(t)
 */
dispatch_source_t countdown_create_v3(double duration, double decrease, double interval, void(^runingHandler)(double currentTime), void(^stopHandler)(double stopTime));

/**
 定时器 v4
 
 date 2017.02.21
 
 @param starttime 开始时间
 @param increase 增加量
 @param interval 时间间隔
 @param runingHandler 事件处理(当前时间, 是否立即停止)
 @return 返回<dispatch_source_t>对象,用以控制timer运行
 */
dispatch_source_t timer_create_v4(double starttime, double increase, double interval, void(^runingHandler)(double currentTime, bool *stop));

/**
 倒计时 v4
 
 date: 2017.02.21
 
 @param duration 总时长
 @param decrease 减少量
 @param interval 时间间隔
 @param runingHandler 事件处理(当前时间, 是否立即停止)
 @return 返回<dispatch_source_t>对象,用以控制timer运行
 */
dispatch_source_t countdown_create_v4(double duration, double decrease, double interval, void(^runingHandler)(double currentTime));


#pragma mark -

/**
 *  主线程同步执行
 */
void dispatch_sync_main_safe(dispatch_block_t);

/**
 *  主线程异步执行
 */
void dispatch_async_main_safe(dispatch_block_t);

/**
 *  全局队列同步执行
 */
void dispatch_sync_global(dispatch_block_t);

/**
 *  全局队列异步执行
 */
void dispatch_async_global(dispatch_block_t);

void dispatch_async_global_main(dispatch_block_t global, dispatch_block_t main);

void dispatch_after_main(NSTimeInterval t, dispatch_block_t block);
void dispatch_after_global(NSTimeInterval t, dispatch_block_t block);


#pragma mark - 转换
/**
 *  字符串转换为NSURL
 *
 *  @param str URL字符串
 *
 *  @return NSURL
 */
NSURL *URLWithString(NSString *str);

NSString *str(NSString *format, ...) NS_FORMAT_FUNCTION(1, 2);

NSString *str_i(int arg);
NSString *str_l(long arg);
NSString *str_d(double arg);
NSString *str_f(float arg);


#pragma mark - Create
CGPoint v_center(UIView *view);


#pragma mark - UIColor
/**
 *  获取UIColor对象 (0 - 255)
 *
 *  @param r 红 0 - 255
 *  @param g 绿 0 - 255
 *  @param b 蓝 0 - 255
 */
UIColor *color_rgb(UInt8 r, UInt8 g, UInt8 b);

/**
 *  获取UIColor对象 (0.0 - 1.0)
 *
 *  @param r 红 0.0 - 1.0
 *  @param g 绿 0.0 - 1.0
 *  @param b 蓝 0.0 - 1.0
 */
UIColor *color_rgb_f(CGFloat r, CGFloat g, CGFloat b);

/**
 *  获取UIColor对象 (0.0 - 1.0)
 *
 *  @param r 红 0 - 255
 *  @param g 绿 0 - 255
 *  @param b 蓝 0 - 255
 *  @param a 透明度  0.0 - 1.0
 */
UIColor *color_rgba(UInt8 r, UInt8 g, UInt8 b, CGFloat a);

/**
 *  获取UIColor对象 (0.0 - 1.0)
 *
 *  @param r 红 0.0 - 1.0
 *  @param g 绿 0.0 - 1.0
 *  @param b 蓝 0.0 - 1.0
 *  @param a 透明度 0.0 - 1.0
 */
UIColor *color_rgba_f(CGFloat r, CGFloat g, CGFloat b, CGFloat a);

/**
 *  获取图片模式颜色
 *
 *  @param image 图片对象
 */
UIColor *color_image(UIImage *image);

/**
 *  获取UIColor对象 (0x000000 - 0xffffff)
 *
 *  @param hex 十六进制颜色
 */
UIColor *color_hex(NSUInteger hex);

/**
 *  获取UIColor对象 (0x000000 - 0xffffff)
 *
 *  @param hex   十六进制颜色
 *  @param alpha 透明度
 */
UIColor *color_hexAlpha(NSUInteger hex, CGFloat alpha);


#pragma mark - UIImage
/* UIImage */
UIImage *image_name(NSString *name);
UIImage *image_color(UIColor *color);
UIImage *image_colorHex(NSUInteger hex);

UIFont *font(CGFloat size);
UIFont *font_bold(CGFloat size);


#pragma mark -
CGFloat calculateFontSize(CGFloat size);


#pragma mark - 校验
/** 检查摄像头 */
BOOL checkValidateCamera();

/** 拨打电话(电话号码 number, 拨打前提示 isPrompt) */
BOOL callTelNumber(NSString *number, BOOL isPrompt);


/** 返回一个非空参数. If params the former is nil, select params the latter in successively. If all params is nil, return nil; */
id not_nil_object(id opt1, id opt2);

id params(id o1, id o2);

/** 返回一个非空字符串 如果都为空 则返回空字符串 @"" */
NSString *not_null_string(NSString *str1, NSString *str2);

/** 标注 如果前者为空 则返回后边字符串 */
NSString *stringNotEmpty(id ostr, NSString *pstr);

NSString *string_not_empty(id, ...);// NS_FORMAT_FUNCTION(1, 2);

/** 文件(路径)是否存在 */
BOOL fileExistsAtPath(NSString *path);

bool StringIsEmpty(NSString *);
bool StringIsBlank(NSString *);
bool ArrayIsEmpty(NSArray *);
bool DictionaryIsEmpty(NSDictionary *);
bool SetIsEmpty(NSSet *);


#pragma mark - NSUserDefaults
id userDefaultsGet(NSString *key);
void userDefaultsSet(id obj, NSString *key);
void userDefaultsRemove(NSString *key);
void userDefaultsClear();


#pragma mark - 沙盒路径
/* 沙盒路径 */
/** Documents/ */
NSString *pathForDocuments();

/** Library/Caches/ */
NSString *pathForCaches();

/** Documents/<文件名> */
NSString *pathForDocumentsFileName(NSString *name);

/** Documents/<子路径>/<文件名> */
NSString *pathForDocumentsFilePathName(NSString *subPath, NSString *name);

/** Documents/<文件名> */
NSString *pathForCachesFileName(NSString *name);

/** Documents/<子路径>/<文件名> */
NSString *pathForCachesFilePathName(NSString *subPath, NSString *name);

NSString *pathForLibraryFilePathName(NSString *subPath, NSString *name);

BOOL create_path(NSString *path);

    
#pragma mark -
/** 获取类的变量列表 */
NSArray *getVarListForClass(Class cla);

/**
 控制台输出方法

 @date  2017.2.33
 @param file    __FILE__
 @param line    __LINE__
 @param text    格式字符串
 */
void xpprint(const char *file, int line, NSString *text);



UIView *find(UIView *v);

double radian(float deg);

CGSize CGSizeScale(CGSize size, float scale);
CGPoint CGPointScale(CGPoint point, float scale);

@end
