//
//  UINavigationBar+LhGray.m
//  SmartCity
//
//  Created by luoh on 2021/3/25.
//  Copyright © 2021 StarHome. All rights reserved.
//

#import "UINavigationBar+LhGray.h"
#import <objc/runtime.h>
#import "UIImage+GrayImage.h"

@implementation UINavigationBar (LhGray)
+(void)lh_navigationBarSwizzldMethedWith:(BOOL)changeGray{
    if (changeGray == false) {
        return;
    }
    Class cls = [self class];
    
    SEL oriSel = @selector(setBarTintColor:);
    SEL swizzldSel = @selector(lh_setNavBarTintColor:);
    
    Method originMethed = class_getInstanceMethod(cls, oriSel);
    Method swizzldMethed = class_getInstanceMethod(cls, swizzldSel);
    
    BOOL isAddMethed = class_addMethod(cls, oriSel, method_getImplementation(swizzldMethed),method_getTypeEncoding(swizzldMethed));
    if (isAddMethed) {
        class_replaceMethod(cls, swizzldSel, method_getImplementation(originMethed), method_getTypeEncoding(originMethed));
    }else{
        method_exchangeImplementations(originMethed,swizzldMethed);
    }
    
}

- (void)lh_setNavBarTintColor:(UIColor *)color{
    UIColor * newColor = [self changeGrayWithColor:color Red:1.0 green:0.0 blue:0.0 alpha:1.0];
    [self lh_setNavBarTintColor:newColor];

}

- (UIColor *)changeGrayWithColor:(UIColor *)color Red:(CGFloat)r green:(CGFloat)g blue:(CGFloat)b alpha:(CGFloat)a {
    CGFloat gray = r * 0.299 +g * 0.587 + b * 0.114;
    UIColor *grayColor = [UIColor colorWithWhite:gray alpha:a];
    return  grayColor;
}


@end
