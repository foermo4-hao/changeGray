//
//  UIColor+GrayColor.m
//
//
//

#import "UIImage+GrayImage.h"

@implementation UIImage (GrayImage)

+(void)lh_imageSwizzldMethedWith:(BOOL)changeGray{
    
    if (changeGray == false) {
        return;
    }
    //交换方法
    Class cls = object_getClass(self);
    Method originMethod = class_getClassMethod(cls, @selector(imageNamed:));
    Method swizzledMethod = class_getClassMethod(cls, @selector(lg_imageNamed:));
    
    [self swizzleMethodWithOriginSel:@selector(imageNamed:) oriMethod:originMethod swizzledSel:@selector(lg_imageNamed:) swizzledMethod:swizzledMethod class:cls];
    
    Method originMethod1 = class_getClassMethod(cls, @selector(imageWithData:));
    Method swizzledMethod1 = class_getClassMethod(cls, @selector(lg_imageWithData:));
    [self swizzleMethodWithOriginSel:@selector(imageWithData:) oriMethod:originMethod1 swizzledSel:@selector(lg_imageWithData:) swizzledMethod:swizzledMethod1 class:cls];
    
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

+ (UIImage *)lg_imageWithData:(NSData *)data {
    UIImage *image = [self lg_imageWithData:data];
    return [image grayImage];
}

+ (UIImage *)lg_imageNamed:(NSString *)name {
    UIImage *image = [self lg_imageNamed:name];
    return [image grayImage];
}

// 转化灰度
- (UIImage *)grayImage {
    const int RED =1;
    const int GREEN =2;
    const int BLUE =3;

    // Create image rectangle with current image width/height
    CGRect imageRect = CGRectMake(0,0, self.size.width* self.scale, self.size.height* self.scale);

    int width = imageRect.size.width;
    int height = imageRect.size.height;

    // the pixels will be painted to this array
    uint32_t *pixels = (uint32_t*) malloc(width * height *sizeof(uint32_t));

    // clear the pixels so any transparency is preserved
    memset(pixels,0, width * height *sizeof(uint32_t));

    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();

    // create a context with RGBA pixels
    CGContextRef context = CGBitmapContextCreate(pixels, width, height,8, width *sizeof(uint32_t), colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedLast);

    // paint the bitmap to our context which will fill in the pixels array
    CGContextDrawImage(context,CGRectMake(0,0, width, height), [self CGImage]);

    for(int y = 0; y < height; y++) {
        for(int x = 0; x < width; x++) {
            uint8_t *rgbaPixel = (uint8_t*) &pixels[y * width + x];

            // convert to grayscale using recommended method: http://en.wikipedia.org/wiki/Grayscale#Converting_color_to_grayscale
            uint32_t gray = 0.3 * rgbaPixel[RED] +0.59 * rgbaPixel[GREEN] +0.11 * rgbaPixel[BLUE];

            // set the pixels to gray
            rgbaPixel[RED] = gray;
            rgbaPixel[GREEN] = gray;
            rgbaPixel[BLUE] = gray;
        }
    }

    // create a new CGImageRef from our context with the modified pixels
    CGImageRef imageRef = CGBitmapContextCreateImage(context);

    // we're done with the context, color space, and pixels
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    free(pixels);

    // make a new UIImage to return
    UIImage *resultUIImage = [UIImage imageWithCGImage:imageRef scale:self.scale orientation:UIImageOrientationUp];

    // we're done with image now too
    CGImageRelease(imageRef);

    return resultUIImage;
}


@end
