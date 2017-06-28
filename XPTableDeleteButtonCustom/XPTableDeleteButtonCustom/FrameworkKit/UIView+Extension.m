//
//  UIView+Extension.m
//  CTools
//
//  Created by Chance. on 15/4/30.
//  Copyright (c) 2015年 Chance. All rights reserved.
//

#import "UIView+Extension.h"
#import <objc/runtime.h>

@implementation UIView (Extension)

- (CGFloat)x {
    return self.center.x;
}
- (void)setX:(CGFloat)x {
    CGPoint center = self.center;
    center.x = x;
    self.center = center;
}

- (CGFloat)y {
    return self.center.y;
}
- (void)setY:(CGFloat)y {
    CGPoint center = self.center;
    center.y = y;
    self.center = center;
}

- (CGFloat)top {
    return CGRectGetMinY(self.frame);
}
- (void)setTop:(CGFloat)top {
    CGRect frame = self.frame;
    frame.origin.y = top;
    self.frame = frame;
}

- (CGFloat)bottom {
    return CGRectGetMaxY(self.frame);
}
- (void)setBottom:(CGFloat)bottom {
    CGRect frame = self.frame;
    frame.origin.y = bottom - self.frame.size.height;
    self.frame = frame;
}

- (CGFloat)bottomEdge {
    return self.superview.frame.size.height - self.frame.origin.y - self.frame.size.height;
}

- (CGFloat)left {
    return CGRectGetMinX(self.frame);
}
- (void)setLeft:(CGFloat)left {
    CGRect frame = self.frame;
    frame.origin.x = left;
    self.frame = frame;
}

- (CGFloat)right {
    return CGRectGetMaxX(self.frame);
}
- (void)setRight:(CGFloat)right {
    CGRect frame = self.frame;
    frame.origin.x = right - self.frame.size.width;
    self.frame = frame;
}

- (CGFloat)rightEdge {
    return self.superview.frame.size.width - self.frame.origin.x - self.frame.size.width;
}

- (CGFloat)width {
    return self.frame.size.width;
}
- (void)setWidth:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)height {
    return self.frame.size.height;
}
- (void)setHeight:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

// 此GET方法与 iOS 9.1 有冲突 获取视图大小请使用 getSize 或 frame.size //15.10.28
//- (CGSize)size
//{
//    return self.bounds.size;
//}
- (CGSize)getSize {
    return self.bounds.size;
}
- (void)setSize:(CGSize)size {
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}


#pragma mark -
- (void)setBorderWidth:(CGFloat)width color:(UIColor *)color {
    self.layer.borderWidth = width;
    self.layer.borderColor = color.CGColor;
}

- (void)setBorderRadius:(CGFloat)radius {
    self.layer.masksToBounds = radius > 0;
    self.layer.cornerRadius = radius;
}

- (void)colorDebug {
#if DEBUG
    self.backgroundColor = [UIColor colorWithRed:arc4random() % 100 / 100.0 green:arc4random() % 100 / 100.0 blue:arc4random() % 100 / 100.0 alpha:0.5];
#endif
}

- (void)colorDebugGray {
#if DEBUG
    self.backgroundColor = [UIColor colorWithRed:204 / 255.0 green:204 / 255.0 blue:204 / 255.0 alpha:0.5];
#endif
}

- (void)colorDebugSubviews {
#if DEBUG
    for (UIView *v in self.subviews) {
        v.backgroundColor = [UIColor colorWithRed:arc4random() % 100 / 100.0 green:arc4random() % 100 / 100.0 blue:arc4random() % 100 / 100.0 alpha:0.5];
    }
#endif
}

- (void)colorDebugSubviewsGray {
#if DEBUG
    for (UIView *v in self.subviews) {
        v.backgroundColor = [UIColor colorWithRed:204 / 255.0 green:204 / 255.0 blue:204 / 255.0 alpha:0.5];
    }
#endif
}

- (void)colorDebugSubviewsIn {
    for (UIView *v in self.subviews) {
        if (v.subviews.count > 0) {
            [v colorDebugSubviewsIn];
        } else {
            v.backgroundColor = [UIColor colorWithRed:arc4random() % 100 / 100.0 green:arc4random() % 100 / 100.0 blue:arc4random() % 100 / 100.0 alpha:0.3];
        }
    }
}


#pragma mark -
static BOOL debugLayerStatus;

- (CALayer *)debugLayer {
    CALayer *layer = objc_getAssociatedObject(self, @selector(debugLayer));
    if (!layer) {
        layer = [CALayer layer];
        objc_setAssociatedObject(self, @selector(debugLayer), layer, OBJC_ASSOCIATION_RETAIN);
    }
    return layer;
}

