//
//  UITabBarItem+LhGray.m
//  SmartCity
//
//  Created by luoh on 2021/3/25.
//  Copyright © 2021 StarHome. All rights reserved.
//

#import "UITabBarItem+LhGray.h"
#import <objc/runtime.h>

@implementation UITabBarItem (LhGray)
+ (void)lh_tabbarItemSwizzldMethedWith:(BOOL)changeGray{
    if (changeGray == false) {
        return;
    }
    Class cls = [self class];
    
    SEL oriSel = @selector(setSelectedImage:);
    SEL swizzldSel = @selector(lh_setTabbarItemImage:);
    
    Method originMethed = class_getInstanceMethod(cls, oriSel);
    Method swizzldMethed = class_getInstanceMethod(cls, swizzldSel);
    
    BOOL isAddMethed = class_addMethod(cls, oriSel, method_getImplementation(swizzldMethed),method_getTypeEncoding(swizzldMethed));
    if (isAddMethed) {
        class_replaceMethod(cls, swizzldSel, method_getImplementation(originMethed), method_getTypeEncoding(originMethed));
    }else{
        method_exchangeImplementations(originMethed,swizzldMethed);
    }
}
- (void)lh_setTabbarItemImage:(UIImage *)image {
    UIImage *im = [[self imageToTransparent:image] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [self lh_setTabbarItemImage:im];
}

- (UIImage*)imageToTransparent:(UIImage*) image
{
    // 分配内存
    const int imageWidth = image.size.width;
    const int imageHeight = image.size.height;
    size_t bytesPerRow = imageWidth * 4;
    uint32_t* rgbImageBuf = (uint32_t*)malloc(bytesPerRow * imageHeight);

    // 创建context
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(rgbImageBuf, imageWidth, imageHeight, 8, bytesPerRow, colorSpace,
                                                 kCGBitmapByteOrder32Little | kCGImageAlphaNoneSkipLast);
    CGContextDrawImage(context, CGRectMake(0, 0, imageWidth, imageHeight), image.CGImage);

    // 遍历像素
    int pixelNum = imageWidth * imageHeight;
    uint32_t* pCurPtr = rgbImageBuf;
    for (int i = 0; i < pixelNum; i++, pCurPtr++)
    {
        uint8_t* ptr = (uint8_t*)pCurPtr;
        if (ptr[3] < 50 && ptr[3] < 50 && ptr[1] < 50) {
            ptr[0] = 0;
        } else {
// 灰度算法
            uint8_t gray = ptr[3] * 0.299 + ptr[2] * 0.587 + ptr[1] * 0.114;
            ptr[3] = gray; //0~255
            ptr[2] = gray;
            ptr[1] = gray;
        }
    }

    // 将内存转成image
    CGDataProviderRef dataProvider =CGDataProviderCreateWithData(NULL, rgbImageBuf, bytesPerRow * imageHeight, ProviderReleaseData);

    CGImageRef imageRef = CGImageCreate(imageWidth, imageHeight,8, 32, bytesPerRow, colorSpace,
                                        kCGImageAlphaLast |kCGBitmapByteOrder32Little, dataProvider,
                                        NULL, true,kCGRenderingIntentDefault);
    CGDataProviderRelease(dataProvider);

    UIImage* resultUIImage = [UIImage imageWithCGImage:imageRef];

    // 释放
    CGImageRelease(imageRef);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);

    return resultUIImage;
}

void ProviderReleaseData (void *info, const void *data, size_t size)
{
    free((void*)data);
}

@end
