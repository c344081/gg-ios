//
//  MBProgressHUD+Extension.m
//  gg-iOS
//
//  Created by zoxuner on 2017/11/4.
//  Copyright © 2017年 c344081. All rights reserved.
//

#import "MBProgressHUD+Extension.h"
#import <objc/runtime.h>

@implementation MBProgressHUD (Extension)

+ (void)initialize {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Method m1 = class_getInstanceMethod(MBProgressHUD.class, @selector(initWithFrame:));
        Method m2 = class_getInstanceMethod(MBProgressHUD.class, @selector(myInitWithFrame:));
        method_exchangeImplementations(m1, m2);
    });
}

- (instancetype)myInitWithFrame:(CGRect)frame {
    __auto_type hud = [self myInitWithFrame:frame];
    hud.bezelView.color = [UIColor blackColor];
    hud.contentColor = UIColor.whiteColor;
    return hud;
}

@end
