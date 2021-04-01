//
//  UILabel+LhGray.m
//  SmartCity
//
//  Created by luoh on 2021/3/26.
//  Copyright © 2021 StarHome. All rights reserved.
//

#import "UILabel+LhGray.h"
#import <objc/runtime.h>

@implementation UILabel (LhGray)

+(void)lh_lableSwizzldMethedWith:(BOOL)changeGray{
    
    if (changeGray == false) {
        return;
    }
    
    Class class = [self class];
    
    SEL originalSelector = @selector(setTextColor:);
    SEL swizzledSelector = @selector(lh_setLableTextColor:);
    
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    BOOL didAddMethod = class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
    if (didAddMethod) {
        class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}


- (void)lh_setLableTextColor:(UIColor *)color {
   UIColor * newColor = [self changeGrayWithColor:[UIColor redColor] Red:1.0 green:0.0 blue:0.0 alpha:1.0];
    [self lh_setLableTextColor:newColor];
    
}
- (UIColor *)changeGrayWithColor:(UIColor *)color Red:(CGFloat)r green:(CGFloat)g blue:(CGFloat)b alpha:(CGFloat)a {
    CGFloat gray = r * 0.299 +g * 0.587 + b * 0.114;
    UIColor *grayColor = [UIColor colorWithWhite:gray alpha:a];
    return  grayColor;
}

@end
