//
//  UIColor+LhGray.m
//  SmartCity
//
//  Created by luoh on 2021/3/25.
//  Copyright © 2021 StarHome. All rights reserved.
//

#import "UIColor+LhGray.h"
#import <objc/runtime.h>

@implementation UIColor (LhGray)

+(void)lh_colorSwizzldColorMethedWith:(BOOL)changeGray{
    
    Class cls = object_getClass(self);
    
    //将系统提供的colorWithRed:green:blue:alpha:替换掉
    Method originMethod = class_getClassMethod(cls, @selector(colorWithRed:green:blue:alpha:));
    Method swizzledMethod = class_getClassMethod(cls, @selector(lg_colorWithRed:green:blue:alpha:));
    [self swizzleMethodWithOriginSel:@selector(colorWithRed:green:blue:alpha:) oriMethod:originMethod swizzledSel:@selector(lg_colorWithRed:green:blue:alpha:) swizzledMethod:swizzledMethod class:cls];
    
    //将系统提供的colors也替换掉
    NSArray *array = [NSArray arrayWithObjects:@"redColor",@"greenColor",@"blueColor",@"cyanColor",@"yellowColor",@"magentaColor",@"orangeColor",@"purpleColor",@"brownColor",@"systemBlueColor",@"systemGreenColor", nil];
    
    for (int i = 0; i < array.count ; i ++) {
        SEL sel = NSSelectorFromString(array[i]);
        SEL lg_sel = NSSelectorFromString([NSString stringWithFormat:@"lg_%@",array[i]]);
        Method originMethod = class_getClassMethod(cls, sel);
        Method swizzledMethod = class_getClassMethod(cls, lg_sel);
        [self swizzleMethodWithOriginSel:sel oriMethod:originMethod swizzledSel:lg_sel swizzledMethod:swizzledMethod class:cls];
    }
}

+ (void)swizzleMethodWithOriginSel:(SEL)oriSel
                         oriMethod:(Method)oriMethod
                       swizzledSel:(SEL)swizzledSel
                    swizzledMethod:(Method)swizzledMethod
                             class:(Class)cls {
    BOOL didAddMethod = class_addMethod(cls, oriSel, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
    
    if (didAddMethod) {
        class_replaceMethod(cls, swizzledSel, method_getImplementation(oriMethod), method_getTypeEncoding(oriMethod));
    } else {
        method_exchangeImplementations(oriMethod, swizzledMethod);
    }
}

+ (UIColor *)lg_redColor {
    // 1.0, 0.0, 0.0 RGB
    UIColor *color = [self lg_redColor];
    color = [self changeGrayWithColor:color Red:1.0 green:0.0 blue:0.0 alpha:1.0];
    return color;
}

+ (UIColor *)lg_greenColor {
     // 0.0, 1.0, 0.0 RGB
    UIColor *color = [self lg_greenColor];
    color = [self changeGrayWithColor:color Red:0.0 green:1.0 blue:0.0 alpha:1.0];
    return color;
}

+ (UIColor *)lg_blueColor {
    //0.0, 0.0, 1.0
    UIColor *color = [self lg_blueColor];
    color = [self changeGrayWithColor:color Red:0.0 green:0.0 blue:1.0 alpha:1.0];
    return color;
}

+ (UIColor *)lg_cyanColor {
    // 0.0, 1.0, 1.0
    UIColor *color = [self lg_cyanColor];
    color = [self changeGrayWithColor:color Red:0.0 green:1.0 blue:1.0 alpha:1.0];
    return color;
}

+ (UIColor *)lg_yellowColor {
    //1.0, 1.0, 0.0
    UIColor *color = [self lg_yellowColor];
    color = [self changeGrayWithColor:color Red:1.0 green:1.0 blue:0.0 alpha:1.0];
    return color;
}

+ (UIColor *)lg_magentaColor {
    // 1.0, 0.0, 1.0
    UIColor *color = [self lg_magentaColor];
    color = [self changeGrayWithColor:color Red:1.0 green:0.0 blue:1.0 alpha:1.0];
    return color;
}

+ (UIColor *)lg_orangeColor {
    // 1.0, 0.5, 0.0
    UIColor *color = [self lg_orangeColor];
    color = [self changeGrayWithColor:color Red:1.0 green:0.5 blue:0.0 alpha:1.0];
    return color;
}

+ (UIColor *)lg_systemBlueColor {
    UIColor *color = [self lg_systemBlueColor];
    color = [self changeGrayWithColor:color Red:0.0 green:0.0 blue:1.0 alpha:1.0];
    return color;
}

+ (UIColor *)lg_systemGreenColor {
    UIColor *color = [self lg_systemGreenColor];
    color = [self changeGrayWithColor:color Red:0.0 green:1.0 blue:0.0 alpha:1.0];
    return color;
}

+ (UIColor *)lg_purpleColor {
    // 0.5, 0.0, 0.5
    UIColor *color = [self lg_purpleColor];
    color = [self changeGrayWithColor:color Red:0.5 green:0.0 blue:0.5 alpha:1.0];
    return color;
}

+ (UIColor *)lg_brownColor {
    // 0.6, 0.4, 0.2
    UIColor *color = [self lg_brownColor];
    color = [self changeGrayWithColor:color Red:0.6 green:0.4 blue:0.2 alpha:1.0];
    return color;
}

+ (instancetype)lg_colorWithRed:(CGFloat)r green:(CGFloat)g blue:(CGFloat)b alpha:(CGFloat)a {
    
    UIColor *color = [self lg_colorWithRed:r green:g blue:b alpha:a];
    if (r == 0 && g == 0 && b == 0) {
        return color;
    }
    color = [self changeGrayWithColor:color Red:r green:g blue:b alpha:a];
    return  color;
}

+ (UIColor *)changeGrayWithColor:(UIColor *)color Red:(CGFloat)r green:(CGFloat)g blue:(CGFloat)b alpha:(CGFloat)a {
    CGFloat gray = r * 0.299 +g * 0.587 + b * 0.114;
    UIColor *grayColor = [UIColor colorWithWhite:gray alpha:a];
    return  grayColor;
}

@end