- (void)openLayerDebug {
    debugLayerStatus = true;
    [self.layer addSublayer:self.debugLayer];
    
    self.debugLayer.frame = self.layer.bounds;
    self.debugLayer.borderWidth = [[UIScreen mainScreen] scale] / 1;
    self.debugLayer.borderColor = [UIColor colorWithRed:arc4random() % 100 / 100.0 green:arc4random() % 100 / 100.0 blue:arc4random() % 100 / 100.0 alpha:0.8].CGColor;
    
    for (UIView *v in self.subviews) {
        [v openLayerDebug];
    }
}

- (void)closeLayerDebug {
    debugLayerStatus = false;
    
    self.debugLayer.borderWidth = 0;
    self.debugLayer.borderColor = [UIColor clearColor].CGColor;
    [self.debugLayer removeFromSuperlayer];
    
    for (UIView *v in self.subviews) {
        [v closeLayerDebug];
    }
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    if (debugLayerStatus) {
        [self openLayerDebug];
    } else {
        [self closeLayerDebug];
    }
}

+ (void)openLayerDebug {
    [[[UIApplication sharedApplication] windows] makeObjectsPerformSelector:@selector(openLayerDebug)];
}
+ (void)closeLayerDebug {
    [[[UIApplication sharedApplication] windows] makeObjectsPerformSelector:@selector(closeLayerDebug)];
}
#pragma mark -


- (void)removeAllSubviews {
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
}

- (void)removeAllSubviewsFor:(Class)cls {
    for (UIView *v in self.subviews) {
        if ([v isKindOfClass:cls]) {
            [v removeFromSuperview];
        }
    }
}

- (BOOL)isInView:(UIView *)view {
    UIView *sv = nil;
    while ((sv = [sv superview])) {
        if ([sv isEqual:view])
            return YES;
    }
    return NO;
}

- (BOOL)containsSubview:(UIView *)view {
    NSArray *subviews = self.subviews;
    
    for (UIView *v in subviews) {
        if ([v isEqual:view]) {
            return YES;
        } else if ([v containsSubview:view]) { 
            return YES;
        }
    }
    return NO;
}

- (nullable UIViewController *)viewController {
    UIResponder *responder = self;
    while ((responder = [responder nextResponder])) {
        if ([responder isKindOfClass: [UIViewController class]])
            return (UIViewController *)responder;
    }
    return nil;
}

- (nullable UIWindow *)viewWindow {
    UIView *sv = self;
    while ((sv = [sv superview])) {
        if ([sv isKindOfClass: [UIWindow class]])
            return (UIWindow *)sv;
    }
    return nil;
}

- (UIImage *)viewScreenshot {
    CGSize imageSize = [self bounds].size;
    
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [[self layer] renderInContext:context];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}


#pragma mark -

- (void)moothFromView:(UIView *)sup top:(CGFloat)top animations:(void (^)(void))animations completion:(void (^ __nullable)(BOOL finished))completion {
    
    self.hidden = NO;
    
    float kw = sup.bounds.size.width;
    float kh = sup.bounds.size.height;
    CGSize size = CGSizeMake(self.frame.size.width, self.frame.size.height);
    CGRect rect = CGRectMake(0, top, kw, kh - top);
    
    UIView *containerView = [[UIView alloc] initWithFrame:rect];
    [sup addSubview:containerView];
    
    UIView *view = [[UIView alloc] initWithFrame:containerView.bounds];
    view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
    [view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(__moothDismiss:)]];
    [containerView addSubview:view];
    
    CGPoint center = CGPointMake(size.width * 0.5, size.height * 0.5);
    
    UIViewAutoresizing autoresizingMask = 1 << 3; // UIViewAutoresizingFlexibleTopMargin
    center.y = -size.height * 0.5;
    
    UIView *elasticView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kw, 0)];
    elasticView.clipsToBounds = YES;
    [containerView addSubview:elasticView];
    
    self.center = center;
    self.autoresizingMask = autoresizingMask;
    [elasticView addSubview:self];
    
    [UIView animateWithDuration:1 delay:0 options:7<<16 animations:^{
        
        view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        
        elasticView.frame = (CGRect){0, 0, size};
        
        if (animations) {
            animations();
        }
        
    } completion:^(BOOL finished) {
        if (completion) {
            completion(finished);
        }
    }];
}

- (void)__moothDismiss:(UITapGestureRecognizer *)tap {
    [self moothDismiss];
}

- (void)moothDismiss {
    __weak __typeof(self) _self = self;
    [UIView animateWithDuration:.25 delay:0 options:7<<16 animations:^{
        
        UIView *tapView = [self.superview.superview.subviews firstObject];
        tapView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
        
        UIView *supView = _self.superview;
        CGRect frame = supView.frame;
        frame.size.height = 0;
        supView.frame = frame;
        
    } completion:^(BOOL finished) {
        [_self.superview.superview removeFromSuperview];
        [_self.superview removeFromSuperview];
        [_self removeFromSuperview];
        _self.hidden = YES;
    }];
}

@end
