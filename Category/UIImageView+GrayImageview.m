//
//  UIColor+GrayColor.m
//
//  
//

#import "UIImageView+GrayImageview.h"
#import "UIImage+GrayImage.h"
#import <objc/runtime.h>

@implementation UIImageView (GrayImageview)

+(void)lh_imageViewSwizzldMethedWith:(BOOL)changeGray;{
    
    if (changeGray == false) {
        return;
    }
    
    Class class = [self class];
    
    SEL originalSelector = @selector(setImage:);
    SEL swizzledSelector = @selector(swizzled_setImage:);
    
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    BOOL didAddMethod = class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
    if (didAddMethod) {
        class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}


- (void)swizzled_setImage:(UIImage *)image {
    //系统键盘处理（如果不过滤，这系统键盘字母背景是黑色）
    if ([self.superview isKindOfClass:NSClassFromString(@"UIKBSplitImageView")]) {
        [self swizzled_setImage:image];
        return;
    }
    UIImage *im = [[image grayImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//    UIImage *im = [image grayImage];
    [self swizzled_setImage:im];
}

@end
