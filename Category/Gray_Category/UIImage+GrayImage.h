//
//  UIWebView+Gray.h
//
//
//

#import <UIKit/UIKit.h>
#import <objc/runtime.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (GrayImage)

//转化灰度
- (UIImage *)grayImage;

+(void)lh_imageSwizzldMethedWith:(BOOL)changeGray;

@end

NS_ASSUME_NONNULL_END
