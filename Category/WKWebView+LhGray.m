//
//  WKWebView+LhGray.m
//  SmartCity
//
//  Created by luoh on 2021/3/25.
//  Copyright © 2021 StarHome. All rights reserved.
//

#import "WKWebView+LhGray.h"
#import <objc/runtime.h>
#import "SCConst.h"

@implementation WKWebView (LhGray)

+(void)lh_WKWebViewWizzldMethedWith:(BOOL)changeGray{
    if (changeGray == false) {
        return;
    }
    
    Method originalMethod = class_getInstanceMethod([self class], @selector(initWithFrame:configuration:));
    Method swizzledMethod = class_getInstanceMethod([self class], @selector(lg_initWithFrame:configuration:));
    method_exchangeImplementations(originalMethod, swizzledMethod);
}


- (instancetype)lg_initWithFrame:(CGRect)frame configuration:(WKWebViewConfiguration *)configuration {
    // js脚本
    NSString *jScript = @"var filter = '-webkit-filter:grayscale(100%);-moz-filter:grayscale(100%); -ms-filter:grayscale(100%); -o-filter:grayscale(100%) filter:grayscale(100%);';document.getElementsByTagName('html')[0].style.filter = 'grayscale(100%)';";
    // 注入
    WKUserScript *wkUScript = [[WKUserScript alloc] initWithSource:jScript injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
                 
    WKUserContentController *userController = [[WKUserContentController alloc] init];
    [userController addUserScript:wkUScript];
    
    // 配置对象
    WKWebViewConfiguration *wkWebConfig = [[WKWebViewConfiguration alloc] init];
    wkWebConfig.userContentController = userController;
    configuration = wkWebConfig;
    WKWebView *webView = [self lg_initWithFrame:frame configuration:configuration];
    return webView;
}


@end
